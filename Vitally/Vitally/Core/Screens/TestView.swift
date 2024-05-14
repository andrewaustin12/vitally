//
//  TestView.swift
//  Vitally
//
//  Created by andrew austin on 5/13/24.
//

import SwiftUI


struct TestView: View {
    @StateObject var viewModel = FoodProductViewModel()
    @EnvironmentObject var historyViewModel: HistoryViewModel  // EnvironmentObject to access history
    @State private var showDetailsSheet = false  // State to control sheet presentation
    
    let nutella: String = ""
    let kitkat: String = "034000176120"

    var body: some View {
        VStack {
            Button("Fetch Food Product") {
                Task {
                    let barcode = "5449000000439" // Replace this with the scanned barcode
                    await viewModel.fetchFoodProduct(barcode: barcode)
                    if let product = viewModel.product {
                        DispatchQueue.main.async {
                            showDetailsSheet = true  // Show the sheet when product data is fetched
                            historyViewModel.addProduct(product)  // Add product to history
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDetailsSheet) {
            if let product = viewModel.product {
                ProductDetailsView(product: product)
            } else {
                Text("No product details available")
            }
        }
    }
}

#Preview {
    TestView()
        .environmentObject(HistoryViewModel())
}



enum ProductApiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
