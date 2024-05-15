import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

import SwiftUI
import FirebaseFirestore

class HistoryViewModel: ObservableObject {
    @Published var products: [Product] = []

    private var db = Firestore.firestore()

    func fetchProducts() {
        db.collection("products")
            .order(by: "timestamp", descending: true)
            .limit(to: 20)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.products = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Product.self)
                    } ?? []
                }
            }
    }
}
