//
//  DiningVisualizations.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/1/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct CardView<Content> : View where Content : View {
    let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(self.colorScheme == ColorScheme.light ? Color.white : Color.gray.opacity(0.2))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
            self.content()
        }
    }
}

struct DiningBalanceView: View {
    
    let description: String
    let image: Image
    @State var balance: Double
    
    // By default, remove trailing zeros
    var specifier: String = "%g"
    var color: Color = .blue
    
    var body: some View {
        CardView {
            VStack(alignment: .trailing) {
                HStack {
                    self.image.font(Font.system(size: 24).weight(.bold))
                    Spacer()
                    Text("\(self.balance, specifier: self.specifier)")
                        .font(.system(size: 24, design: .rounded))
                        .fontWeight(.bold)
                }
                .foregroundColor(self.color)
                Text(self.description)
                    .font(.subheadline)
                    .opacity(0.5)
            }
            .padding()
        }
    }
}

struct DiningVisualizations: View {
    
    @State var selectedData: Int? = nil
    @State var toggleOn: Bool = true
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var data: [CGFloat] {
        return toggleOn ? [1.0, 0.7, 0.6, 0.4, 0.38, 0.35, 0.3] : [0, 0, 0, 0, 0, 0, 0]
    }
    
    var lineData: [CGFloat] {
        return [0.2, 0.5, 0.6, 0.2, 0.7, 0.0, 0.9]
    }
    
    var trimEnd: CGFloat {
        return toggleOn ? 1.0 : 0.0
    }
    
    let weekDollarData: [CGFloat] = [0.2, 1.0, 0.6, 0.001, 0.05, 0.15, 0.9]
    let lastWeekDollarData: [CGFloat] = (0..<7).map { _ in CGFloat.random(in: 0.0...1.0) }
    var dollarData: [CGFloat] {
        return timeFrame == "This Week" ? weekDollarData : lastWeekDollarData
    }
    
    @State var axisOffset: CGFloat = 0.0
    
    var averageDollar: CGFloat {
        return (self.dollarData.reduce(0, +) / CGFloat(self.dollarData.count))
    }
    
    var spacingForDollarData: CGFloat {
        return self.dollarData.count <= 7 ? 6 : (self.dollarData.count <= 33 ? 2 : 0)
    }
    
    var dayOfWeek = ["M", "T", "W", "T", "F", "S", "S", "M", "T", "W", "T", "F", "S", "S", "M", "T", "W", "T", "F", "S", "S"]
    
    let timeFrames = ["This Week", "Last Week"]
    @State private var timeFrame = "This Week"
    
    var dayValue: String {
        switch selectedData {
        case 0: return "Monday"
        case 1: return "Tuesday"
        case 2: return "Wednesday"
        case 3: return "Thursday"
        case 4: return "Friday"
        case 5: return "Saturday"
        case 6: return "Sunday"
        default: return ""
        }
    }
    
    let yAxisLabels = ["400", "200", "0"]
    let xAxisLabels = ["8/14", "9/14", "10/14", "11/14"]
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    // Balance row 1
                    HStack {
                        DiningBalanceView(description: "Swipes", image: Image(systemName: "creditcard.fill"), balance: 58.00, specifier: "%.f", color: .green)
                            .padding(.leading)
                            .padding(.trailing, 5)
                        
                        DiningBalanceView(description: "Dining Dollars", image: Image(systemName: "dollarsign.circle.fill"), balance: 427.84, specifier: "%.2f")
                            .padding(.leading, 5)
                            .padding(.trailing)
                    }.padding(.top)
                    
