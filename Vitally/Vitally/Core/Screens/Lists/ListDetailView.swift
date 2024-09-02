import SwiftUI

struct ListDetailView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    var list: FoodList
    var imageSize: CGFloat = 65

    var uniqueProducts: [Product] {
        var seen = Set<String>()
        return list.items.filter { product in
            guard !seen.contains(product.id) else { return false }
            seen.insert(product.id)
            return true
        }
    }

    var averageMatchScore: Double {
        let totalScore = uniqueProducts.reduce(0.0) { sum, product in
            sum + Double(calculateMatchScore(for: product))
        }
        return uniqueProducts.isEmpty ? 0.0 : totalScore / Double(uniqueProducts.count)
    }

    var body: some View {
        VStack {
            
            List {
                Section{
                    HStack{
                        Text("Your list score: ")
                            .font(.title)
                        MatchPercentageView(percentage: Int(averageMatchScore), description: "Match with your food preferences")
                    }
                } 
                ForEach(uniqueProducts) { product in
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
                                Text("Nutri-Score: \(product.nutritionGrades.capitalized)")
                                    .font(.callout)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    removeItems(at: indexSet)
                }
            }
            .navigationTitle(list.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action to add item
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func removeItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = list.items[index]
            listViewModel.removeItem(from: list.id, product: product)
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

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView(list: FoodList(id: "1", name: "Sample List", items: [Product.mockProduct]))
            .environmentObject(ListViewModel())
    }
}
