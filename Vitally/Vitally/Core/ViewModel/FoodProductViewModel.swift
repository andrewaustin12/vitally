import SwiftUI
import FirebaseFirestore

@MainActor
class FoodProductViewModel: ObservableObject {
    @Published var product: Product?

    private var db = Firestore.firestore()

    func fetchFoodProduct(barcode: String) async {
        // Validate that the barcode is numeric and reasonable length
        guard isValidBarcode(barcode) else {
            print("❌ Invalid barcode format: \(barcode)")
            return
        }
        
        let docRef = db.collection("products").document(barcode)
        
        do {
            let document = try await docRef.getDocument()
            if let data = document.data(), document.exists {
                parseProductData(data: data)
                print("✅ Getting from Firestore DB")
            } else {
                print("📡 Product not in cache, fetching from API")
                await getProductFromApi(barcode: barcode)
            }
        } catch {
            print("⚠️ Firestore access error: \(error.localizedDescription)")
            print("📡 Falling back to API call")
            await getProductFromApi(barcode: barcode)
        }
    }

    private func isValidBarcode(_ barcode: String) -> Bool {
        // Check if barcode is numeric and between 8-14 digits (standard barcode lengths)
        let numericOnly = barcode.trimmingCharacters(in: .whitespacesAndNewlines)
        let isNumeric = numericOnly.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        let isValidLength = numericOnly.count >= 8 && numericOnly.count <= 14
        
        return isNumeric && isValidLength
    }

    private func parseProductData(data: [String: Any]) {
        do {
            var modifiedData = data
            if let timestamp = data["timestamp"] as? Timestamp {
                modifiedData["timestamp"] = timestamp.dateValue().timeIntervalSince1970
            }

            let jsonData = try JSONSerialization.data(withJSONObject: modifiedData)
            let product = try JSONDecoder().decode(Product.self, from: jsonData)
            self.product = product
        } catch {
            print("Error decoding product data: \(error.localizedDescription)")
        }
    }

    func getProductFromApi(barcode: String) async {
        let fields = [
            "code",
            "product_name",
            "image_url",
            "nutriscore_data",
            "nutriments",
            "nutrition_grades",
            "brands",
            "ecoscore_grade",
            "ecoscore_score",
            "allergens",
            "labels_tags",
            "ingredients_text",
            "ingredients_tags",
            "ingredients_analysis_tags",
            "additives_tags",
            "vitamins_tags"
        ].joined(separator: ",")
        
        let endpoint = "https://world.openfoodfacts.org/api/v2/product/\(barcode)?fields=\(fields)"
        print("🔍 Fetching from API: \(endpoint)")
        
        guard let url = URL(string: endpoint) else {
            print("❌ Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Invalid response from the server. Status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }

            // Print raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw API Response: \(jsonString)")
            }

            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse.self, from: data)
            
            print("✅ API Response - Status: \(apiResponse.status), StatusVerbose: \(apiResponse.statusVerbose)")
            
            // Check if the API indicates the product was found
            if apiResponse.status == 1, let product = apiResponse.product {
                print("✅ Product found: \(product.displayName)")
                self.product = product
                Task {
                    await self.saveProductToCache(barcode: barcode, product: product)
                }
            } else {
                print("❌ Product not found in API response. Status: \(apiResponse.status), Message: \(apiResponse.statusVerbose)")
                self.product = nil
            }
        } catch {
            print("❌ Failed to decode data: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
        }
    }

    private func saveProductToCache(barcode: String, product: Product) async {
        do {
            let data = try JSONEncoder().encode(product)
            var dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            dictionary?["timestamp"] = FieldValue.serverTimestamp()
            try await db.collection("products").document(barcode).setData(dictionary ?? [:])
            print("Saved to Firestore")
        } catch {
            print("Error saving product to cache: \(error.localizedDescription)")
        }
    }

    func resetProduct() {
        self.product = nil
    }
    
