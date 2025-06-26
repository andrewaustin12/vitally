import SwiftUI
import SwiftData

struct ListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var list: UserList
    var imageSize: CGFloat = 65

    var uniqueItems: [UserHistory] {
        var seen = Set<String>()
        var uniqueItems = [UserHistory]()
        
        for item in list.items {
            if !seen.contains(item.id) {
                seen.insert(item.id)
                uniqueItems.append(item)
            }
        }
        
        return uniqueItems
    }

    var averageMatchScore: Double {
        let totalScore = uniqueItems.reduce(0.0) { sum, item in
            sum + Double(calculateMatchScore(for: item))
        }
        return uniqueItems.isEmpty ? 0.0 : totalScore / Double(uniqueItems.count)
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
                ForEach(uniqueItems, id: \.id) { item in
                    NavigationLink(destination: ProductDetailsView(product: createProductFromHistory(item))) {
                        HStack {
                            ImageLoaderView(urlString: item.imageURL)
                                .frame(width: imageSize, height: imageSize)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(item.productName)
                                    .font(.headline)
                                Text(item.productBrand)
                                    .font(.subheadline)
                                Text("Nutri-Score: \(item.nutritionGrade.capitalized)")
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
            let item = uniqueItems[index]
            // Remove the specific item by its unique id
            list.items.removeAll { $0.id == item.id }
            list.updateLastModified()
        }
    }
    
    private func createProductFromHistory(_ historyItem: UserHistory) -> Product {
        return Product(
            code: historyItem.barcode,
            imageURL: historyItem.imageURL,
            nutriments: Nutriments(
                carbohydrates: nil,
                carbohydrates100G: nil,
                carbohydratesUnit: nil,
                carbohydratesValue: nil,
                energy: nil,
                energyKcal: nil,
                energyKcal100G: nil,
                energyKcalUnit: nil,
                energyKcalValue: nil,
                energyKcalValueComputed: nil,
                energy100G: nil,
                energyUnit: nil,
                energyValue: nil,
                fat: nil,
                fat100G: nil,
                fatUnit: nil,
                fatValue: nil,
                fruitsVegetablesLegumesEstimateFromIngredients100G: nil,
                fruitsVegetablesLegumesEstimateFromIngredientsServing: nil,
                fruitsVegetablesNutsEstimateFromIngredients100G: nil,
                fruitsVegetablesNutsEstimateFromIngredientsServing: nil,
                novaGroup: nil,
                novaGroup100G: nil,
                novaGroupServing: nil,
                nutritionScoreFr: nil,
                nutritionScoreFr100G: nil,
                proteins: nil,
                proteins100G: nil,
                proteinsUnit: nil,
                proteinsValue: nil,
                salt: nil,
                salt100G: nil,
                saltUnit: nil,
                saltValue: nil,
                saturatedFat: nil,
                saturatedFat100G: nil,
                saturatedFatUnit: nil,
                saturatedFatValue: nil,
                sodium: nil,
                sodium100G: nil,
                sodiumUnit: nil,
                sodiumValue: nil,
                sugars: nil,
                sugars100G: nil,
                sugarsUnit: nil,
                sugarsValue: nil
            ),
            nutriscoreData: nil,
            ecoscoreGrade: nil,
            ecoscoreScore: nil,
            allergens: nil,
            ingredients: nil,
            labels: nil,
            nutritionGrades: historyItem.nutritionGrade,
            productName: historyItem.productName,
            brands: historyItem.productBrand,
            additives: nil,
            vitamins: nil,
            timestamp: historyItem.timestamp
        )
    }

    private func calculateMatchScore(for item: UserHistory) -> Int {
        var totalScore = 0
        
        // Nutritional Quality - 60%
        totalScore += calculateNutriScoreGrade(item.nutritionGrade) * 60 / 100
        
        // For now, we'll use a default score since we don't have full product data
        totalScore += 50 * 40 / 100 // Default score for other factors
        
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
        ListDetailView(list: UserList(name: "Sample List"))
    }
}
