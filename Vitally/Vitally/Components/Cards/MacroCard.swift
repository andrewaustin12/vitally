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
    let color: Color
    let icon: String
    let dailyRecommended: Double
    let percentage: Double
    
    init(title: String, value: Double, color: Color, icon: String, dailyRecommended: Double) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.dailyRecommended = dailyRecommended
        self.percentage = min((value / dailyRecommended) * 100, 100)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title == "Calories" || title == "Carbs" ? "\(Int(value))" : "\(Int(value))g")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(Int(percentage))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                    
                    Text("DV")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress bar
            Rectangle()
                .fill(color.opacity(0.2))
                .frame(height: 6)
                .overlay(
                    Rectangle()
                        .fill(color)
                        .frame(width: UIScreen.main.bounds.width * 0.35 * (percentage / 100), height: 6)
                        .animation(.easeInOut(duration: 0.8), value: percentage),
                    alignment: .leading
                )
                .cornerRadius(3)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(10)
    }
}

#Preview {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 12) {
        MacroCard(
            title: "Calories",
            value: 250,
            color: .orange,
            icon: "flame.fill",
            dailyRecommended: 2000
        )
        
        MacroCard(
            title: "Protein",
            value: 25,
            color: .blue,
            icon: "dumbbell.fill",
            dailyRecommended: 50
        )
        
        MacroCard(
            title: "Carbs",
            value: 45,
            color: .green,
            icon: "leaf.fill",
            dailyRecommended: 130
        )
        
        MacroCard(
            title: "Fat",
            value: 15,
            color: .red,
            icon: "drop.fill",
            dailyRecommended: 65
        )
    }
    .padding()
}
