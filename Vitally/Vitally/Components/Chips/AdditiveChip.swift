//
//  AdditiveChip.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct AdditiveChip: View {
    let additive: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundColor(.orange)
            
            Text(additive)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.orange)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    AdditiveChip(additive: "Sodium Benzoate")
}
