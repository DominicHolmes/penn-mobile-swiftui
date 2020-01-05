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
    @State var toggleOn: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var data: [CGFloat] {
        return toggleOn ? [0.2, 0.5, 0.6, 0.2, 0.7, 0.0, 0.9] : [0, 0, 0, 0, 0, 0, 0]
    }
    
    var lineData: [CGFloat] {
        return [0.2, 0.5, 0.6, 0.2, 0.7, 0.0, 0.9]
    }
    
    var trimEnd: CGFloat {
        return toggleOn ? 1.0 : 0.0
    }
    
    let weekDollarData: [CGFloat] = [0.2, 1.0, 0.6, 0.001, 0.05, 0.15, 0.9]
    let lastWeekDollarData: [CGFloat] = (0..<7).map { _ in CGFloat.random(in: 0.0...1.0) }
    let monthDollarData: [CGFloat] = (0..<9).map { _ in CGFloat.random(in: 0.0...1.0) }
    let semesterDollarData: [CGFloat] = (0..<5).map { _ in CGFloat.random(in: 0.0...1.0) }
    let zeroDollarData: [CGFloat] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
    
    var body: some View {
        ScrollView {
            VStack {
                Toggle("Stats on: \(toggleOn ? "true" : "false")", isOn: $toggleOn)
                
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
                                                    self.selectedData == i ? Color.yellow : Color.gray.opacity(0.5))
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
                
                /*CardView {
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
                                    .animation(nil)
                                    VStack(alignment: .leading) {
                                        Text("Average")
                                            .font(Font.caption.weight(.bold)).foregroundColor(.gray)
                                        
                                        HStack(alignment: .firstTextBaseline) {
                                            Text("\(14.47 * self.averageDollar, specifier: "%.2f")")
                                            .font(Font.system(.title, design: .rounded).bold())
                                            Text("/ day").font(Font.caption.weight(.bold)).foregroundColor(.gray)
                                        }
                                        .padding(.top, 8)
                                    }
                                    .frame(height: 110)
                                    .animation(.default)
                                    .offset(x: 0, y: 6 + ((0.5 - self.averageDollar) * 110))
                                    
                                }
                                HStack(alignment: .bottom, spacing: self.spacingForDollarData) {
                                    ForEach(self.dollarData.indices, id: \.self) { i in
                                        VStack {
                                            RoundedRectangle(cornerRadius: 4).frame(height: 110.0 * self.dollarData[i])
                                                .foregroundColor(Color.gray.opacity(0.5))
                                                .onTapGesture {
                                                    /*if self.selectedData == num {
                                                        self.selectedData = nil
                                                    } else {
                                                        self.selectedData = num
                                                    }*/
                                                }
                                            
                                            
                                            
                                            if self.timeFrame == "Week" {
                                                Text(self.dayOfWeek[i])
                                                .font(.caption)
                                                .opacity(0.5)
                                                    
                                            }
                                        }
                                    }
                                }.animation(.default)
                            }
                            GraphPath(data: [0.5, 0.5, 0.5]).stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .foregroundColor(.green)
                            .offset(x: 0, y: (0.5 - self.averageDollar) * 110)
                            .animation(.default)
                        }
                        
                        // Footer
                        Picker("Pick a time frame", selection: self.$timeFrame) {
                            ForEach(self.timeFrames, id: \.self) { time in
                                Text(time)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                .padding()
                }
                .frame(height: 290)
                .padding()*/
                
                CardView {
                    DiningRecommendations()
                    .padding()
                }
                .padding()
                
                CardView {
                    Text("Hello World this is a Card.")
                    .padding()
                }
                .padding([.leading, .trailing, .bottom])
                
                // Balance row 1
                HStack {
                    DiningBalanceView(description: "Swipes", image: Image(systemName: "creditcard.fill"), balance: 58.00, specifier: "%.f", color: .green)
                    .padding(.leading)
                    .padding(.trailing, 5)
                    
                    DiningBalanceView(description: "Dining Dollars", image: Image(systemName: "dollarsign.circle.fill"), balance: 427.84, specifier: "%.2f")
                    .padding(.leading, 5)
                    .padding(.trailing)
                }
                
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
                
                
                CardView {
                    VStack {
                        HStack {
                            Text(self.selectedData == nil ? "Dining dollars / day" : self.dayValue)
                                .font(.subheadline)
                                .opacity(0.5)
                            .animation(nil)
                            Spacer()
                            Text(self.selectedData == nil ? "$5.74" : "$\(self.data[self.selectedData!] * 11.39, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(self.selectedData == nil ? .primary : .green)
                            .animation(nil)
                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            ForEach(0..<self.data.count) { num in
                                VStack {
                                    RoundedRectangle(cornerRadius: 10).frame(height: 20 + 100.0 * self.data[num])
                                        .foregroundColor(self.selectedData == num ? .green : .blue)
                                        .onTapGesture {
                                            if self.selectedData == num {
                                                self.selectedData = nil
                                            } else {
                                                self.selectedData = num
                                            }
                                        }
                                    Text(self.dayOfWeek[num])
                                        .font(.subheadline)
                                        .opacity(0.5)
                                }
                            }
                        }
                    }
                    .padding()
                    .animation(.default)
                }
                .frame(height: 220)
                .padding([.leading, .trailing, .bottom])
                
                CardView {
                    VStack {
                        HStack {
                            Text(self.selectedData == nil ? "Dining dollars / day" : self.dayValue)
                                .font(.subheadline)
                                .opacity(0.5)
                            .animation(nil)
                            Spacer()
                            Text(self.selectedData == nil ? "$5.74" : "$\(self.data[self.selectedData!] * 11.39, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(self.selectedData == nil ? .primary : .green)
                            .animation(nil)
                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            ForEach(0..<self.data.count) { num in
                                VStack {
                                    RoundedRectangle(cornerRadius: 10).frame(height: 20 + 100.0 * self.data[num])
                                        .foregroundColor(self.selectedData == num ? .green : .blue)
                                        .onTapGesture {
                                            if self.selectedData == num {
                                                self.selectedData = nil
                                            } else {
                                                self.selectedData = num
                                            }
                                        }
                                    Text(self.dayOfWeek[num])
                                        .font(.subheadline)
                                        .opacity(0.5)
                                }
                            }
                        }
                    }
                    .padding()
                    .animation(.default)
                }
                .frame(height: 220)
                .padding([.leading, .trailing, .bottom])
                
                CardView {
                    VStack {
                        HStack {
                            Text(self.selectedData == nil ? "Swipe burn rate 1" : self.dayValue)
                                .font(.subheadline)
                                .opacity(0.5)
                            .animation(nil)
                            Spacer()
                            Text(self.selectedData == nil ? "$5.74" : "$\(self.data[self.selectedData!] * 11.39, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(self.selectedData == nil ? .primary : .green)
                            .animation(nil)
                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            ForEach(0..<self.data.count) { num in
                                VStack {
                                    Circle().frame(height: 10)
                                        .offset(x: 0, y: -120 * self.data[num])
                                        .padding(.bottom)
                                        .foregroundColor(self.toggleOn ? .blue : Color.black.opacity(0.2))
                                    Text("W\(num)")
                                        .font(.subheadline)
                                        .opacity(0.5)
                                }
                            }
                        }
                    }
                    .padding()
                    .animation(.default)
                }
                .frame(height: 220)
                .padding()
                
                CardView {
                    VStack {
                        HStack {
                            Text(self.selectedData == nil ? "Swipe burn rate 2" : self.dayValue)
                                .font(.subheadline)
                                .opacity(0.5)
                            .animation(nil)
                            Spacer()
                            Text(self.selectedData == nil ? "$5.74" : "$\(self.data[self.selectedData!] * 11.39, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(self.selectedData == nil ? .primary : .green)
                            .animation(nil)
                        }
                        Spacer()
                        ZStack(alignment: .bottom) {
                            VStack {
                                GraphPath(data: self.lineData).trim(from: 0, to: self.trimEnd).stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [6]))
                                    .padding(.bottom)
                                    .foregroundColor(self.toggleOn ? .blue : Color.black.opacity(0.2))
                                
                                    .animation(.easeInOut)
                                
                                
                                
                                HStack() {
                                    ForEach(0..<self.lineData.count) { num in
                                        if num != 0 { Spacer() }
                                        Text("W\(num)")
                                        .font(.subheadline)
                                        .opacity(0.5)
                                    }
                                }
                            }
                        }.animation(.default)
                    }
                    .padding()
                    .animation(.default)
                }
                .frame(height: 220)
                .padding([.leading, .trailing, .bottom])
            }
        }
    }
}

struct GraphPath: Shape, Animatable {
    @State var data: [CGFloat]
    
    var animatableData: [CGFloat] {
        get { return data }
        set { data = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard data.count > 2 else { return path }
        
        func point(at n: Int) -> CGPoint {
            return CGPoint(x: CGFloat(n) * (rect.maxX / CGFloat(data.count - 1)), y: rect.maxY - (rect.maxY * data[n]))
        }
        
        path.move(to: point(at: 0))

        for i in 1 ..< data.count {
            path.addLine(to: point(at: i))
        }

        return path
    }
}

struct DiningVisualizations_Previews: PreviewProvider {
    static var previews: some View {
        DiningVisualizations()
    }
}
