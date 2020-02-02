//
//  CardView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 2/2/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct CardView<Content> : View where Content : View {
    let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(self.colorScheme == ColorScheme.light ? Color.white : Color.gray.opacity(0.2))
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
            self.content()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("Hello World")
        }
    }
}
