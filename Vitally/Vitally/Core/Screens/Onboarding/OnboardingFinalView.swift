//
//  OnboardingFinalView.swift
//  Vitally
//
//  Created by andrew austin on 5/16/24.
//

import SwiftUI

struct OnboardingFinalView: View {
    let systemImageName: String
    let title: String
    let description: String
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.teal)
                .padding(.bottom)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            
            Button {
                hasCompletedOnboarding = true
            } label: {
                HStack {
                    Text("Continue")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemTeal))
            
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top, 44)
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    OnboardingFinalView(
        systemImageName: "heart.text.square.fill",
        title: "Track Your Food Health Score",
        description: "Vitally can tell you your weekly food health score based on what you consume weekly!"
    )
}
