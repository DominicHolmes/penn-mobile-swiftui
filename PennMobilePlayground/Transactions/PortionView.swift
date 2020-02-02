//
//  PortionView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/5/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct PortionView: View {
    @Binding var portions: [Double]
    @Binding var colors: [Color]
    
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
