import Foundation

struct SearchAPIResponse: Codable {
    let products: [SearchResultProduct]
}

struct SearchResultProduct: Codable, Identifiable, Equatable {
    let id: String
    let productName: String
    let brands: String
    let imageURL: String?
    let nutritionGrades: String

    enum CodingKeys: String, CodingKey {
        case id = "code"
        case productName = "product_name"
        case brands = "brands"
        case imageURL = "image_url"
        case nutritionGrades = "nutrition_grades"
    }
    
}
