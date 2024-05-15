//
//  NovaBadgeView.swift
//  Vitally
//
//  Created by andrew austin on 5/15/24.
//

import SwiftUI

struct NovaBadgeView: View {
    let rating: Int = 3
    
    var body: some View {
        VStack(spacing: 0) {
            Text("NOVA")
                .font(.system(size: 24))
                .foregroundColor(.gray)
                .bold()
            
            ZStack {
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 100, height: 150)
                    
                
                Text("3")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            .border(Color.white, width: 10)
            
        }
        .frame(width: 55, height: 55)
    }
}



#Preview {
    NovaBadgeView()
}
