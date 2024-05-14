import Foundation

import SwiftUI
import FirebaseFirestore

class HistoryViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private var db = Firestore.firestore()

    func addProduct(_ product: Product) {
        DispatchQueue.main.async {
            self.products.insert(product, at: 0)
            if self.products.count > 20 {
                self.products.removeLast()
            }
        }
    }
    
    func addProductByBarcode(_ barcode: String) async {
        let docRef = db.collection("products").document(barcode)
        
        do {
            let document = try await docRef.getDocument()
            if let data = document.data(), document.exists {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let product = try JSONDecoder().decode(Product.self, from: jsonData)
                self.addProduct(product)
            } else {
                print("Product not found in Firestore")
            }
        } catch {
            print("Error fetching document from Firestore: \(error.localizedDescription)")
        }
    }
    
    func fetchLast20Products() -> [Product] {
        return Array(products.prefix(20))
    }
}