    func createProductFromHistory(_ history: UserHistory) -> Product {
        // Reconstruct Nutriments from history data
        let nutriments = Nutriments(
            carbohydrates: history.carbohydrates,
            carbohydrates100G: history.carbohydrates100G,
            carbohydratesUnit: "g",
            carbohydratesValue: history.carbohydrates,
            energy: history.energyKcal,
            energyKcal: history.energyKcal,
            energyKcal100G: history.energyKcal100G,
            energyKcalUnit: "kcal",
            energyKcalValue: history.energyKcal,
            energyKcalValueComputed: history.energyKcal,
            energy100G: history.energyKcal100G,
            energyUnit: "kcal",
            energyValue: history.energyKcal,
            fat: history.fat,
            fat100G: history.fat100G,
            fatUnit: "g",
            fatValue: history.fat,
            fruitsVegetablesLegumesEstimateFromIngredients100G: nil,
            fruitsVegetablesLegumesEstimateFromIngredientsServing: nil,
            fruitsVegetablesNutsEstimateFromIngredients100G: nil,
            fruitsVegetablesNutsEstimateFromIngredientsServing: nil,
            novaGroup: history.novaGroup,
            novaGroup100G: history.novaGroup,
            novaGroupServing: history.novaGroup,
            nutritionScoreFr: nil,
            nutritionScoreFr100G: nil,
            proteins: history.proteins,
            proteins100G: history.proteins100G,
            proteinsUnit: "g",
            proteinsValue: history.proteins,
            salt: history.salt,
            salt100G: history.salt100G,
            saltUnit: "g",
            saltValue: history.salt,
            saturatedFat: history.saturatedFat,
            saturatedFat100G: history.saturatedFat100G,
            saturatedFatUnit: "g",
            saturatedFatValue: history.saturatedFat,
            sodium: history.sodium,
            sodium100G: history.sodium100G,
            sodiumUnit: "g",
            sodiumValue: history.sodium,
            sugars: history.sugars,
            sugars100G: history.sugars100G,
            sugarsUnit: "g",
            sugarsValue: history.sugars
        )
        
        // Reconstruct NutriscoreData from history data
        var nutriscoreData: NutriscoreData?
        if let grade = history.nutriscoreGrade {
            nutriscoreData = NutriscoreData(
                energy: history.nutriscoreEnergy,
                energyPoints: history.nutriscoreEnergyPoints,
                energyValue: history.nutriscoreEnergy,
                fiber: history.nutriscoreFiber,
                fiberPoints: history.nutriscoreFiberPoints,
                fiberValue: history.nutriscoreFiber,
                fruitsVegetablesNutsColzaWalnutOliveOils: history.nutriscoreFruitsVegetablesNuts,
                fruitsVegetablesNutsColzaWalnutOliveOilsPoints: history.nutriscoreFruitsVegetablesNutsPoints,
                fruitsVegetablesNutsColzaWalnutOliveOilsValue: history.nutriscoreFruitsVegetablesNuts,
                grade: grade,
                isBeverage: nil,
                isCheese: nil,
                isFat: nil,
                isWater: nil,
                negativePoints: history.nutriscoreNegativePoints,
                positivePoints: history.nutriscorePositivePoints,
                proteins: history.nutriscoreProteins,
                proteinsPoints: history.nutriscoreProteinsPoints,
                proteinsValue: history.nutriscoreProteins,
                saturatedFat: history.nutriscoreSaturatedFat,
                saturatedFatPoints: history.nutriscoreSaturatedFatPoints,
                saturatedFatValue: history.nutriscoreSaturatedFat,
                score: history.nutriscoreScore,
                sodium: history.nutriscoreSodium,
                sodiumPoints: history.nutriscoreSodiumPoints,
                sodiumValue: history.nutriscoreSodium,
                sugars: history.nutriscoreSugars,
                sugarsPoints: history.nutriscoreSugarsPoints,
                sugarsValue: history.nutriscoreSugars
            )
        }
        
        // Create and return the complete Product object
        return Product(
            code: history.barcode,
            imageURL: history.imageURL,
            nutriments: nutriments,
            nutriscoreData: nutriscoreData,
            ecoscoreGrade: history.ecoscoreGrade,
            ecoscoreScore: history.ecoscoreScore,
            allergens: history.allergens,
            ingredients: history.ingredients,
            ingredientsTags: nil,
            ingredientsAnalysisTags: nil,
            labels: history.labels,
            nutritionGrades: history.nutritionGrade,
            productName: history.productName,
            brands: history.productBrand,
            additives: history.additives,
            vitamins: history.vitamins,
            timestamp: history.timestamp
        )
    }
    
