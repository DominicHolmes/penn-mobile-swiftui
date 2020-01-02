//
//  ContentView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 12/27/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct PrivacyOption: Identifiable {
    var title: String
    var description: String
    @State var isActive: Bool
    var note: String? = ""
    let id = UUID()
}

struct ContentView: View {
    
    @State private var options: [PrivacyOption] = [
    .init(title: "Share basic profile information", description: "This includes your name, year, major, and gender (if you've selected one). This information is used to present more relevant homepage cards; for example, the 2021 Class Board may choose to target all 2021 CIS and NETS majors.", isActive: true),
    .init(title: "Share anonymized course enrollment statistics", description: "This data is kept seperate from your profile information, and is used to generate useful course recommendations on other Penn Labs products.", isActive: true),
    .init(title: "Share dining transactions", description: "This data is used to display your current balance, as well as spending activity. We also use aggregate data to generate statistics about dining hall activity, such as the busiest times of each day.", isActive: true, note: "Disabling will remove all dining balance features.")
    ]
    var body: some View {
        List(options) { option in
            VStack(alignment: .leading) {
                HStack {
                    Text(option.title)
                        .font(.headline)
                    Spacer()
                    Toggle(isOn: option.$isActive) {
                        Text("Toggle privacy option")
                    }.labelsHidden()
                }
                Text(option.description)
                    .font(.caption)
                 Text(option.note ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
