//
//  Alerts.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 29.10.2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var massage: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    massage: Text("You are so smart"),
                                    buttonTitle: Text("Hell yeah"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                                       massage: Text("You programmed a super AI"),
                                       buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw"),
                                massage: Text("What a battle of wits we have here..."),
                                buttonTitle: Text("Try again"))
}
