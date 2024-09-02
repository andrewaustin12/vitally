import Foundation

struct UserPreferences: Codable {
    // Nutritional Quality
    var goodNutritionalQuality: ImportanceLevel = .notImportant
    var lowSalt: ImportanceLevel = .notImportant
    var lowSugar: ImportanceLevel = .notImportant
    var lowFat: ImportanceLevel = .notImportant
    var lowSaturatedFat: ImportanceLevel = .notImportant
    
    // Food Processing
    var noOrLittleProcessing: ImportanceLevel = .notImportant
    var noOrFewAdditives: ImportanceLevel = .notImportant
    
    // Allergens
    var allergens: [String: ImportanceLevel] = [
        "Without Gluten": .notImportant,
        "Without Milk": .notImportant,
        "Without Eggs": .notImportant,
        "Without Nuts": .notImportant,
        "Without Peanuts": .notImportant,
        "Without Sesame seeds": .notImportant,
        "Without Soybeans": .notImportant,
        "Without Celery": .notImportant,
        "Without Mustard": .notImportant,
        "Without Lupin": .notImportant,
        "Without Fish": .notImportant,
        "Without Crustaceans": .notImportant,
        "Without Molluscs": .notImportant,
        "Without Sulphur dioxide and sulphites": .notImportant
    ]
    
    // Ingredients
    var ingredients: [String: ImportanceLevel] = [
        "Vegan": .notImportant,
        "Vegetarian": .notImportant,
        "Palm oil free": .notImportant
    ]
    
    // Labels
    var labels: [String: ImportanceLevel] = [
        "Organic farming": .notImportant,
        "Fair trade": .notImportant
    ]
    
    // Environment
    var lowEnvironmentalImpact: ImportanceLevel = .notImportant
}

enum ImportanceLevel: Int, Codable, CaseIterable, Identifiable {
    case notImportant = 1
    case somewhatImportant = 2
    case important = 3
    case mandatory = 4

    var id: Int { rawValue }

    var description: String {
        switch self {
        case .notImportant:
            return "Not important"
        case .somewhatImportant:
            return "Somewhat important"
        case .important:
            return "Important"
        case .mandatory:
            return "Mandatory"
        }
    }
}
