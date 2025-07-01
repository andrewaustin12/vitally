import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \UserHistory.timestamp, order: .reverse) private var history: [UserHistory]
    @Environment(\.modelContext) private var modelContext
    @StateObject private var foodProductVM = FoodProductViewModel()
    var imageSize: CGFloat = 65

    var body: some View {
        NavigationStack {
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
        var totalScore: Double = 0
        var totalWeight: Double = 0

        let nutriWeight = 0.6
        let novaWeight = 0.3
        let ecoWeight = 0.1

        // Nutritional Score (60% weight)
        if !historyItem.nutritionGrade.isEmpty {
            totalScore += Double(calculateNutriScoreGrade(historyItem.nutritionGrade)) * nutriWeight
            totalWeight += nutriWeight
        }
        
        // NOVA Score (30% weight) - if available in history
        if let novaGroup = historyItem.novaGroup, novaGroup > 0 {
            totalScore += Double(calculateNovaScore(Int(novaGroup))) * novaWeight
            totalWeight += novaWeight
        }
        
        // Eco Score (10% weight) - if available in history
        if let ecoScore = historyItem.ecoscoreGrade, !ecoScore.isEmpty {
            totalScore += Double(calculateEcoScore(ecoScore)) * ecoWeight
            totalWeight += ecoWeight
        }

        // If some data is missing, normalize by totalWeight
        let normalizedScore = totalWeight > 0 ? totalScore / totalWeight : 0
        let clampedScore = max(0, min(100, Int(round(normalizedScore))))

        return clampedScore
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
}

#Preview {
    HistoryView()
}
