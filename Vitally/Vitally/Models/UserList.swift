import Foundation
import SwiftData

@Model
class UserList {
    @Attribute(.unique) var id: String
    var name: String
    var listDescription: String?
    var category: String?
    var createdAt: Date
    var lastModified: Date
    
    // Relationships
    @Relationship(deleteRule: .cascade) var items: [UserHistory] = []
    
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