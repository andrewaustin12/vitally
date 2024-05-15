//
//  NutrientView.swift
//  Vitally
//
//  Created by andrew austin on 5/15/24.
//
import SwiftUI

struct NutrientView: View {
    let name: String
    let value: String
    let dailyValue: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.medium)
                Text("\(dailyValue) of daily value")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(value)
                .font(.body)
        }
        .padding(.vertical, 8)
    }
}
