//
//  VariableStepLineGraphView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/19/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

//MARK: - DONE
struct YXDataPoint {
    var y: CGFloat // Bound between 0 and 1
    var x: CGFloat // Bound between 0 and 1
}

//MARK: - DONE
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
            return CGPoint(
                x: data[n].x * rect.maxX,
                y: rect.maxY - (rect.maxY * data[n].y))
        }
        
        path.move(to: point(at: 0))
        
        for i in 1 ..< data.count {
            path.addLine(to: point(at: i))
        }
        
        return path
    }
}

//MARK: - DONE
struct PredictionSlopePath: Shape, Animatable {
    // This should be the last data point before prediction line begins
    @State var data: YXDataPoint
    
    // Calculated on a "per-day" basis. Should only take negative transactions into account.
    // Slope is defined in terms of the max dollar change (full balance to 0) over the max time frame
    @State var predictionSlope: CGFloat
    
    var animatableData: YXDataPoint {
        get { return data }
        set { data = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(
            x: data.x * rect.maxX,
            y: rect.maxY - (rect.maxY * data.y)
        ))
        
        path.addLine(to: CGPoint(
            x: rect.maxX,
            y: rect.maxY - (rect.maxY * predictionSlope)
        ))
        
        return path
    }
}

//MARK: - DONE
struct GraphEndpointPath: Shape {
    // The x value of the path (between 0 and 1)
    @State var x: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(
            x: x * rect.maxX,
            y: rect.maxY
        ))
        
        path.addLine(to: CGPoint(
            x: x * rect.maxX,
            y: rect.minY
        ))
        
        return path
    }
}

//MARK: - DONE
struct VariableStepLineGraphView: View {
    /*@State var data: [YXDataPoint]
    let yAxisLabels: [String]
    let xAxisLabels: [String]
    let header: CardHeader
    let headerText: String
    let color: Color
    @State private var trimEnd: CGFloat = 0.0
    
    private let graphHeight: CGFloat = 160.0*/
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var trimEnd: CGFloat = 0.0
    private let graphHeight: CGFloat = 160.0
    
    
    @GestureState private var dragActive = false
    
    @State var data: [YXDataPoint]
    @State var lastPointPosition: CGFloat = 0.0
    
    static func getSmoothedData(from: [DiningTransaction]) -> [YXDataPoint] {
        let trans = from
        let sos = Date().addingTimeInterval(86400 * -4)
        let eos = Date().addingTimeInterval(86400 * 120)
        
        let totalLength = eos.distance(to: sos)
        let maxDollarValue = trans.max(by: { $0.balance < $1.balance })?.balance ?? 1.0
        print(maxDollarValue)
        let yxPoints: [YXDataPoint] = trans.map { (t) -> YXDataPoint in
            let xPoint = t.date.distance(to: sos) / totalLength
            return YXDataPoint(y: CGFloat(t.balance / maxDollarValue), x: CGFloat(xPoint))
        }
        return yxPoints
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 20)
            HStack {
                // Y-Axis labels
                VStack(alignment: .leading) {
                    ForEach(0 ..< 5) { num in
                        if num != 0 { Spacer() }
                        Text(String(2200 - (440 * num)))
                            .font(.subheadline)
                            .opacity(0.5)
                    }
                }
                .frame(width: 40, height: self.graphHeight)
                
                GeometryReader { geometry in
                    
                    ZStack {
                        
                        VariableStepGraphPath(data: self.data).trim(from: 0, to: self.trimEnd).stroke(
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                        )
                            .foregroundColor(.blue)
                            .frame(height: self.graphHeight)
                            .animation(.default)
                            .onAppear {
                                self.trimEnd = 1.0
                        }
                        
                        
                        PredictionSlopePath(data: self.data.last!, predictionSlope: -0.2).stroke(
                            style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round, dash: [5], dashPhase: 5)
                        )
                            .foregroundColor(.gray)
                            .frame(height: self.graphHeight)
                            .animation(.default)
                            .onAppear {
                                self.trimEnd = 1.0
                        }
                        .clipped()
                        
                        Group {
                            Group {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("Today")
                                    Image(systemName: "circle.fill")
                                }
                                .foregroundColor(.white)
                                .font(.caption)
                            }
                            .frame(width: 140)
                            .offset(x: -70 + 5.5 + ((self.lastPointPosition - 0.5) * geometry.size.width), y: -6 - geometry.size.height/2)
                            
                            GraphEndpointPath(x: self.lastPointPosition).stroke(
                                style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round)
                            )
                                .foregroundColor(.white)
                                .frame(height: self.graphHeight)
                        }
                        
                        Group {
                            Group {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("End of Term")
                                    Image(systemName: "circle.fill")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            }
                            .frame(width: 140)
                            .offset(x: -70 + 5.5 + ((1.0 - 0.5) * geometry.size.width), y: -6 - geometry.size.height/2)
                            
                            GraphEndpointPath(x: 1.0).stroke(
                                style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round)
                            )
                                .foregroundColor(.red)
                                .frame(height: self.graphHeight)
                        }
                    }
                }
                .frame(height: graphHeight)
            }
            // X-Axis labels
            HStack {
                Spacer()
                    .frame(width: 40)
                ForEach(0 ..< 4) { num in
                    if num != 0 { Spacer() }
                    Text("x1")
                        .font(.subheadline)
                        .opacity(0.5)
                }
            }
            .frame(height: 20)
        }
    }
}

struct VariableStepLineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let data = VariableStepLineGraphView.getSmoothedData(from: DiningTransaction.sampleData)
        return VariableStepLineGraphView(data: data, lastPointPosition: data.last?.x ?? 0)
    }
}
