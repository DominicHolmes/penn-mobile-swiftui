//
//  CardHeaderView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 2/2/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct CardHeaderView: View {
    
    let color: Color
    let icon: CardHeaderTitleView.IconType
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            CardHeaderTitleView(color: color, icon: icon, title: title)
            Text(subtitle)
                .fontWeight(.medium)
        }
    }
}

struct CardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CardHeaderView(color: .blue, icon: .predictions, title: "Predictions", subtitle: "These are your predictions! Pretty cool that they even wrap onto new lines.")
    }
}
