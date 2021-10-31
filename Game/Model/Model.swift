//
//  Model.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 30.10.2021.
//

import Foundation

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
