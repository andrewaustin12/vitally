import Foundation

struct FoodPreferences {
    var goodNutritionalQuality: ImportanceLevel = .notImportant
    var lowSalt: ImportanceLevel = .notImportant
    var lowSugar: ImportanceLevel = .notImportant
    var lowFat: ImportanceLevel = .notImportant
    var lowSaturatedFat: ImportanceLevel = .notImportant
    var noProcessing: ImportanceLevel = .notImportant
    var noAdditives: ImportanceLevel = .notImportant
    var allergens: [String: ImportanceLevel] = [
        "Gluten": .notImportant,
        "Milk": .notImportant,
        "Eggs": .notImportant,
        "Nuts": .notImportant,
        "Peanuts": .notImportant,
        "Sesame seeds": .notImportant,
        "Soybeans": .notImportant,
        "Celery": .notImportant,
        "Mustard": .notImportant,
        "Lupin": .notImportant,
        "Fish": .notImportant,
        "Crustaceans": .notImportant,
        "Molluscs": .notImportant,
        "Sulphur dioxide and sulphites": .notImportant
    ]
    var ingredients: [String: ImportanceLevel] = [
        "Vegan": .notImportant,
        "Vegetarian": .notImportant,
        "Palm oil free": .notImportant
    ]
    var labels: [String: ImportanceLevel] = [
        "Organic farming": .notImportant,
        "Fair trade": .notImportant
    ]
}

enum ImportanceLevel: String, CaseIterable, Identifiable {
    case notImportant = "Not important"
    case important = "Important"
    case veryImportant = "Very important"
    case mandatory = "Mandatory"
    
    var id: String { self.rawValue }
}
