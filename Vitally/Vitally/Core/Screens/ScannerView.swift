//
//  ScannerView.swift
//  Vitally
//
//  Created by andrew austin on 5/13/24.
//

import SwiftUI

struct ScannerView: View {
    @State private var isFlashlightOn = false // State to track flashlight status
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder for the scanner area
            Rectangle()
                .fill(Color.gray.opacity(0.1)) // This simulates the scanner area
                .edgesIgnoringSafeArea(.all)
            
            // Flashlight icon with dynamic background in a circle
            Image(systemName: isFlashlightOn ? "flashlight.on.fill" : "flashlight.off.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .padding(10) // Padding to ensure background extends beyond the image
                .background(isFlashlightOn ? Color.white : Color.black.opacity(0.1))
                .clipShape(Circle()) // Clip the background to a circle
                .onTapGesture {
                    isFlashlightOn.toggle() // Toggle flashlight state on tap
                }
                .padding()
        }
    }
}

#Preview {
    ScannerView()
        .environmentObject(AuthViewModel())
}
