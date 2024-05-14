import SwiftUI
import FirebaseFirestore

class FoodProductViewModel: ObservableObject {
    @Published var product: Product?
    
    private var db = Firestore.firestore()
    
    // Fetch product by barcode, checking cache first, then API
    func fetchFoodProduct(barcode: String) async {
        let docRef = db.collection("products").document(barcode)
        
        do {
            let document = try await docRef.getDocument()
            if let data = document.data(), document.exists {
                parseProductData(data: data)
                print("Getting from Firestore DB")
            } else {
                await getProductFromApi(barcode: barcode)
                print("Sent to API to get product")
            }
        } catch {
            print("Error fetching document from Firestore: \(error.localizedDescription)")
        }
    }
    
    private func parseProductData(data: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let product = try JSONDecoder().decode(Product.self, from: jsonData)
            DispatchQueue.main.async {
                self.product = product
            }
        } catch {
            print("Error decoding product data: \(error.localizedDescription)")
        }
    }
    
    func getProductFromApi(barcode: String) async {
        let fields = [
                    "code",
                    "product_name",
                    "image_url",
                    "nutriscore_data",
                    "nutriments",
                    "nutrition_grades",
                    "brands"
                ].joined(separator: ",")
        
        let endpoint = "https://world.openfoodfacts.org/api/v2/product/\(barcode)?fields=\(fields)"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from the server.")
                return
            }
            
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse.self, from: data)
            DispatchQueue.main.async {
                self.product = apiResponse.product
                // Ensure the product is non-nil before attempting to save
                if let product = self.product {
                    Task {
                        await self.saveProductToCache(barcode: barcode, product: product)
                    }
                }
            }
            
        } catch {
            print("Failed to decode data: \(error)")
        }
    }
    
    private func saveProductToCache(barcode: String, product: Product) async {
        do {
            let data = try JSONEncoder().encode(product)
            let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            try await db.collection("products").document(barcode).setData(dictionary ?? [:])
            print("Saved to Firestore")
        } catch {
            print("Error saving product to cache: \(error.localizedDescription)")
        }
    }
}