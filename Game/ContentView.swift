//
//  ContentView.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 29.10.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    LazyVGrid(columns: viewModel.columns, spacing: 10) {
                        ForEach(0..<9) { i in
                            ZStack {
                                Circle()
                                    .foregroundColor(.green)
                                    .frame(width: geometry.size.width / 3.5,
                                           height: geometry.size.width / 3.5)
                                Image(systemName: viewModel.movies[i]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: geometry.size.width / 6, height: geometry.size.width / 6, alignment: .center)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                viewModel.processPlayerMove(for: i)
                            }
                        }
                    }
                }
                .disabled(viewModel.isGameboard)
                .padding()
                .alert(item: $viewModel.alertItem, content: { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.massage,
                          dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
