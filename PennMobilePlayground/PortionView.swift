//
//  PortionView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/5/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct VerticalPortionView: View {
    @Binding var portions: [Double]
    @Binding var colors: [Color]
    let isVertical: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(self.portions.indices, id: \.self) {
                    Rectangle()
                        .frame(width: 20, height: geometry.size.height * CGFloat(self.portions[$0]))
                    .foregroundColor(self.colors[$0])
                }
            }
        }
    }
}

struct PortionView: View {
    @Binding var portions: [Double]
    @Binding var colors: [Color]
    let isVertical: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(self.portions.indices, id: \.self) {
                    Rectangle()
                    .frame(width: geometry.size.width * CGFloat(self.portions[$0]))
                    .foregroundColor(self.colors[$0])
                }
            }
        }
    }
}
//
//struct PortionView_Previews: PreviewProvider {
//    var portions = [0.25, 0.4, 0.125, 0.125, 0.1]
//    var colors: [Color] = [.orange, .yellow, .green, .blue, .purple]
//
//    static var previews: some View {
//        return PortionView(portions: self.$portions, colors: $colors)
//    }
//}
