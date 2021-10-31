//
//  AccountView.swift
//  Game
//
//  Created by Alexander Rozhdestvenskiy on 30.10.2021.
//

import SwiftUI

struct AccountView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthdate = Date()
    @State private var should = false
    @State private var numberOfLikes = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                }
                
                Section(header: Text("Actions")) {
                    Toggle("Sent Newsletter", isOn: $should)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                    Stepper("Number of Likes", value: $numberOfLikes, in: 0...10)
                    Text("This video has \(numberOfLikes) likes")
                    Link("Go to Apple", destination: URL(string: "https://www.apple.com")!)
                }
            }
            .accentColor(.red)
            .navigationTitle("Account")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
