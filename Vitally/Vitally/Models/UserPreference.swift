import Foundation
import SwiftData

@Model
class UserPreference {
    var id: String
    var category: String
    var isEnabled: Bool
    var createdAt: Date
    
    init(category: String, isEnabled: Bool = true) {
        self.id = UUID().uuidString
        self.category = category
        self.isEnabled = isEnabled
        self.createdAt = Date()
    }
} 