                    // Balance row 2
                    HStack {
                        DiningBalanceView(description: "Guest Swipes", image: Image(systemName: "person.2.fill"), balance: 7.00, specifier: "%.f", color: .purple)
                            .padding(.leading)
                            .padding(.trailing, 5)
                        
                        DiningBalanceView(description: "Penn Cash", image: Image(systemName: "p.square.fill"), balance: 427.84, specifier: "%.2f", color: .orange)
                            .padding(.leading, 5)
                            .padding(.trailing)
                    }
                    .padding([.top, .bottom])
                }
                
                Group {
                    CardView {
                        TransactionsCardView()
                        .padding()
                    }
                .padding()
                }
                Group {
                    CardView {
                        VStack(alignment: .leading) {
                            CardHeader(color: .purple, icon: .predictions, text: "Swipe Predictions")
                            
                            Text("Log into Penn Mobile often to get more accurate predictions.")
                                .fontWeight(.medium)
                            
                            Divider()
                                .padding([.top, .bottom])
                            
                            VStack(alignment: .leading) {
                                
                                HStack(alignment: .top, spacing: 20) {
                                    // Y-Axis labels
                                    VStack(alignment: .center) {
                                        ForEach(0 ..< self.yAxisLabels.count) { num in
                                            if num != 0 { Spacer() }
                                            Text(self.yAxisLabels[num])
                                                .font(.subheadline)
                                                .opacity(0.5)
                                        }
                                    }
                                    .frame(height: 100)
                                    
                                    // Graph
                                    VStack {
                                        GraphPath(data: self.data).stroke(
                                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                                        )
                                            .foregroundColor(.blue)
                                            .frame(height: 100)
                                            .animation(.default)
                                        
                                        // X-Axis labels
                                        HStack {
                                            ForEach(0 ..< self.xAxisLabels.count) { num in
                                                if num != 0 { Spacer() }
                                                Text(self.xAxisLabels[num])
                                                    .font(.subheadline)
                                                    .opacity(0.5)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 100)
                                .padding([.top, .bottom])
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Out of Swipes")
                                            .font(.caption)
                                        Text("Dec. 15th")
                                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                                    }
                                    .padding([.trailing, .top, .bottom])
                                    
                                    Divider()
                                        .padding([.leading, .trailing])
                                    
                                    VStack(alignment: .leading) {
                                        Text("Out of Dining Dollars")
                                            .font(.caption)
                                        Text("Dec. 2nd")
                                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                                    }
                                    Spacer()
                                }
                                Text("Based on your current balance and past behavior, we project you have this many days of balance remaining.")
                                    .font(.caption).frame(height: 36)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
                
                Group {
                    CardView {
                        VStack(alignment: .leading) {
                            CardHeader(color: .purple, icon: .predictions, text: "Predictions")
                            
                            Text("Log into Penn Mobile often to get more accurate predictions.")
                                .fontWeight(.medium)
                            
                            Divider()
                                .padding([.top, .bottom])
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Swipes Remaining")
                                            .font(.caption)
                                        Text("46 days")
                                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                                    }
                                    .padding([.trailing, .top, .bottom])
                                    
                                    Divider()
                                        .padding(.trailing)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Dining Dollars Remaining")
                                            .font(.caption)
                                        Text("21 days")
                                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                                    }
                                    Spacer()
                                }
                                Text("Based on your current balance and past behavior, we project you'll run out of balance on this date.")
                                    .font(.caption).frame(height: 36)
                                    .padding(.bottom)
                                    .foregroundColor(.gray)
                                
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Out of Swipes")
                                            .font(.caption)
                                        Text("Dec. 15th")
                                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                                    }
                                    .padding([.trailing, .top, .bottom])
                                    
                                    Divider()
                                        .padding([.leading, .trailing])
                                    
                                    VStack(alignment: .leading) {
                                        Text("Out of Dining Dollars")
                                            .font(.caption)
                                        Text("Dec. 2nd")
                                            .font(Font.system(size: 21, weight: .bold, design: .rounded))
                                    }
                                    Spacer()
                                }
                                Text("Based on your current balance and past behavior, we project you have this many days of balance remaining.")
                                    .font(.caption).frame(height: 36)
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
                
                Group {
                    CardView {
                        LineGraphView(data: [1.0, 0.86, 0.85, 0.7, 0.67, 0.5, 0.45, 0.4, 0.3, 0.0], yAxisLabels: ["240", "180", "120", "60"], xAxisLabels: ["8/14", "9/14", "10/14", "11/14"], header: CardHeader(color: .blue, icon: .swipes, text: "Swipes"), headerText: "Your balance over the semester.", color: .blue)
                            .padding()
                    }
                    .padding()
                    
                    CardView {
                        LineGraphView(data: [1.0, 0.95, 0.92, 0.7, 0.3, 0.21, 0.19, 0.1, 0.09, 0.0], yAxisLabels: ["400", "310", "220", "130"], xAxisLabels: ["8/14", "9/14", "10/14", "11/14"], header: CardHeader(color: .green, icon: .dollars, text: "Dining Dollars"), headerText: "Your balance over the semester.", color: .green)
                            .padding()
                    }
                    .padding()
                }
                
                CardView {
                    FrequentLocationsView()
                        .padding()
                }
                .padding()
                
                CardView {
                    VStack(alignment: .leading) {
                        // Top labels
                        Group {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                Text("Dining Dollars")
                            }
                            .font(Font.body.weight(.medium))
                            .foregroundColor(.green)
                            
                            Text("Over the last 7 days, you spent an average of 7.49 dining dollars per day.")
                                .fontWeight(.medium)
                        }
                        // Graph view
                        Spacer()
                        ZStack {
                            HStack(alignment: .bottom) {
                                ZStack(alignment: .leading) {
                                    Spacer()
                                        .frame(width: 120.0, height: 110.0)
                                    VStack(alignment: .leading) {
                                        Text(self.selectedData == nil ? "Average" : self.dayValue + " 12/14") .font(Font.caption.weight(.bold)).foregroundColor(self.selectedData == nil ? .gray : .yellow)
                                            .offset(x: 0, y: self.axisOffset - 10)
                                        
                                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                                            Text("$\(14.47 * (self.selectedData == nil ? self.averageDollar : (self.dollarData[self.selectedData!])), specifier: "%.2f")")
                                                .font(Font.system(.title, design: .rounded).bold())
                                                .offset(x: 0, y: self.axisOffset - 10)
                                            Text("\(self.selectedData == nil ? "/ day" : "")").font(Font.caption.weight(.bold)).foregroundColor(.gray)
                                                .offset(x: 0, y: self.axisOffset - 10)
                                            
                                        }
                                        .padding(.top, 8)
                                    }
                                    .frame(height: 110)
                                    
                                }
                                // Graph pillars and caption
                                HStack(alignment: .bottom, spacing: self.spacingForDollarData) {
                                    ForEach(self.dollarData.indices, id: \.self) { i in
                                        VStack {
                                            Spacer()
                                            RoundedRectangle(cornerRadius: 4).frame(height: 110.0 * self.dollarData[i])
                                                .foregroundColor(
                                                    self.selectedData == i ? Color.yellow : Color.gray.opacity(0.3))
                                                .onTapGesture {
                                                    if self.selectedData == i {
                                                        self.selectedData = nil
                                                    } else {
                                                        self.selectedData = i
                                                    }
                                                    withAnimation {
                                                        self.axisOffset = (self.selectedData == nil ? ((0.5 - self.averageDollar) * 110) : ((0.5 - self.dollarData[self.selectedData!]) * 110))
                                                    }
                                            }
                                            Text(self.dayOfWeek[i])
                                                .font(.caption)
                                                .opacity(0.5)
                                        }
                                    }
                                }
                                .animation(.default)
                            }
                            GraphPath(data: [0.5, 0.5, 0.5]).stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .foregroundColor(self.selectedData == nil ? .green : Color.gray.opacity(0.5))
                                .animation(.default)
                                .offset(x: 0, y: self.axisOffset - 2)
                                .animation(.default)
                        }
                        
                        // Footer
                        Picker("Pick a time frame", selection: self.$timeFrame) {
                            ForEach(self.timeFrames, id: \.self) { time in
                                Text(time)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onReceive([self.timeFrame].publisher.first()) { (output) in
                            withAnimation {
                                self.axisOffset = (self.selectedData == nil ? ((0.5 - self.averageDollar) * 110) : ((0.5 - self.dollarData[self.selectedData!]) * 110))
                            }
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                }
                .frame(height: 296)
                .padding()
                
                CardView {
                    DiningRecommendations()
                        .padding()
                }
                .padding()
                
                //                CardView {
                //                    VStack {
                //                        HStack {
                //                            Text(self.selectedData == nil ? "Swipe burn rate 2" : self.dayValue)
                //                                .font(.subheadline)
                //                                .opacity(0.5)
                //                            .animation(nil)
                //                            Spacer()
                //                            Text(self.selectedData == nil ? "$5.74" : "$\(self.data[self.selectedData!] * 11.39, specifier: "%.2f")")
                //                                .font(.subheadline)
                //                                .foregroundColor(self.selectedData == nil ? .primary : .green)
                //                            .animation(nil)
                //                        }
                //                        Spacer()
                //                        ZStack(alignment: .bottom) {
                //                            VStack {
                //                                GraphPath(data: self.lineData).trim(from: 0, to: self.trimEnd).stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [6]))
                //                                    .padding(.bottom)
                //                                    .foregroundColor(self.toggleOn ? .blue : Color.black.opacity(0.2))
                //
                //                                    .animation(.easeInOut)
                //
                //
                //
                //                                HStack() {
                //                                    ForEach(0..<self.lineData.count) { num in
                //                                        if num != 0 { Spacer() }
                //                                        Text("W\(num)")
                //                                        .font(.subheadline)
                //                                        .opacity(0.5)
                //                                    }
                //                                }
                //                            }
                //                        }.animation(.default)
                //                    }
                //                    .padding()
                //                    .animation(.default)
                //                }
                //                .frame(height: 220)
                //                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}

struct DiningVisualizations_Previews: PreviewProvider {
    static var previews: some View {
        DiningVisualizations()
    }
}
