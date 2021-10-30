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
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.green)
                                .opacity(0.99)
                                .frame(width: geometry.size.width / 3 - 18,
                                       height: geometry.size.width / 3 - 18)
                            Image(systemName: movies[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5, alignment: .center)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquereOcupated(in: movies, forIndex: i) { return }
                            movies[i] = Move(player: .human, boardIndex: i)
                            
                            if checkWinCondition(for: .human, in: movies) {
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDrow(in: movies) {
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            isGameboard = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let computerPosition = determineComputerPosition(in: movies)
                                movies[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboard = false
                                
                                if checkWinCondition(for: .computer, in: movies) {
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                
                                if checkForDrow(in: movies) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboard)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.massage,
                      dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
            })
        }
    }
    
    func isSquereOcupated(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index } )
    }
    
    func determineComputerPosition(in moves: [Move?]) -> Int {
        
        // if AI can win, then win
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
                                          [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(computerPosition)
            
            if winPosition.count == 1 {
                let isAviable = !isSquereOcupated(in: moves, forIndex: winPosition.first!)
                if isAviable { return winPosition.first! }
            }
        }
        
        // if AI can't win, then block
        
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(humanPosition)
            
            if winPosition.count == 1 {
                let isAviable = !isSquereOcupated(in: moves, forIndex: winPosition.first!)
                if isAviable { return winPosition.first! }
            }
        }
        
        // if AI can't block, than take middle square
        
        let centerSquare = 4
        if !isSquereOcupated(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // if AI can't take middle square
        
        var movePosition = Int.random(in: 0..<9)
        
        while isSquereOcupated(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
                                          [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) { return true }
        
        return false
    }
    
    func checkForDrow(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        movies = Array(repeating: nil, count: 9)
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
            .preferredColorScheme(.dark)
    }
}
