import Foundation
import Foundation

// Define the root structure of the API response
struct APIResponse: Codable {
    let code: String
    let product: Product?
    let status: Int
    let statusVerbose: String

    enum CodingKeys: String, CodingKey {
        case code, product, status
        case statusVerbose = "status_verbose"
    }
}


// MARK: - Product
struct Product: Codable, Identifiable, Equatable {
    var id: String { code }
    let code: String
    let imageURL: String
    let nutriments: Nutriments
    let nutriscoreData: NutriscoreData?
    let ecoscoreGrade: String?
    let ecoscoreScore: Int?
    let allergens: String?
    let ingredients: String? // Add ingredients
    let ingredientsTags: [String]? // Add structured ingredients
    let ingredientsAnalysisTags: [String]? // Add ingredient analysis
    let labels: [String]? // Add labels
    let nutritionGrades: String?
    let productName: String?
    let brands: String?
    let additives: [String]?
    let vitamins: [String]?
    var timestamp: Date?
    
    // Computed properties for display with fallbacks
    var displayName: String {
        return productName ?? "Unknown Product"
    }
    
    var displayBrands: String {
        return brands ?? "Unknown Brand"
    }
    
    var displayNutritionGrades: String {
        return nutritionGrades ?? "unknown"
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
            return lhs.id == rhs.id
        }

    enum CodingKeys: String, CodingKey {
        case code
        case imageURL = "image_url"
        case nutriments
        case nutriscoreData = "nutriscore_data"
        case ecoscoreGrade = "ecoscore_grade"
        case ecoscoreScore = "ecoscore_score"
        case allergens = "allergens"
        case ingredients = "ingredients_text" // Match the API response key
        case ingredientsTags = "ingredients_tags"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
        case labels = "labels_tags" // Match the API response key
        case nutritionGrades = "nutrition_grades"
        case productName = "product_name"
        case brands = "brands"
        case additives = "additives_tags"
        case vitamins = "vitamins_tags"
        case timestamp
    }
    
    // MARK: Mock Product Nutella
    static let mockProduct = Product(
            code: "3017624010701",
            imageURL: "https://images.openfoodfacts.net/images/products/301/762/401/0701/front_en.54.400.jpg",
            nutriments: Nutriments(
                carbohydrates: 57.5,
                carbohydrates100G: 57.5,
                carbohydratesUnit: "g",
                carbohydratesValue: 57.5,
                energy: 2255,
                energyKcal: 539,
                energyKcal100G: 539,
                energyKcalUnit: "kcal",
                energyKcalValue: 539,
                energyKcalValueComputed: 533.3,
                energy100G: 2255,
                energyUnit: "kcal",
                energyValue: 539,
                fat: 30.9,
                fat100G: 30.9,
                fatUnit: "g",
                fatValue: 30.9,
                fruitsVegetablesLegumesEstimateFromIngredients100G: 0,
                fruitsVegetablesLegumesEstimateFromIngredientsServing: 0,
                fruitsVegetablesNutsEstimateFromIngredients100G: 10.7142857142857,
                fruitsVegetablesNutsEstimateFromIngredientsServing: 10.7142857142857,
                novaGroup: 4,
                novaGroup100G: 4,
                novaGroupServing: 4,
                nutritionScoreFr: 26,
                nutritionScoreFr100G: 26,
                proteins: 6.3,
                proteins100G: 6.3,
                proteinsUnit: "g",
                proteinsValue: 6.3,
                salt: 0.1075,
                salt100G: 0.1075,
                saltUnit: "g",
                saltValue: 0.1075,
                saturatedFat: 10.6,
                saturatedFat100G: 10.6,
                saturatedFatUnit: "g",
                saturatedFatValue: 10.6,
                sodium: 0.043,
                sodium100G: 0.043,
                sodiumUnit: "g",
                sodiumValue: 0.043,
                sugars: 56.3,
                sugars100G: 56.3,
                sugarsUnit: "g",
                sugarsValue: 56.3
            ),
            nutriscoreData: NutriscoreData(
                energy: 2255,
                energyPoints: 6,
                energyValue: 2255,
                fiber: 0,
                fiberPoints: 0,
                fiberValue: 0,
                fruitsVegetablesNutsColzaWalnutOliveOils: 10.7142857142857,
                fruitsVegetablesNutsColzaWalnutOliveOilsPoints: 0,
                fruitsVegetablesNutsColzaWalnutOliveOilsValue: 10.7,
                grade: "e",
                isBeverage: 0,
                isCheese: 0,
                isFat: 0,
                isWater: 0,
                negativePoints: 26,
                positivePoints: 0,
                proteins: 6.3,
                proteinsPoints: 3,
                proteinsValue: 6.3,
                saturatedFat: 10.6,
                saturatedFatPoints: 10,
                saturatedFatValue: 10.6,
                score: 26,
                sodium: 43,
                sodiumPoints: 0,
                sodiumValue: 43,
                sugars: 56.3,
                sugarsPoints: 10,
                sugarsValue: 56.3
            ),
            ecoscoreGrade: "d",
            ecoscoreScore: 33,
            allergens: "fish, shells",
            ingredients: "sugar, palm oil, hazelnuts, skimmed milk powder, fat reduced cocoa, emulsifier, vanillin",
            ingredientsTags: ["sugar", "palm oil", "hazelnuts", "skimmed milk powder", "fat reduced cocoa", "emulsifier", "vanillin"],
            ingredientsAnalysisTags: [],
            labels: [],
            nutritionGrades: "e",
            productName: "Nutella",
            brands: "Nutella Ferrero",
            additives: ["palm oil"],
            vitamins: ["vitamin-d"],
            timestamp: Date()
        )
}

