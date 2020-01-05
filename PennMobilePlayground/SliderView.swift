//
//  SliderView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/4/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI


struct SliderView: View {
    @State var percentage: Float = 0.0 // or some value binded

    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
            }
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    // TODO: - maybe use other logic here
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                }))
        }
        .frame(width: 200, height: 25, alignment: .center)
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}
