//
//  Onboarding1View.swift
//  Vitally
//
//  Created by andrew austin on 5/16/24.
//

import SwiftUI

struct Onboarding1View: View {
    let systemImageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.teal)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    Onboarding1View(
        systemImageName: "leaf",
        title: "Welcome!",
        description: "Vitally is an app that helps you see behind what products you are choosing"
    )
}
