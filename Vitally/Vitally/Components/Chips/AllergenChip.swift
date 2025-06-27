//
//  AllergenChip.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct AllergenChip: View {
    let allergen: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundColor(.red)
            
            Text(allergen)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.red)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.red.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    AllergenChip(allergen: "Milk")
}
