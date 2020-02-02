//
//  LineGraphView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/5/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct LineGraphView: View {
    
    @State var data: [CGFloat]
    let yAxisLabels: [String]
    let xAxisLabels: [String]
    let header: CardHeaderView
    let color: Color
    @State private var trimEnd: CGFloat = 0.0
    
    private let graphHeight: CGFloat = 160.0
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            
            // Divider
            Divider()
                .padding([.top, .bottom])
            
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
                .frame(height: self.graphHeight)
                
                // Graph
                VStack {
                    GraphPath(data: self.data).trim(from: 0, to: self.trimEnd).stroke(
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                        .foregroundColor(color)
                        .frame(height: self.graphHeight)
                        .animation(.default)
                        .onAppear {
                            self.trimEnd = 1.0
                    }
                    
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
            .frame(height: self.graphHeight)
            .padding([.top, .bottom])
        }
        
    }
}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        LineGraphView(data: [1.0, 0.86, 0.85, 0.7, 0.67, 0.5, 0.45, 0.4, 0.3, 0.0], yAxisLabels: ["240", "180", "120", "60"], xAxisLabels: ["8/14", "9/14", "10/14", "11/14"], header: CardHeaderView(color: .blue, icon: .swipes, title: "Swipes", subtitle: "Your swipes balance over the semester."), color: .green)
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
