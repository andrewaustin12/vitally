//
//  TestView.swift
//  Vitally
//
//  Created by andrew austin on 5/13/24.
//

import SwiftUI


struct TestView: View {
    @StateObject var viewModel = FoodProductViewModel()
    @State private var showDetailsSheet = false  // State to control sheet presentation
    
    let fruitBars: String = "3256228097361"
    let cookies: String  = "3017760654098"
    let nutella: String =  "3017624010701"
    let Coke: String = "5449000000439"

    var body: some View {
        VStack {
            Button("Fetch Food Product") {
                Task {
                    let barcode = fruitBars // Replace this with the scanned barcode
                    await viewModel.fetchFoodProduct(barcode: barcode)
                    if viewModel.product != nil {
                        DispatchQueue.main.async {
                            showDetailsSheet = true  // Show the sheet when product data is fetched
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDetailsSheet) {
            if let product = viewModel.product {
                ProductDetailsView(product: product)
                    .presentationDetents([.fraction(0.25), .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
            } else {
                Text("No product details available")
            }
        }
    }
}

#Preview {
    TestView()
}



enum ProductApiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
