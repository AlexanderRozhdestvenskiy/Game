//
//  ViewModel.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 30.10.2021.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var movies: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboard = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquereOcupated(in: movies, forIndex: position) { return }
        movies[position] = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human, in: movies) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDrow(in: movies) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboard = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
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
