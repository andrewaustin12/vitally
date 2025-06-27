//
//  IngredientChip.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct IngredientChip: View {
    let ingredient: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "circle.fill")
                .font(.caption2)
                .foregroundColor(.blue)
            
            Text(ingredient)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    IngredientChip(ingredient: "Apple")
}
