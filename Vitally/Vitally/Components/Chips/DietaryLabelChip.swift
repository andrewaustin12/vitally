//
//  DietaryLabelChip.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct DietaryLabelChip: View {
    let label: String
    
    private var labelColor: Color {
        let healthyLabels = ["organic", "natural", "vegan", "vegetarian", "gluten free", "non gmo"]
        let moderateLabels = ["fair trade", "sustainable", "local"]
        
        let lowercased = label.lowercased()
        
        if healthyLabels.contains(where: { lowercased.contains($0) }) {
            return .green
        } else if moderateLabels.contains(where: { lowercased.contains($0) }) {
            return .blue
        } else {
            return .purple
        }
    }
    
    private var labelIcon: String {
        let lowercased = label.lowercased()
        
        if lowercased.contains("organic") {
            return "leaf.fill"
        } else if lowercased.contains("vegan") {
            return "leaf.circle.fill"
        } else if lowercased.contains("gluten") {
            return "wheat"
        } else if lowercased.contains("fair trade") {
            return "hand.raised.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: labelIcon)
                .font(.caption)
                .foregroundColor(labelColor)
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(labelColor)
                .lineLimit(2)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(labelColor.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(labelColor.opacity(0.3), lineWidth: 1)
        )
    }
}
#Preview {
    DietaryLabelChip(label: "Organic")
}
