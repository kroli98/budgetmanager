//
//  CardView.swift
//  budgetmanager
//
//  Created by Kiss Roland on 2023. 04. 23..
//

import SwiftUI

struct CardView: View {
    let itemName: String
    let itemCategory: String
    let price: Double
    let quantity: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(itemName)
                .font(.headline)
                .fontWeight(.bold)

            Text(itemCategory)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text("Összeg: \(price, specifier: "%.0f") Ft")
                    .font(.caption)
                Spacer()
                Text("Darabszám: \(quantity)")
                    .font(.caption)
            }

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(itemName: "Sample Item", itemCategory: "Electronics", price: 199.99, quantity: 1)
    }
}


