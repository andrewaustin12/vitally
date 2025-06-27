//
//  NegativeNutrientCard.swift
//  Vitally
//
//  Created by andrew austin on 6/27/25.
//

import SwiftUI

struct NegativeNutrientCard: View {
    let name: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: iconForNutrient(name))
                    .font(.title2)
                    .foregroundColor(.red)
                Spacer()
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Text(prettyNutrientName(name))
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress bar for negative nutrients
            if let progressValue = getProgressValue(for: name, value: value) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Daily Limit")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(progressValue * 100))%")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(progressValue > 0.8 ? .red : .orange)
                    }
                    
                    ProgressView(value: min(progressValue, 1.0))
                        .progressViewStyle(LinearProgressViewStyle(tint: progressValue > 0.8 ? .red : .orange))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
            }
        }
        .padding(12)
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func iconForNutrient(_ nutrient: String) -> String {
        let nutrientIcons: [String: String] = [
            "sugars": "cube.fill",
            "salt": "drop.fill",
            "saturated fat": "drop.triangle.fill",
            "trans fat": "exclamationmark.triangle.fill",
            "artificial": "xmark.circle.fill",
            "preservative": "exclamationmark.octagon.fill",
            "coloring": "paintbrush.fill",
            "energy": "flame.fill"
        ]
        return nutrientIcons[nutrient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)] ?? "x.circle.fill"
    }
    
    private func getProgressValue(for nutrient: String, value: String) -> Double? {
        guard let numericValue = extractNumericValue(from: value) else { return nil }
        
        let dailyLimits: [String: Double] = [
            "sugars": 50.0,        // 50g daily limit for added sugars
            "salt": 6.0,           // 6g daily limit for salt
            "saturated fat": 20.0, // 20g daily limit for saturated fat
            "saturatedfat": 20.0,  // Alternative key for saturated fat
            "trans fat": 2.0,      // 2g daily limit for trans fat
            "energy": 2000.0,      // 2000 kcal daily limit
            "sodium": 2.4          // 2.4g daily limit for sodium
        ]
        
        guard let dailyLimit = dailyLimits[nutrient.lowercased()] else { return nil }
        return numericValue / dailyLimit
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
    NegativeNutrientCard(name: "sugars", value: "100")
}
