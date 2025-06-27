//
//  PositiveNutrientCard.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct PositiveNutrientCard: View {
    let name: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: iconForNutrient(name))
                    .font(.title2)
                    .foregroundColor(.green)
                Spacer()
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Text(prettyNutrientName(name))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress bar for positive nutrients
            if let progressValue = getProgressValue(for: name, value: value) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Daily Value")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(progressValue * 100))%")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    ProgressView(value: min(progressValue, 1.0))
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func iconForNutrient(_ nutrient: String) -> String {
        let nutrientIcons: [String: String] = [
            "fiber": "leaf.fill",
            "proteins": "fish.fill",
            "vitamins": "pills.fill",
            "mineral": "diamond.fill",
            "omega-3": "fish",
            "antioxidant": "sparkles"
        ]
        return nutrientIcons[nutrient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)] ?? "checkmark.circle.fill"
    }
    
    private func getProgressValue(for nutrient: String, value: String) -> Double? {
        guard let numericValue = extractNumericValue(from: value) else { return nil }
        
        let dailyValues: [String: Double] = [
            "fiber": 25.0,
            "proteins": 50.0,
            "vitamins": 100.0, // Generic vitamin daily value
            "mineral": 100.0,  // Generic mineral daily value
            "omega-3": 1.6,    // EPA + DHA daily value
            "antioxidant": 100.0, // Generic antioxidant daily value
            "fruits & vegetables": 400.0, // 400g daily recommendation
            "fruitsvegetables": 400.0 // Alternative key for fruits & vegetables
        ]
        
        guard let dailyValue = dailyValues[nutrient.lowercased()] else { return nil }
        return numericValue / dailyValue
    }
    
    private func extractNumericValue(from value: String) -> Double? {
        let cleaned = value.replacingOccurrences(of: "g", with: "")
            .replacingOccurrences(of: "mg", with: "")
            .replacingOccurrences(of: "kcal", with: "")
            .trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }
}

#Preview {
    PositiveNutrientCard(name: "fiber", value: "100")
}
