import SwiftUI
import SwiftData

struct ListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var list: UserList
    var imageSize: CGFloat = 65
    
    @State private var showAddToListSheet = false

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
                
                if uniqueItems.isEmpty {
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("No Items Yet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Add products to this list to get started")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                } else {
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
            }
            .navigationTitle(list.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddToListSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddToListSheet) {
                AddToListView(list: list, isPresented: $showAddToListSheet)
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
                carbohydrates: historyItem.carbohydrates,
                carbohydrates100G: historyItem.carbohydrates100G,
                carbohydratesUnit: nil,
                carbohydratesValue: historyItem.carbohydrates,
                energy: historyItem.energyKcal,
                energyKcal: historyItem.energyKcal,
                energyKcal100G: historyItem.energyKcal100G,
                energyKcalUnit: nil,
                energyKcalValue: historyItem.energyKcal,
                energyKcalValueComputed: historyItem.energyKcal,
                energy100G: historyItem.energyKcal100G,
                energyUnit: nil,
                energyValue: historyItem.energyKcal,
                fat: historyItem.fat,
                fat100G: historyItem.fat100G,
                fatUnit: nil,
                fatValue: historyItem.fat,
                fruitsVegetablesLegumesEstimateFromIngredients100G: nil,
                fruitsVegetablesLegumesEstimateFromIngredientsServing: nil,
                fruitsVegetablesNutsEstimateFromIngredients100G: nil,
                fruitsVegetablesNutsEstimateFromIngredientsServing: nil,
                novaGroup: historyItem.novaGroup,
                novaGroup100G: historyItem.novaGroup,
                novaGroupServing: historyItem.novaGroup,
                nutritionScoreFr: nil,
                nutritionScoreFr100G: nil,
                proteins: historyItem.proteins,
                proteins100G: historyItem.proteins100G,
                proteinsUnit: nil,
                proteinsValue: historyItem.proteins,
                salt: historyItem.salt,
                salt100G: historyItem.salt100G,
                saltUnit: nil,
                saltValue: historyItem.salt,
                saturatedFat: historyItem.saturatedFat,
                saturatedFat100G: historyItem.saturatedFat100G,
                saturatedFatUnit: nil,
                saturatedFatValue: historyItem.saturatedFat,
                sodium: historyItem.sodium,
                sodium100G: historyItem.sodium100G,
                sodiumUnit: nil,
                sodiumValue: historyItem.sodium,
                sugars: historyItem.sugars,
                sugars100G: historyItem.sugars100G,
                sugarsUnit: nil,
                sugarsValue: historyItem.sugars
            ),
            nutriscoreData: createNutriscoreData(from: historyItem),
            ecoscoreGrade: historyItem.ecoscoreGrade,
            ecoscoreScore: historyItem.ecoscoreScore,
            allergens: historyItem.allergens,
            ingredients: historyItem.ingredients,
            labels: historyItem.labels,
            nutritionGrades: historyItem.nutritionGrade,
            productName: historyItem.productName,
            brands: historyItem.productBrand,
            additives: historyItem.additives,
            vitamins: historyItem.vitamins,
            timestamp: historyItem.timestamp
        )
    }
    
    private func createNutriscoreData(from historyItem: UserHistory) -> NutriscoreData? {
        guard let grade = historyItem.nutriscoreGrade,
              let score = historyItem.nutriscoreScore else {
            return nil
        }
        
        return NutriscoreData(
            energy: historyItem.nutriscoreEnergy ?? 0,
            energyPoints: historyItem.nutriscoreEnergyPoints ?? 0,
            energyValue: historyItem.nutriscoreEnergy ?? 0,
            fiber: historyItem.nutriscoreFiber ?? 0,
            fiberPoints: historyItem.nutriscoreFiberPoints ?? 0,
            fiberValue: historyItem.nutriscoreFiber ?? 0,
            fruitsVegetablesNutsColzaWalnutOliveOils: historyItem.nutriscoreFruitsVegetablesNuts ?? 0,
            fruitsVegetablesNutsColzaWalnutOliveOilsPoints: historyItem.nutriscoreFruitsVegetablesNutsPoints ?? 0,
            fruitsVegetablesNutsColzaWalnutOliveOilsValue: historyItem.nutriscoreFruitsVegetablesNuts ?? 0,
            grade: grade,
            isBeverage: 0,
            isCheese: 0,
            isFat: 0,
            isWater: 0,
            negativePoints: historyItem.nutriscoreNegativePoints ?? 0,
            positivePoints: historyItem.nutriscorePositivePoints ?? 0,
            proteins: historyItem.nutriscoreProteins ?? 0,
            proteinsPoints: historyItem.nutriscoreProteinsPoints ?? 0,
            proteinsValue: historyItem.nutriscoreProteins ?? 0,
            saturatedFat: historyItem.nutriscoreSaturatedFat ?? 0,
            saturatedFatPoints: historyItem.nutriscoreSaturatedFatPoints ?? 0,
            saturatedFatValue: historyItem.nutriscoreSaturatedFat ?? 0,
            score: score,
            sodium: historyItem.nutriscoreSodium ?? 0,
            sodiumPoints: historyItem.nutriscoreSodiumPoints ?? 0,
            sodiumValue: historyItem.nutriscoreSodium ?? 0,
            sugars: historyItem.nutriscoreSugars ?? 0,
            sugarsPoints: historyItem.nutriscoreSugarsPoints ?? 0,
            sugarsValue: historyItem.nutriscoreSugars ?? 0
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

struct AddToListView: View {
    let list: UserList
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView()
                    .environmentObject(searchViewModel)
            }
            .navigationTitle("Add to \(list.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView(list: UserList(name: "Sample List"))
    }
}
