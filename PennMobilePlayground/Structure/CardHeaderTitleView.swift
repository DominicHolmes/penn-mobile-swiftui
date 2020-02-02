//
//  CardHeaderView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 2/2/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct CardHeaderTitleView: View {
    
    enum IconType {
        case dollars, swipes, predictions
    }
    
    let color: Color
    let icon: IconType
    let title: String
    
    private func imageName(for icon: IconType) -> String {
        switch icon {
        case .dollars: return "dollarsign.circle.fill"
        case .swipes: return "creditcard.fill"
        case .predictions: return "wand.and.rays"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: imageName(for: icon))
            Text(title)
        }
        .font(Font.body.weight(.medium))
        .foregroundColor(color)
    }
}

struct CardHeaderTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CardHeaderTitleView(color: .blue, icon: .dollars, title: "Swipes")
    }
}
