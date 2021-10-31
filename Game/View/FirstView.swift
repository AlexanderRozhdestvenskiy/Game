//
//  FirstView.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 30.10.2021.
//

import SwiftUI

struct FirstView: View {
    
    @State private var green = false
    @State private var blue = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Color")
                    .font(Font.system(size: 88))
                
                VStack(alignment: .trailing) {
                    GreenButtonView(checked: $green)
                    BlueButtonView(checked: $blue)
                }
                
                Spacer()
                
                NavigationLink(destination: GameView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36)
                            .frame(width: 300, height: 120, alignment: .center)
                            .foregroundColor(.green)
                        Text("GO")
                            .foregroundColor(.white)
                            .font(Font.system(size: 64))
                            .bold()
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
