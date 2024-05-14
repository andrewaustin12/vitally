//
//  ProductDetailsView.swift
//  Vitally
//
//  Created by andrew austin on 5/14/24.
//

import SwiftUI

struct ProductDetailsView: View {
    var product: Product
    
    var imageSize: CGFloat = 45
    
    var body: some View {
        VStack {
            HStack {
                ImageLoaderView(urlString: product.imageURL)
                    .frame(width: imageSize, height: imageSize)
                Text("Product: \(product.productName)")
                    .font(.title)
                    .padding()
            }
            Text("Nutrition Grade: \(product.nutritionGrades.capitalized)")
                .font(.headline)
                .padding()
            Button("Dismiss") {
                // This would be the action to dismiss the sheet,
                // but since this is a static context, you would handle dismissal
                // through binding in real use.
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}


//#Preview {
//    ProductDetailsView(product: )
//        .environmentObject(AuthViewModel())
//        .environmentObject(HistoryViewModel())
//}
