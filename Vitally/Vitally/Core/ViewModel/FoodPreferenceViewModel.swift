import Foundation

class FoodPreferenceViewModel: ObservableObject {
    @Published var preferences = FoodPreferences()
    
    func calculateMatchPercentage(for product: Product) -> Int {
        var totalWeight = 0
        var matchScore = 0
        
        // Nutritional Quality
        matchScore += scoreMatch(preferences.goodNutritionalQuality, isGoodNutritionGrade(product.nutritionGrades))
        totalWeight += weight(preferences.goodNutritionalQuality)
        
        matchScore += scoreMatch(preferences.lowSalt, product.nutriments.salt, lowIsBetter: true)
        totalWeight += weight(preferences.lowSalt)
        
        matchScore += scoreMatch(preferences.lowSugar, product.nutriments.sugars, lowIsBetter: true)
        totalWeight += weight(preferences.lowSugar)
        
        matchScore += scoreMatch(preferences.lowFat, product.nutriments.fat, lowIsBetter: true)
        totalWeight += weight(preferences.lowFat)
        
        matchScore += scoreMatch(preferences.lowSaturatedFat, product.nutriments.saturatedFat, lowIsBetter: true)
        totalWeight += weight(preferences.lowSaturatedFat)
        
        // Food Processing
        matchScore += scoreMatch(preferences.noProcessing, product.nutriments.novaGroup)
        totalWeight += weight(preferences.noProcessing)
        
        // Allergens
        for (allergen, importance) in preferences.allergens {
            if let containsAllergen = product.allergens?.contains(allergen) {
                matchScore += scoreMatch(importance, !containsAllergen)
            }
            totalWeight += weight(importance)
        }
        
        // Ingredients
        for (ingredient, importance) in preferences.ingredients {
            matchScore += scoreMatch(importance, ingredientMatches(product: product, ingredient: ingredient))
            totalWeight += weight(importance)
        }
        
        // Labels
        for (label, importance) in preferences.labels {
            matchScore += scoreMatch(importance, labelMatches(product: product, label: label))
            totalWeight += weight(importance)
        }
        
        guard totalWeight > 0 else { return 0 }
        
        return (matchScore * 100) / totalWeight
    }
    
    private func isGoodNutritionGrade(_ grade: String) -> Bool {
        return grade.lowercased() == "a" || grade.lowercased() == "b"
    }
    
    private func scoreMatch(_ preference: ImportanceLevel, _ condition: Bool) -> Int {
        return condition ? weight(preference) : 0
    }
    
    private func scoreMatch(_ preference: ImportanceLevel, _ value: Double?, lowIsBetter: Bool = false) -> Int {
        guard let value = value else { return 0 }
        switch preference {
        case .notImportant: return 0
        case .important: return lowIsBetter ? (value <= 0.1 ? 1 : 0) : (value > 0.1 ? 1 : 0)
        case .veryImportant: return lowIsBetter ? (value <= 0.05 ? 2 : 0) : (value > 0.05 ? 2 : 0)
        case .mandatory: return lowIsBetter ? (value == 0 ? 3 : 0) : (value > 0 ? 3 : 0)
        }
    }
    
    private func weight(_ preference: ImportanceLevel) -> Int {
        switch preference {
        case .notImportant: return 0
        case .important: return 1
        case .veryImportant: return 2
        case .mandatory: return 3
        }
    }
    
    private func ingredientMatches(product: Product, ingredient: String) -> Bool {
        // Implement logic to determine if the ingredient matches
        // Placeholder logic, should be implemented based on your data
        return product.productName.contains(ingredient)
    }
    
    private func labelMatches(product: Product, label: String) -> Bool {
        // Implement logic to determine if the label matches
        // Placeholder logic, should be implemented based on your data
        return product.brands.contains(label)
    }
}
