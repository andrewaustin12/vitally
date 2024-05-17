//
//  OnboardingTabView.swift
//  Vitally
//
//  Created by andrew austin on 5/16/24.
//

import SwiftUI

struct OnboardingTabView: View {
    var body: some View {
        TabView {
            Onboarding1View(
                systemImageName: "leaf",
                title: "Welcome!",
                description: "Vitally is an app that helps you see behind what products you are choosing"
            )
            Onboarding1View(
                systemImageName: "barcode.viewfinder",
                title: "Product Analysis",
                description: "Vitally scans products and tells your whats in them so you can decide what best for you!"
            )
            OnboardingFinalView(
                systemImageName: "heart.text.square.fill",
                title: "Track Your Food Health Score",
                description: "Vitally can tell you your weekly food health score based on what you consume weekly!"
            )
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingTabView()
}
