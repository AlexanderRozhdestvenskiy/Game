//
//  ContentView.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 29.10.2021.
//

import SwiftUI

let columns: [GridItem] = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]

struct ContentView: View {
    
    @State private var movies: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboard = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.green)
                                .opacity(0.9)
                                .frame(width: geometry.size.width / 3 - 18,
                                       height: geometry.size.width / 3 - 18)
                            Image(systemName: movies[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquereOcupated(in: movies, forIndex: i) { return }
                            movies[i] = Move(player: .human, boardIndex: i)
                            isGameboard = true
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                let computerPosition = determine(in: movies)
                                movies[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboard = false
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboard)
            .padding()
        }
    }
    
    func isSquereOcupated(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index } )
    }
    
    func determine(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquereOcupated(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
}

enum Player {
    case human
    case computer
}

struct Move {
    var player: Player
    var boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
