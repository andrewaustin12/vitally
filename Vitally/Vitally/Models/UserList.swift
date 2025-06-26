import Foundation
import SwiftData

@Model
class UserList {
    @Attribute(.unique) var id: String
    var name: String
    var createdAt: Date
    var lastModified: Date
    
    // Relationships
    @Relationship(deleteRule: .cascade) var items: [UserHistory] = []
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.createdAt = Date()
        self.lastModified = Date()
    }
    
    func updateLastModified() {
        self.lastModified = Date()
    }
} 