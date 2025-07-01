import Foundation
import SwiftData

// Simple wrapper for products in lists with unique ID
@Model
class ListProduct {
    @Attribute(.unique) var id: String
    var productCode: String
    var productName: String
    var productBrand: String
    var imageURL: String
    var nutritionGrade: String
    var timestamp: Date
    
    // Store complete product data
    var allergens: String?
    var ingredients: String?
    var ecoscoreGrade: String?
    var ecoscoreScore: Int?
    var novaGroup: Double?
    var additives: [String]?
    var labels: [String]?
    var vitamins: [String]?
    
    // Complete nutriments data
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
    
    init(product: Product) {
        self.id = UUID().uuidString
        self.productCode = product.code
        self.productName = product.displayName
        self.productBrand = product.displayBrands
        self.imageURL = product.imageURL
        self.nutritionGrade = product.displayNutritionGrades
        self.timestamp = Date()
        
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
    }
}

@Model
class UserList {
    @Attribute(.unique) var id: String
    var name: String
    var listDescription: String?
    var category: String?
    var createdAt: Date
    var lastModified: Date
    
    // Store ListProduct objects (independent of UserHistory)
    @Relationship(deleteRule: .cascade) var items: [ListProduct] = []
    
    init(name: String, listDescription: String? = nil, category: String? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.listDescription = listDescription
        self.category = category
        self.createdAt = Date()
        self.lastModified = Date()
    }
    
    func updateLastModified() {
        self.lastModified = Date()
    }
    
    var itemCount: Int {
        return items.count
    }
    
    var uniqueItemCount: Int {
        let uniqueIds = Set(items.map { $0.id })
        return uniqueIds.count
    }
} 