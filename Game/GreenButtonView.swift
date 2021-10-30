//
//  GreenButtonView.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 30.10.2021.
//

import SwiftUI

struct GreenButtonView: View {
    
    @Binding var checked: Bool
    
    var body: some View {
        Button(action: { checked.toggle() }) {
            HStack {
                Text("Green")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Toggle(isOn: $checked) {
                    Text("Complete")
                }
                .toggleStyle(.circle)
            }
        }
        .buttonStyle(.plain)
    }
}
