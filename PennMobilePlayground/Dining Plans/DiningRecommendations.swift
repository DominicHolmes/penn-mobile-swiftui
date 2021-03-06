//
//  DiningRecommendations.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/4/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct DiningPlan {
    // Defined on a per-semester (not annual) basis
    let name: String
    let acronym: String
    let swipes: Int
    let dollars: Int
    let cost: Int
    
    var estimatedCostPerSwipe: Double {
        guard swipes > 0 else { return 0 }
        let swipesValue: Double = (1600 / 1575)
        return (Double(cost) - (Double(dollars) * swipesValue)) / Double(swipes)
    }
    
    var estimatedCostPerDiningDollar: Double {
        guard dollars > 0 else { return 0.0 }
        return Double(1575.0 / 1600.0)
    }
    
    var estimatedSwipesPerWeek: Double {
        return Double(swipes) / 15.0
    }
    
    var estimatedDollarsPerWeek: Double {
        return Double(dollars) / 15.0
    }
}

struct DiningRecommendations: View {
    let plans: [DiningPlan] = [
    .init(name: "Away From Kitchen", acronym: "AFK", swipes: 240, dollars: 140, cost: 2795),
    .init(name: "Balanced Eating Naturally", acronym: "BEN", swipes: 170, dollars: 225, cost: 2795),
    .init(name: "Best Food Fit", acronym: "BFF", swipes: 138, dollars: 400, cost: 2795),
    .init(name: "One Meal Works", acronym: "OMW", swipes: 89, dollars: 575, cost: 2200),
    .init(name: "Club and Activities", acronym: "CAP", swipes: 51, dollars: 600, cost: 1550),
    .init(name: "Take Your Pick 25", acronym: "TYP25", swipes: 25, dollars: 875, cost: 1385),
    .init(name: "Take Your Pick 19", acronym: "TYP19", swipes: 19, dollars: 875, cost: 1265),
    .init(name: "Take Your Pick 13", acronym: "TYP13", swipes: 13, dollars: 875, cost: 1445),
    .init(name: "Any Time Meal", acronym: "ATM", swipes: 0, dollars: 1600, cost: 1575)
    ]
    
    // There are 9 different swipe values
    // There are 7 different dollar values
    // Slider goes from index 0 to 8
    @State var sliderValue = 2.0
    @State var semesters: Int = 1

    var chosenPlan: DiningPlan {
        return plans[Int(sliderValue.rounded())]
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    Group {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Dining Plan")
                    }
                    .font(Font.body.weight(.medium))
                    .foregroundColor(.green)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(chosenPlan.name) Plan")
                        .fontWeight(.medium)
                        Spacer()
                        Text("\(chosenPlan.acronym)")
                        .fontWeight(.medium)
                        .foregroundColor(Color.primary.opacity(0.5))
                    }
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("$\(chosenPlan.cost * semesters)")
                        .font(Font.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("per \(semesters == 1 ? "semester" : "year")")
                        .font(Font.caption.weight(.bold)).foregroundColor(.gray)
                        Spacer()
                    }
                }
                
                Divider().padding([.bottom])
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            Text("\(chosenPlan.dollars * semesters)")
                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                            Text("Dining Dollars")
                            .font(Font.caption.weight(.bold)).foregroundColor(.gray)
                        }.padding(.bottom, 6)
                        
                        Text("\(chosenPlan.estimatedDollarsPerWeek, specifier: "%.2f") DD per week")
                            .font(Font.caption.weight(.regular)).foregroundColor(.gray)
                            .opacity(0.8)
                        Text("$\(chosenPlan.estimatedCostPerDiningDollar, specifier: "%.2f") per DD")
                            .font(Font.caption.weight(.regular)).foregroundColor(.gray)
                            .opacity(0.8)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                            Text("\(chosenPlan.swipes * semesters)")
                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                            Text("Swipes")
                            .font(Font.caption.weight(.bold)).foregroundColor(.gray)
                        }.padding(.bottom, 6)

                        Text("\(chosenPlan.estimatedSwipesPerWeek, specifier: "%.1f") per Week")
                            .font(Font.caption.weight(.regular)).foregroundColor(.gray)
                            .opacity(0.8)
                        Text("$\(chosenPlan.estimatedCostPerSwipe, specifier: "%.2f") per Swipe")
                            .font(Font.caption.weight(.regular)).foregroundColor(.gray)
                            .opacity(0.8)
                    }
                }
                .padding(.bottom)
                
                SwiftUISlider(min: 0, max: 8, minTrackColor: .systemGreen, maxTrackColor: .systemBlue, minImageName: "dollarsign.circle.fill", maxImageName: "creditcard.fill", value: $sliderValue)
                .padding(.bottom)
                
                
                Picker("Pick semester or annual prices", selection: $semesters) {
                    ForEach(1...2, id: \.self) {
                        Text("\($0 == 1 ? "Per Semester" : "Per Year")")
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct DiningRecommendations_Previews: PreviewProvider {
    static var previews: some View {
        DiningRecommendations()
    }
}
