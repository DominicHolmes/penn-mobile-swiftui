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
    let date: Date
    let color: Color
    
    var formattedAmount: String {
        let amountString = String(amount)
        return (self.amount > 0 ? "+" : "") + amountString
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a EEEE, MMM d"
        return formatter.string(from: self.date)
    }
    
    static let sampleData: [DiningTransaction] = [
        .init(location: .deposit, amount: 2400.00, balance: 422.34, date: Date().advanced(by: 86400), color: .green),
        .init(location: .starbucks, amount: -14.55, balance: 414.34, date: Date().advanced(by: 86400*2), color: .orange),
        .init(location: .mbaCafe, amount: -14.55, balance: 400.34, date: Date().advanced(by: 86400*5), color: .pink),
        .init(location: .prett, amount: -14.55, balance: 340.11, date: Date().advanced(by: 86400*12), color: .red),
        .init(location: .starbucks, amount: -14.55, balance: 332.98, date: Date().advanced(by: 86400*14), color: .orange),
        .init(location: .starbucks, amount: -14.55, balance: 308.00, date: Date().advanced(by: 86400*32), color: .orange),
        .init(location: .mbaCafe, amount: -14.55, balance: 302.00, date: Date().advanced(by: 86400*35), color: .pink),
        .init(location: .prett, amount: -14.55, balance: 270.14, date: Date().advanced(by: 86400*44), color: .red),
        .init(location: .houston, amount: -14.55, balance: 140.55, date: Date().advanced(by: 86400*70), color: .blue)
    ]
}

struct TransactionsCardView: View {
    
    private let data: [DiningTransaction] = DiningTransaction.sampleData
    
    var body: some View {
        VStack(alignment: .leading) {
            
            CardHeader(color: .green, icon: .dollars, text: "Transactions")
            
            Text("Your recent dining dollar transactions.")
            .fontWeight(.medium)
            
            Divider()
                .padding([.top, .bottom])
            
            VStack {
                ForEach(self.data, id: \.self) { trans in
                    VStack {
                        HStack {
                            Image(systemName: "circle.fill")
                            .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(trans.color)
                            VStack(alignment: .leading) {
                                Text(trans.location.fullName)
                                Text(trans.formattedDate)
                                    .font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(trans.formattedAmount)
                                    .fontWeight(.medium)
                                    .foregroundColor(trans.amount > 0 ? .green : .red)
                                Text(String(trans.balance))
                                    .font(.caption).foregroundColor(.gray)
                            }
                        }
                        Divider()
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
