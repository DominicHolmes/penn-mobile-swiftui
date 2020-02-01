//
//  VariableStepLineGraphView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/19/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct YXDataPoint {
    var y: CGFloat // Bound between 0 and 1
    var x: CGFloat // Bound between 0 and 1
}

struct VariableStepGraphPath: Shape, Animatable {
    @State var data: [YXDataPoint]
    
    var animatableData: [YXDataPoint] {
        get { return data }
        set { data = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard data.count > 2 else { return path }
        
        func point(at n: Int) -> CGPoint {
            return CGPoint(x: data[n].x * (rect.maxX / CGFloat(data.count - 1)),
                           y: rect.maxY - (rect.maxY * data[n].y))
        }
        
        path.move(to: point(at: 0))
        
        for i in 1 ..< data.count {
            path.addLine(to: point(at: i))
        }
        
        return path
    }
}

struct VariableStepLineGraphView: View {
    /*@State var data: [YXDataPoint]
    let yAxisLabels: [String]
    let xAxisLabels: [String]
    let header: CardHeader
    let headerText: String
    let color: Color
    @State private var trimEnd: CGFloat = 0.0
    
    private let graphHeight: CGFloat = 160.0*/
    
    func getSmoothedData() -> [YXDataPoint] {
        let trans = DiningTransaction.sampleData
        let sos = Date().addingTimeInterval(86400 * -4)
        let eos = Date().addingTimeInterval(86400 * 90)
        
        let totalLength = eos.distance(to: sos)
        let maxValue = trans.max(by: { $0.balance < $1.balance })?.balance ?? 1.0
        print(maxValue)
        let yxPoints: [YXDataPoint] = trans.map { (t) -> YXDataPoint in
            let xPoint = t.date.distance(to: sos) / totalLength
            return YXDataPoint(y: CGFloat(t.balance / maxValue), x: CGFloat(xPoint))
        }
        return yxPoints
    }
    
    var body: some View {
        dump(self.getSmoothedData())
        return Text("Hello World")
        /*VStack(alignment: .leading) {
            // Header
            Group {
                header
                Text(headerText)
                    .fontWeight(.medium)
            }
            
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
        }*/
        
    }
}

struct VariableStepLineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        return VariableStepLineGraphView()
    }
}