// MARK: - Nutriments
struct Nutriments: Codable {
    let carbohydrates, carbohydrates100G: Double?
    let carbohydratesUnit: String?
    let carbohydratesValue: Double?
    let energy, energyKcal, energyKcal100G: Double?
    let energyKcalUnit: String?
    let energyKcalValue: Double?
    let energyKcalValueComputed: Double?
    let energy100G: Double?
    let energyUnit: String?
    let energyValue: Double?
    let fat, fat100G: Double?
    let fatUnit: String?
    let fatValue: Double?
    let fruitsVegetablesLegumesEstimateFromIngredients100G, fruitsVegetablesLegumesEstimateFromIngredientsServing: Double?
    let fruitsVegetablesNutsEstimateFromIngredients100G, fruitsVegetablesNutsEstimateFromIngredientsServing: Double?
    let novaGroup, novaGroup100G, novaGroupServing, nutritionScoreFr: Double?
    let nutritionScoreFr100G: Double?
    let proteins, proteins100G: Double?
    let proteinsUnit: String?
    let proteinsValue, salt, salt100G: Double?
    let saltUnit: String?
    let saltValue, saturatedFat, saturatedFat100G: Double?
    let saturatedFatUnit: String?
    let saturatedFatValue, sodium, sodium100G: Double?
    let sodiumUnit: String?
    let sodiumValue, sugars, sugars100G: Double?
    let sugarsUnit: String?
    let sugarsValue: Double?

