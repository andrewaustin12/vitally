//
//  List.swift
//  Vitally
//
//  Created by andrew austin on 5/22/24.
//

import Foundation

struct FoodList: Identifiable, Codable {
    var id: String
    var name: String
    var items: [Product]
    
    // Function to calculate average Nutri-Score
    var averageNutriScore: String {
        // Placeholder for average Nutri-Score calculation logic
        return "B" // This will be replaced with actual calculation logic
    }
    
}
