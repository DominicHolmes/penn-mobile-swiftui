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
                .fill(self.colorScheme == ColorScheme.light ? Color.white : Color.gray)
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
    
    var dayOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    
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
                    Text("Hello World")
                    .padding()
                }
                .padding()
                
                HStack {
                    DiningBalanceView(description: "Swipes", image: Image(systemName: "creditcard.fill"), balance: 58.00, specifier: "%.f", color: .green)
                    .padding(.leading)
                    .padding(.trailing, 5)
                    
                    DiningBalanceView(description: "Dining Dollars", image: Image(systemName: "dollarsign.circle.fill"), balance: 427.84, specifier: "%.2f")
                    .padding(.leading, 5)
                    .padding(.trailing)
                }
                
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
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(self.colorScheme == ColorScheme.light ? Color.white : Color.black)
                        .shadow(radius: 5)
                    VStack {
                        HStack {
                            Text(selectedData == nil ? "Dining dollars / day" : dayValue)
                                .font(.subheadline)
                                .opacity(0.5)
                            .animation(nil)
                            Spacer()
                            Text(selectedData == nil ? "$5.74" : "$\(data[selectedData!] * 11.39, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(selectedData == nil ? .primary : .green)
                            .animation(nil)
                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            ForEach(0..<data.count) { num in
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
