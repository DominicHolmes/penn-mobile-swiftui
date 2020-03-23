//
//  TextPredictionsView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 2/7/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct PredictionsGraphView: View {
    
    var data: [CGFloat]
    let xAxisLabels = ["1","2","3","4"]
    let yAxisLabels = ["1","2","3","4"]
    
    var body: some View {
        VStack(alignment: .leading) {
            CardHeaderView(color: .purple, icon: .predictions, title: "Swipe Predictions", subtitle: "Log into Penn Mobile often to get more accurate predictions.")
            
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
}

struct PredictionsGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionsGraphView(data: [0.0, 0.0, 1.0, 0.5])
    }
}
