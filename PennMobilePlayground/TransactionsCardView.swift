//
//  TransactionsCardView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/17/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct DiningTransaction: Hashable {
    enum DiningDollarLocation: String {
        case houston, prett, mbaCafe, starbucks, deposit
        
        var fullName: String {
            switch self {
            case .deposit: return "Dining Plan"
            case .houston: return "Houston Hall"
            case .prett: return "Prett a Manger"
            case .mbaCafe: return "MBA Cafe"
            case .starbucks: return "1920 Starbucks"
            }
        }
    }
    
    let location: DiningDollarLocation
    let amount: Double
    let balance: Double
    let date: String
    let color: Color
    
    var formattedAmount: String {
        let amountString = String(amount)
        return (self.amount > 0 ? "+" : "") + amountString
    }
}

struct TransactionsCardView: View {
    
    private let data: [DiningTransaction] = [
        .init(location: .deposit, amount: 2400.00, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .starbucks, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .mbaCafe, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .prett, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .starbucks, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .starbucks, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .mbaCafe, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .prett, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue),
        .init(location: .houston, amount: -14.55, balance: 422.34, date: "Aug 31, 2:02 PM", color: .blue)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Group {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("Transaction History")
                }
                .font(Font.body.weight(.medium))
                .foregroundColor(.green)
                
                Text("Your recent dining dollar transactions.")
                .fontWeight(.medium)
                .lineLimit(nil)
                .frame(height: 44)
            }
            
            Divider()
                .padding([.top, .bottom])
            
            List(self.data, id: \.self) { trans in
                HStack {
                    Image(systemName: "circle.fill")
                    VStack(alignment: .leading) {
                        Text(trans.location.fullName)
                        Text(trans.date)
                            .font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(trans.formattedAmount)
                        Text(String(trans.balance))
                    }
                }
            }
            
        }
    }
}

struct TransactionsCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsCardView()
    }
}
