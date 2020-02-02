//
//  FrequentLocationsView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/5/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct DiningLocationFrequency {
    let location: String
    let totals: [Double]
    let color: Color
}

struct FrequentLocationsView: View {
    
    enum LengthOfTime: CaseIterable {
        case week, month, semester
    }
    
    let data: [DiningLocationFrequency] = [
        .init(location: "Houston Market", totals: [29.34, 70.82, 114.53], color: .red),
        .init(location: "Pret a Manger", totals: [4.32, 22.56, 123.33], color: .yellow),
        .init(location: "Accenture Cafe", totals: [14.24, 17.89, 21.25], color: .orange),
        .init(location: "MBA Cafe", totals: [16.42, 16.42, 55.24], color: .green),
        .init(location: "Starbucks under Commons", totals: [12.67, 15.67, 30.45], color: .blue),
        .init(location: "Gourmet Grocer", totals: [0.0, 12.24, 12.24], color: .purple)
    ]
    
    @State private var portions: [Double] = [0.25, 0.3, 0.125, 0.125, 0.2]
    @State private var colors: [Color] = [.orange, .yellow, .green, .blue, .pink, .purple, .red]
    
    @State private var lengthOfTime: Int = 0
    
    func computeTotal(for lengthOfTime: Int) -> [Double] {
        let sum = data.reduce(0.0) { (result, freq) -> Double in
            result + freq.totals[lengthOfTime]
        }
        var values = [Double]()
        for freq in data {
            values.append(freq.totals[lengthOfTime] / sum)
        }
        return values
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Dining Locations")
                }
                .font(Font.body.weight(.medium))
                .foregroundColor(.green)
                
                Text("Your dining dollar totals for each location over the last \(["week", "month", "semester"][lengthOfTime]).")
                .fontWeight(.medium)
                .lineLimit(nil)
                .frame(height: 44)
            }
            
            Divider()
                .padding([.top, .bottom])
            
            PortionView(portions: self.$portions, colors: self.$colors)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .frame(height: 20)
            .padding(.bottom)
            .opacity(0.6)
            
            VStack(alignment: .leading) {
                ForEach(self.data.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(self.data[index].color)
                        Text(self.data[index].location)
                        Spacer()
                        Text("$\(self.data[index].totals[self.lengthOfTime], specifier: "%.2f")")
                    }
                }
            }
            
            Picker("Pick a time frame", selection: $lengthOfTime) {
                ForEach(0...2, id: \.self) { index in
                    Text(["This Week", "This Month", "This Semester"][index])
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top)
            .onReceive([self.lengthOfTime].publisher.first()) { (output) in
                withAnimation {
                    self.portions = self.computeTotal(for: self.lengthOfTime)
                }
            }
            
        }
    }
}

struct FrequentLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        FrequentLocationsView()
    }
}
