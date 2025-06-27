import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \UserHistory.timestamp, order: .reverse) private var history: [UserHistory]
    @Environment(\.modelContext) private var modelContext
    @StateObject private var foodProductVM = FoodProductViewModel()
    var imageSize: CGFloat = 65

    var body: some View {
        NavigationStack {
            VStack {
                // Debug info
                Text("Debug: Found \(history.count) history items")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                
                // Test button
                Button("Add Test History Item") {
                    addTestHistoryItem()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                List {
                    ForEach(history, id: \.id) { historyItem in
                        NavigationLink(destination: ProductDetailsView(product: createProductFromHistory(historyItem))) {
                            HStack {
                                ImageLoaderView(urlString: historyItem.imageURL)
                                    .frame(width: imageSize, height: imageSize)
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(historyItem.productName)
                                        .font(.headline)
                                    Text(historyItem.productBrand)
                                        .font(.subheadline)
                                    FoodScorePreviewView(percentage: calculateMatchScore(for: historyItem), description: "Match with your food preferences")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteHistoryItem)
                }
                .listStyle(.plain)
                .navigationTitle("History")
            }
        }
        .onAppear {
            print("🔍 HistoryView appeared with \(history.count) items")
            for (index, item) in history.enumerated() {
                print("📦 History item \(index): \(item.productName) - \(item.barcode) - \(item.timestamp)")
            }
        }
    }

    private func deleteHistoryItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = history[index]
            modelContext.delete(item)
        }
    }
    
    private func createProductFromHistory(_ historyItem: UserHistory) -> Product {
        // Use the FoodProductViewModel to create a complete product from history data
        return foodProductVM.createProductFromHistory(historyItem)
    }

    private func calculateMatchScore(for historyItem: UserHistory) -> Int {
        var totalScore = 0
        
        // Nutritional Quality - 60%
        totalScore += calculateNutriScoreGrade(historyItem.nutritionGrade) * 60 / 100
        
        // For now, we'll use a default score since we don't have full product data
        // In a real implementation, you might want to store more data in UserHistory
        totalScore += 50 * 40 / 100 // Default score for other factors
        
        return totalScore
    }

    private func calculateNutriScoreGrade(_ grade: String) -> Int {
        switch grade.lowercased() {
        case "a":
            return 100
        case "b":
            return 80
        case "c":
            return 60
        case "d":
            return 40
        case "e":
            return 20
        default:
            return 0
        }
    }
    
    private func calculateNovaScore(_ group: Int) -> Int {
        switch group {
        case 1:
            return 100
        case 2:
            return 75
        case 3:
            return 50
        case 4:
            return 25
        default:
            return 0
        }
    }
    
    private func calculateEcoScore(_ grade: String) -> Int {
        switch grade.lowercased() {
        case "a":
            return 100
        case "b":
            return 80
        case "c":
            return 60
        case "d":
            return 40
        case "e":
            return 20
        default:
            return 0
        }
    }

    private func addTestHistoryItem() {
        print("🧪 Adding test history item...")
        let testProduct = Product.mockProduct
        let testHistory = UserHistory(product: testProduct)
        
        modelContext.insert(testHistory)
        
        do {
            try modelContext.save()
            print("✅ Test history item saved successfully")
        } catch {
            print("❌ Error saving test history: \(error)")
        }
    }
}

#Preview {
    HistoryView()
}
