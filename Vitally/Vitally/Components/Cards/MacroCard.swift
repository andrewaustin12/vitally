//
//  MacroCard.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct MacroCard: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text("\(Int(value))\(unit)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(color.opacity(0.08))
        .cornerRadius(10)
    }
}

#Preview {
    MacroCard(
        title: "Protein",
        value: 25,
        unit: "g",
        color: .blue,
        icon: "dumbbell.fill"
    )
}
