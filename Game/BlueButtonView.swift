//
//  BlueButtonView.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 30.10.2021.
//

import SwiftUI

struct BlueButtonView: View {
    
    @Binding var checked: Bool
    
    var body: some View {
        Button(action: { checked.toggle() }) {
            HStack {
                Text("Blue")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Toggle(isOn: $checked) {
                    Text("Complete")
                }
                .toggleStyle(.circle)
            }
        }
        .buttonStyle(.plain)
    }
}
