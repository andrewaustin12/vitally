import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    var imageSize: CGFloat = 65

    var body: some View {
        NavigationStack {
            List {
                ForEach(uniqueProducts, id: \.code) { product in
                    NavigationLink(destination: ProductDetailsView(product: product)) {
                        HStack {
                            ImageLoaderView(urlString: product.imageURL)
                                .frame(width: imageSize, height: imageSize)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(product.productName)
                                    .font(.headline)
                                Text(product.brands)
                                    .font(.subheadline)
                                FoodScorePreviewView(percentage: calculateMatchScore(for: product), description: "Match with your food preferences")
//                                Text("Nutri-Score: \(product.nutritionGrades.capitalized)")
//                                    .font(.callout)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .listStyle(.plain)
            .navigationTitle("History")
            .onAppear {
                historyViewModel.fetchProducts()
            }
        }
    }

    private var uniqueProducts: [Product] {
        var seenCodes = Set<String>()
        var uniqueProducts = [Product]()
        
        for product in historyViewModel.products.sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() }) {
            if !seenCodes.contains(product.code) {
                seenCodes.insert(product.code)
                uniqueProducts.append(product)
            }
        }
        
        return uniqueProducts
    }

    private func deleteProduct(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = uniqueProducts[index]
            historyViewModel.deleteProduct(product)
        }
    }

    private func calculateMatchScore(for product: Product) -> Int {
        var totalScore = 0
        
        // Nutritional Quality - 60%
        if let nutriScore = product.nutriscoreData?.grade {
            totalScore += calculateNutriScoreGrade(nutriScore) * 60 / 100
        }
        
        // Food Processing (NOVA) - 30%
        if let novaGroup = product.nutriments.novaGroup {
            totalScore += calculateNovaScore(Int(novaGroup)) * 30 / 100
        }
        
        // Environmental Impact (Eco-Score) - 10%
        if let ecoScore = product.ecoscoreGrade {
            totalScore += calculateEcoScore(ecoScore) * 10 / 100
        }
        
        return totalScore
    }

    private func calculateNutriScoreGrade(_ grade: String) -> Int {
        switch grade.lowercased() {
        case "a":
            return 100
        case "b":
            return 80
        case "c":
            return 60
        case "d":
            return 40
        case "e":
            return 20
        default:
            return 0
        }
    }
    
    private func calculateNovaScore(_ group: Int) -> Int {
        switch group {
        case 1:
            return 100
        case 2:
            return 75
        case 3:
            return 50
        case 4:
            return 25
        default:
            return 0
        }
    }
    
    private func calculateEcoScore(_ grade: String) -> Int {
        switch grade.lowercased() {
        case "a":
            return 100
        case "b":
            return 80
        case "c":
            return 60
        case "d":
            return 40
        case "e":
            return 20
        default:
            return 0
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(AuthViewModel())
        .environmentObject(HistoryViewModel())
}