    enum CodingKeys: String, CodingKey {
        case carbohydrates
        case carbohydrates100G = "carbohydrates_100g"
        case carbohydratesUnit = "carbohydrates_unit"
        case carbohydratesValue = "carbohydrates_value"
        case energy
        case energyKcal = "energy-kcal"
        case energyKcal100G = "energy-kcal_100g"
        case energyKcalUnit = "energy-kcal_unit"
        case energyKcalValue = "energy-kcal_value"
        case energyKcalValueComputed = "energy-kcal_value_computed"
        case energy100G = "energy_100g"
        case energyUnit = "energy_unit"
        case energyValue = "energy_value"
        case fat
        case fat100G = "fat_100g"
        case fatUnit = "fat_unit"
        case fatValue = "fat_value"
        case fruitsVegetablesLegumesEstimateFromIngredients100G = "fruits-vegetables-legumes-estimate-from-ingredients_100g"
        case fruitsVegetablesLegumesEstimateFromIngredientsServing = "fruits-vegetables-legumes-estimate-from-ingredients_serving"
        case fruitsVegetablesNutsEstimateFromIngredients100G = "fruits-vegetables-nuts-estimate-from-ingredients_100g"
        case fruitsVegetablesNutsEstimateFromIngredientsServing = "fruits-vegetables-nuts-estimate-from-ingredients_serving"
        case novaGroup = "nova-group"
        case novaGroup100G = "nova-group_100g"
        case novaGroupServing = "nova-group_serving"
        case nutritionScoreFr = "nutrition-score-fr"
        case nutritionScoreFr100G = "nutrition-score-fr_100g"
        case proteins
        case proteins100G = "proteins_100g"
        case proteinsUnit = "proteins_unit"
        case proteinsValue = "proteins_value"
        case salt
        case salt100G = "salt_100g"
        case saltUnit = "salt_unit"
        case saltValue = "salt_value"
        case saturatedFat = "saturated-fat"
        case saturatedFat100G = "saturated-fat_100g"
        case saturatedFatUnit = "saturated-fat_unit"
        case saturatedFatValue = "saturated-fat_value"
        case sodium
        case sodium100G = "sodium_100g"
        case sodiumUnit = "sodium_unit"
        case sodiumValue = "sodium_value"
        case sugars
        case sugars100G = "sugars_100g"
        case sugarsUnit = "sugars_unit"
        case sugarsValue = "sugars_value"
    }
}

// MARK: - NutriscoreData
struct NutriscoreData: Codable {
    let energy, energyPoints, energyValue: Double?
    let fiber: Double?
    let fiberPoints: Double?
    let fiberValue: Double?
    let fruitsVegetablesNutsColzaWalnutOliveOils: Double?
    let fruitsVegetablesNutsColzaWalnutOliveOilsPoints: Double?
    let fruitsVegetablesNutsColzaWalnutOliveOilsValue: Double?
    let grade: String?
    let isBeverage, isCheese, isFat, isWater: Double?
    let negativePoints, positivePoints: Double?
    let proteins: Double?
    let proteinsPoints: Double?
    let proteinsValue, saturatedFat: Double?
    let saturatedFatPoints: Double?
    let saturatedFatValue: Double?
    let score, sodium, sodiumPoints, sodiumValue: Double?
    let sugars: Double?
    let sugarsPoints: Double?
    let sugarsValue: Double?

    enum CodingKeys: String, CodingKey {
        case energy
        case energyPoints = "energy_points"
        case energyValue = "energy_value"
        case fiber
        case fiberPoints = "fiber_points"
        case fiberValue = "fiber_value"
        case fruitsVegetablesNutsColzaWalnutOliveOils = "fruits_vegetables_nuts_colza_walnut_olive_oils"
        case fruitsVegetablesNutsColzaWalnutOliveOilsPoints = "fruits_vegetables_nuts_colza_walnut_olive_oils_points"
        case fruitsVegetablesNutsColzaWalnutOliveOilsValue = "fruits_vegetables_nuts_colza_walnut_olive_oils_value"
        case grade
        case isBeverage = "is_beverage"
        case isCheese = "is_cheese"
        case isFat = "is_fat"
        case isWater = "is_water"
        case negativePoints = "negative_points"
        case positivePoints = "positive_points"
        case proteins
        case proteinsPoints = "proteins_points"
        case proteinsValue = "proteins_value"
        case saturatedFat = "saturated_fat"
        case saturatedFatPoints = "saturated_fat_points"
        case saturatedFatValue = "saturated_fat_value"
        case score, sodium
        case sodiumPoints = "sodium_points"
        case sodiumValue = "sodium_value"
        case sugars
        case sugarsPoints = "sugars_points"
        case sugarsValue = "sugars_value"
    }
}

