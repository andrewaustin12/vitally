import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class HistoryViewModel: ObservableObject {
    @Published var products: [Product] = []

    private var db = Firestore.firestore()

    func fetchProducts() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).collection("history")
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

    func deleteProduct(_ product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).collection("history").document(product.id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                self.products.removeAll { $0.id == product.id }
            }
        }
    }

    func addProductToHistory(_ product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            let _ = try db.collection("users").document(userId).collection("history").addDocument(from: product)
            self.products.append(product)
        } catch {
            print("Error saving product to history: \(error.localizedDescription)")
        }
    }
}
