//
//  TransactionCardRowView.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 2/2/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct TransactionCardRowView: View {
    
    var transaction: DiningTransaction
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundColor(transaction.color)
            VStack(alignment: .leading) {
                Text(transaction.location.fullName)
                Text(transaction.formattedDate)
                    .font(.caption).foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(transaction.formattedAmount)
                    .fontWeight(.medium)
                    .foregroundColor(transaction.amount > 0 ? .green : .red)
                Text(String(transaction.balance))
                    .font(.caption).foregroundColor(.gray)
            }
        }
    }
}

struct TransactionCardRowView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCardRowView(transaction: DiningTransaction.sampleData.first!)
    }
}