    func createProductFromListProduct(_ listProduct: ListProduct) -> Product {
        // Reconstruct Nutriments from ListProduct data
        let nutriments = Nutriments(
            carbohydrates: listProduct.carbohydrates,
            carbohydrates100G: listProduct.carbohydrates100G,
            carbohydratesUnit: "g",
            carbohydratesValue: listProduct.carbohydrates,
            energy: listProduct.energyKcal,
            energyKcal: listProduct.energyKcal,
            energyKcal100G: listProduct.energyKcal100G,
            energyKcalUnit: "kcal",
            energyKcalValue: listProduct.energyKcal,
            energyKcalValueComputed: listProduct.energyKcal,
            energy100G: listProduct.energyKcal100G,
            energyUnit: "kcal",
            energyValue: listProduct.energyKcal,
            fat: listProduct.fat,
            fat100G: listProduct.fat100G,
            fatUnit: "g",
            fatValue: listProduct.fat,
            fruitsVegetablesLegumesEstimateFromIngredients100G: nil,
            fruitsVegetablesLegumesEstimateFromIngredientsServing: nil,
            fruitsVegetablesNutsEstimateFromIngredients100G: nil,
            fruitsVegetablesNutsEstimateFromIngredientsServing: nil,
            novaGroup: listProduct.novaGroup,
            novaGroup100G: listProduct.novaGroup,
            novaGroupServing: listProduct.novaGroup,
            nutritionScoreFr: nil,
            nutritionScoreFr100G: nil,
            proteins: listProduct.proteins,
            proteins100G: listProduct.proteins100G,
            proteinsUnit: "g",
            proteinsValue: listProduct.proteins,
            salt: listProduct.salt,
            salt100G: listProduct.salt100G,
            saltUnit: "g",
            saltValue: listProduct.salt,
            saturatedFat: listProduct.saturatedFat,
            saturatedFat100G: listProduct.saturatedFat100G,
            saturatedFatUnit: "g",
            saturatedFatValue: listProduct.saturatedFat,
            sodium: listProduct.sodium,
            sodium100G: listProduct.sodium100G,
            sodiumUnit: "g",
            sodiumValue: listProduct.sodium,
            sugars: listProduct.sugars,
            sugars100G: listProduct.sugars100G,
            sugarsUnit: "g",
            sugarsValue: listProduct.sugars
        )
        
        // Create and return the complete Product object
        return Product(
            code: listProduct.productCode,
            imageURL: listProduct.imageURL,
            nutriments: nutriments,
            nutriscoreData: nil, // ListProduct doesn't store nutriscore data
            ecoscoreGrade: listProduct.ecoscoreGrade,
            ecoscoreScore: listProduct.ecoscoreScore,
            allergens: listProduct.allergens,
            ingredients: listProduct.ingredients,
            ingredientsTags: nil,
            ingredientsAnalysisTags: nil,
            labels: listProduct.labels,
            nutritionGrades: listProduct.nutritionGrade,
            productName: listProduct.productName,
            brands: listProduct.productBrand,
            additives: listProduct.additives,
            vitamins: listProduct.vitamins,
            timestamp: listProduct.timestamp
        )
    }
}
