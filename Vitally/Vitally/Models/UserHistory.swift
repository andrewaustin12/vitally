import Foundation
import SwiftData

@Model
class UserHistory {
    var id: String
    var barcode: String
    var productName: String
    var productBrand: String
    var imageURL: String
    var timestamp: Date
    var nutritionGrade: String
    
    // Complete product data for full details
    var allergens: String?
    var ingredients: String?
    var ecoscoreGrade: String?
    var ecoscoreScore: Int?
    var novaGroup: Double?
    var additives: [String]?
    var labels: [String]?
    var vitamins: [String]?
    
    // Complete nutriments data (matching Nutriments struct)
    var energyKcal: Double?
    var energyKcal100G: Double?
    var proteins: Double?
    var proteins100G: Double?
    var carbohydrates: Double?
    var carbohydrates100G: Double?
    var fat: Double?
    var fat100G: Double?
    var saturatedFat: Double?
    var saturatedFat100G: Double?
    var sugars: Double?
    var sugars100G: Double?
    var salt: Double?
    var salt100G: Double?
    var sodium: Double?
    var sodium100G: Double?
    
    // Nutriscore data (matching NutriscoreData struct)
    var nutriscoreGrade: String?
    var nutriscoreScore: Double?
    var nutriscoreEnergy: Double?
    var nutriscoreEnergyPoints: Double?
    var nutriscoreProteins: Double?
    var nutriscoreProteinsPoints: Double?
    var nutriscoreSaturatedFat: Double?
    var nutriscoreSaturatedFatPoints: Double?
    var nutriscoreSugars: Double?
    var nutriscoreSugarsPoints: Double?
    var nutriscoreSodium: Double?
    var nutriscoreSodiumPoints: Double?
    var nutriscoreFiber: Double?
    var nutriscoreFiberPoints: Double?
    var nutriscoreFruitsVegetablesNuts: Double?
    var nutriscoreFruitsVegetablesNutsPoints: Double?
    var nutriscoreNegativePoints: Double?
    var nutriscorePositivePoints: Double?
    
    init(product: Product) {
        self.id = UUID().uuidString
        self.barcode = product.code
        self.productName = product.displayName
        self.productBrand = product.displayBrands
        self.imageURL = product.imageURL
        self.timestamp = Date()
        self.nutritionGrade = product.displayNutritionGrades
        
        // Store complete product data
        self.allergens = product.allergens
        self.ingredients = product.ingredients
        self.ecoscoreGrade = product.ecoscoreGrade
        self.ecoscoreScore = product.ecoscoreScore
        self.novaGroup = product.nutriments.novaGroup
        self.additives = product.additives
        self.labels = product.labels
        self.vitamins = product.vitamins
        
        // Store complete nutriments data
        self.energyKcal = product.nutriments.energyKcal
        self.energyKcal100G = product.nutriments.energyKcal100G
        self.proteins = product.nutriments.proteins
        self.proteins100G = product.nutriments.proteins100G
        self.carbohydrates = product.nutriments.carbohydrates
        self.carbohydrates100G = product.nutriments.carbohydrates100G
        self.fat = product.nutriments.fat
        self.fat100G = product.nutriments.fat100G
        self.saturatedFat = product.nutriments.saturatedFat
        self.saturatedFat100G = product.nutriments.saturatedFat100G
        self.sugars = product.nutriments.sugars
        self.sugars100G = product.nutriments.sugars100G
        self.salt = product.nutriments.salt
        self.salt100G = product.nutriments.salt100G
        self.sodium = product.nutriments.sodium
        self.sodium100G = product.nutriments.sodium100G
        
        // Store nutriscore data
        if let nutriscoreData = product.nutriscoreData {
            self.nutriscoreGrade = nutriscoreData.grade
            self.nutriscoreScore = nutriscoreData.score
            self.nutriscoreEnergy = nutriscoreData.energy
            self.nutriscoreEnergyPoints = nutriscoreData.energyPoints
            self.nutriscoreProteins = nutriscoreData.proteins
            self.nutriscoreProteinsPoints = nutriscoreData.proteinsPoints
            self.nutriscoreSaturatedFat = nutriscoreData.saturatedFat
            self.nutriscoreSaturatedFatPoints = nutriscoreData.saturatedFatPoints
            self.nutriscoreSugars = nutriscoreData.sugars
            self.nutriscoreSugarsPoints = nutriscoreData.sugarsPoints
            self.nutriscoreSodium = nutriscoreData.sodium
            self.nutriscoreSodiumPoints = nutriscoreData.sodiumPoints
            self.nutriscoreFiber = nutriscoreData.fiber
            self.nutriscoreFiberPoints = nutriscoreData.fiberPoints
            self.nutriscoreFruitsVegetablesNuts = nutriscoreData.fruitsVegetablesNutsColzaWalnutOliveOils
            self.nutriscoreFruitsVegetablesNutsPoints = nutriscoreData.fruitsVegetablesNutsColzaWalnutOliveOilsPoints
            self.nutriscoreNegativePoints = nutriscoreData.negativePoints
            self.nutriscorePositivePoints = nutriscoreData.positivePoints
        }
    }
} 