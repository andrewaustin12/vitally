//
//  Search.swift
//  Vitally
//
//  Created by andrew austin on 5/16/24.
//

import Foundation

struct SearchResult: Codable {
    let count: Int
    let page: Int
    let pageSize: Int
    let pageCount: Int
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case count
        case page
        case pageSize = "page_size"
        case pageCount = "page_count"
        case products
    }
}
