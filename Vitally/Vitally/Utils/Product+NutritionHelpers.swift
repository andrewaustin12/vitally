import Foundation
import SwiftUI

extension Product {
    // Helper to get % daily value for vitamins/minerals if available in nutriments
    func nutrimentsValuePercent(for key: String) -> Double? {
        // Example: vitamin_d_100g_percent
        let mirror = Mirror(reflecting: nutriments)
        for child in mirror.children {
            if let label = child.label, label.contains(key), label.contains("percent"), let value = child.value as? Double {
                return value
            }
        }
        return nil
    }
    
    // Positive nutrients for display
    func getPositiveNutrients() -> [(String, String)] {
        var positiveNutrients = [(String, String)]()
        if let fiber = nutriscoreData?.fiber, fiber > 0 {
            positiveNutrients.append(("fiber", "\(fiber) g"))
        }
        if let proteins = nutriments.proteins, proteins > 0 {
            positiveNutrients.append(("proteins", "\(proteins) g"))
        }
        if let fruitsVegetables = nutriments.fruitsVegetablesNutsEstimateFromIngredients100G, fruitsVegetables > 0 {
            positiveNutrients.append(("fruitsvegetables", "\(Int(fruitsVegetables)) g"))
        }
        if let vitamins = vitamins {
            for vitamin in vitamins {
                let key = vitamin.lowercased().replacingOccurrences(of: "-", with: "_")
                if let percent = nutrimentsValuePercent(for: key), percent > 0 {
                    positiveNutrients.append((vitamin.lowercased(), "\(Int(percent))%"))
                }
            }
        }
        // TODO: Add minerals if available in API and have %
        return positiveNutrients
    }
    
    // Negative nutrients for display
    func getNegativeNutrients() -> [(String, String)] {
        var negativeNutrients = [(String, String)]()
        if let sugars = nutriments.sugars, sugars > 0 {
            negativeNutrients.append(("sugars", "\(sugars) g"))
        }
        if let salt = nutriments.salt, salt > 0 {
            negativeNutrients.append(("salt", "\(salt) g"))
        }
        if let sodium = nutriments.sodium, sodium > 0 {
            negativeNutrients.append(("sodium", "\(sodium) g"))
        }
        if let saturatedFat = nutriments.saturatedFat, saturatedFat > 0 {
            negativeNutrients.append(("saturatedfat", "\(saturatedFat) g"))
        }
        if let energy = nutriments.energyKcal, energy > 0 {
            negativeNutrients.append(("energy", "\(Int(energy)) kcal"))
        }
        // TODO: Add trans fat, cholesterol if available and > 0
        return negativeNutrients
    }
}

// MARK: - Nutrition Formatting Helpers

func prettyNutrientName(_ key: String) -> String {
    let mapping: [String: String] = [
        "fiber": "Fiber",
        "proteins": "Proteins",
        "fruitsvegetables": "Fruits & Vegetables",
        "sugars": "Sugars",
        "salt": "Salt",
        "sodium": "Sodium",
        "saturatedfat": "Saturated Fat",
        "energy": "Energy",
        "vitamins": "Vitamins",
        // Add more mappings as needed
    ]
    if let mapped = mapping[key.lowercased()] {
        return mapped
    }
    return key.replacingOccurrences(of: "([a-z])([A-Z0-9])", with: "$1 $2", options: .regularExpression).capitalized
}

func formatLabels(_ labels: [String]) -> [String] {
    return labels
        .map { $0.replacingOccurrences(of: "en:", with: "") }
        .map { $0.replacingOccurrences(of: "-", with: " ") }
        .map { $0.capitalized }
        .filter { !$0.isEmpty }
}

func formattedAllergens(_ allergens: String) -> String {
    allergens
        .split(separator: ",")
        .map { $0.replacingOccurrences(of: "en:", with: "").capitalized }
        .joined(separator: ", ")
}

func formattedAllergensArray(_ allergens: String) -> [String] {
    allergens
        .split(separator: ",")
        .map { $0.replacingOccurrences(of: "en:", with: "").capitalized.trimmingCharacters(in: .whitespaces) }
}

func formatIngredientsTags(_ ingredientsTags: [String]) -> [String] {
    return ingredientsTags
        .map { $0.replacingOccurrences(of: "en:", with: "") }
        .map { $0.replacingOccurrences(of: "-", with: " ") }
        .map { $0.capitalized }
        .filter { !$0.isEmpty && $0.count > 2 }
}

func formatIngredientsArray(_ ingredients: String) -> [String] {
    // Clean up the ingredients string
    let cleanedIngredients = ingredients
        .replacingOccurrences(of: "en:", with: "")
        .replacingOccurrences(of: "  ", with: " ")
        .trimmingCharacters(in: .whitespaces)
    
    // Split by commas only - this is the standard separator for ingredients
    let ingredientsList = cleanedIngredients
        .split(separator: ",")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
    
    // Clean up and return results
    return ingredientsList
        .map { $0.capitalized }
        .filter { $0.count > 2 } // Filter out very short strings
        .map { $0 }
}

// MARK: - Daily Value Calculation

enum NutrientType {
    case energy, proteins, carbohydrates, fats, saturatedFat, sugars, salt, sodium, fiber, fruitsVegetablesNuts
}

func calculateDailyValue(for value: Double, nutrient: NutrientType) -> Int {
    let dailyValues: [NutrientType: Double] = [
        .energy: 2000,
        .proteins: 50,
        .carbohydrates: 300,
        .fats: 70,
        .saturatedFat: 20,
        .sugars: 50,
        .salt: 6,
        .sodium: 2.4,
        .fiber: 25,
        .fruitsVegetablesNuts: 400
    ]
    return Int((value / dailyValues[nutrient]!) * 100)
} 