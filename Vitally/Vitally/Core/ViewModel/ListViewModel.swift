import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ListViewModel: ObservableObject {
    @Published var lists: [FoodList] = []
    private var db = Firestore.firestore()
    
    func fetchLists() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).collection("lists")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching lists: \(error)")
                    return
                }
                self.lists = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: FoodList.self)
                } ?? []
            }
    }
    
    func createList(name: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newList = FoodList(id: UUID().uuidString, name: name, items: [])
        do {
            let _ = try db.collection("users").document(userId).collection("lists").document(newList.id).setData(from: newList)
        } catch {
            print("Error creating list: \(error.localizedDescription)")
        }
    }
    
    func addItem(to listId: String, product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let listRef = db.collection("users").document(userId).collection("lists").document(listId)
        
        listRef.getDocument { document, error in
            if let document = document, document.exists {
                var list = try? document.data(as: FoodList.self)
                list?.items.append(product)
                do {
                    try listRef.setData(from: list)
                } catch {
                    print("Error adding item to list: \(error.localizedDescription)")
                }
            } else {
                print("List does not exist")
            }
        }
    }
    
    func removeItem(from listId: String, product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let listRef = db.collection("users").document(userId).collection("lists").document(listId)
        
        listRef.getDocument { document, error in
            if let document = document, document.exists {
                var list = try? document.data(as: FoodList.self)
                list?.items.removeAll { $0.id == product.id }
                do {
                    try listRef.setData(from: list)
                } catch {
                    print("Error removing item from list: \(error.localizedDescription)")
                }
            } else {
                print("List does not exist")
            }
        }
    }
    
    func deleteList(_ list: FoodList) {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            db.collection("users").document(userId).collection("lists").document(list.id).delete { error in
                if let error = error {
                    print("Error deleting list: \(error.localizedDescription)")
                } else {
                    // Optionally, remove the list from the local `lists` array
                    DispatchQueue.main.async {
                        self.lists.removeAll { $0.id == list.id }
                    }
                }
            }
        }
}
