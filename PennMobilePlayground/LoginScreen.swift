//
//  LoginScreen.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/26/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct LoginScreen: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 17) {
            
            Spacer()
            
            Image("pennmobile")
                .resizable()
                .frame(minWidth: 45, maxWidth: 140, minHeight: 45, maxHeight: 140)
                .scaledToFit()
            
            Text("Penn Mobile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            Spacer()

            FullButton(action: loginWithPennKey, content: Text("Login with PennKey"), foreground: .clear, background: .white)
            
//            Text("Login with PennKey")
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .padding(.vertical, 20)
//                .foregroundColor(.white)
//                .background(.white)
//            .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
//            .padding(.horizontal)
            
            
            FullButton(action: continueAsGuest, content: Text("Continue as Guest"), foreground: .white, background: .clear)
                .padding(.bottom)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .bottomLeading, endPoint: .topTrailing))
        .edgesIgnoringSafeArea(.top)
    }
    
    func loginWithPennKey() {
        
    }
    
    func continueAsGuest() {
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
