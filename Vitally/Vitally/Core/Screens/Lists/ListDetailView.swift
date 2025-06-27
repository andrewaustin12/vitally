import SwiftUI
import SwiftData

struct ListDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var foodProductVM: FoodProductViewModel
    var list: UserList
    var imageSize: CGFloat = 65
    
    @State private var showAddToListSheet = false

    var uniqueItems: [UserHistory] {
        var seen = Set<String>()
        var uniqueItems = [UserHistory]()
        
        for item in list.items {
            if !seen.contains(item.id) {
                seen.insert(item.id)
                uniqueItems.append(item)
            }
        }
        
        return uniqueItems
    }

    var averageMatchScore: Double {
        let totalScore = uniqueItems.reduce(0.0) { sum, item in
            sum + Double(calculateMatchScore(for: item))
        }
        return uniqueItems.isEmpty ? 0.0 : totalScore / Double(uniqueItems.count)
    }

    var body: some View {
        VStack {
            List {
                Section{
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("List Score")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Based on \(uniqueItems.count) items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            MatchPercentageView(percentage: Int(averageMatchScore), description: "Match with your food preferences")
                        }
                        
                        // Score breakdown
                        if !uniqueItems.isEmpty {
                            HStack(spacing: 24) {
                                ScoreBreakdownItem(
                                    title: "Nutrition",
                                    score: calculateAverageNutriScore(),
                                    color: scoreColor(for: calculateAverageNutriScore())
                                )
                                ScoreBreakdownItem(
                                    title: "Processing",
                                    score: calculateAverageNovaScore(),
                                    color: scoreColor(for: calculateAverageNovaScore())
                                )
                                ScoreBreakdownItem(
                                    title: "Environment",
                                    score: calculateAverageEcoScore(),
                                    color: scoreColor(for: calculateAverageEcoScore())
                                )
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                if uniqueItems.isEmpty {
                    Section {
                        VStack(spacing: 16) {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("No Items Yet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Add products to this list to get started")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                } else {
                    ForEach(uniqueItems, id: \.id) { item in
                        NavigationLink(destination: ProductDetailsView(product: foodProductVM.createProductFromHistory(item))) {
                            HStack {
                                ImageLoaderView(urlString: item.imageURL)
                                    .frame(width: imageSize, height: imageSize)
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(item.productName)
                                        .font(.headline)
                                    Text(item.productBrand)
                                        .font(.subheadline)
                                    Text("Nutri-Score: \(item.nutritionGrade.capitalized)")
                                        .font(.callout)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        removeItems(at: indexSet)
                    }
                }
            }
            .navigationTitle(list.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddToListSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddToListSheet) {
                AddToListView(list: list, isPresented: $showAddToListSheet)
            }
        }
    }

    private func removeItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = uniqueItems[index]
            // Remove the specific item by its unique id
            list.items.removeAll { $0.id == item.id }
            list.updateLastModified()
        }
    }

    private func calculateMatchScore(for item: UserHistory) -> Int {
        var totalScore = 0
        var weightSum = 0
        
        // Nutritional Quality - 40%
        let nutriScore = calculateNutriScoreGrade(item.nutritionGrade)
        totalScore += nutriScore * 40
        weightSum += 40
        
        // NOVA Group - 30%
        if let novaGroup = item.novaGroup {
            let novaScore = calculateNovaScore(Int(novaGroup))
            totalScore += novaScore * 30
            weightSum += 30
        }
        
        // Eco Score - 20%
        if let ecoscoreGrade = item.ecoscoreGrade {
            let ecoScore = calculateEcoScore(ecoscoreGrade)
            totalScore += ecoScore * 20
            weightSum += 20
        }
        
        // Allergen Safety - 10%
        let allergenScore = calculateAllergenScore(for: item)
        totalScore += allergenScore * 10
        weightSum += 10
        
        return weightSum > 0 ? totalScore / weightSum : 0
    }
    
    private func calculateAllergenScore(for item: UserHistory) -> Int {
        // This would be enhanced based on user's allergen preferences
        // For now, return a neutral score
        return 50
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

    private func calculateAverageNutriScore() -> Double {
        let totalScore = uniqueItems.reduce(0.0) { sum, item in
            sum + Double(calculateNutriScoreGrade(item.nutritionGrade))
        }
        return uniqueItems.isEmpty ? 0.0 : totalScore / Double(uniqueItems.count)
    }

    private func calculateAverageNovaScore() -> Double {
        let itemsWithNova = uniqueItems.filter { $0.novaGroup != nil }
        if itemsWithNova.isEmpty { return 0.0 }
        
        let totalScore = itemsWithNova.reduce(0.0) { sum, item in
            sum + Double(calculateNovaScore(Int(item.novaGroup!)))
        }
        return totalScore / Double(itemsWithNova.count)
    }

    private func calculateAverageEcoScore() -> Double {
        let itemsWithEco = uniqueItems.filter { $0.ecoscoreGrade != nil }
        if itemsWithEco.isEmpty { return 0.0 }
        
        let totalScore = itemsWithEco.reduce(0.0) { sum, item in
            sum + Double(calculateEcoScore(item.ecoscoreGrade!))
        }
        return totalScore / Double(itemsWithEco.count)
    }

    private func scoreColor(for score: Double) -> Color {
        if score >= 80 {
            return .green
        } else if score >= 60 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Supporting Views

struct ScoreBreakdownItem: View {
    let title: String
    let score: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            ZStack {
                // Background circle
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 4)
                    .frame(width: 44, height: 44)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: score / 100)
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.8), value: score)
                
                // Score text
                Text("\(Int(score))")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
        }
    }
}

struct AddToListView: View {
    let list: UserList
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView()
                    .environmentObject(searchViewModel)
            }
            .navigationTitle("Add to \(list.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListDetailView(list: createSampleList())
                .environmentObject(FoodProductViewModel())
        }
    }
    
    static func createSampleList() -> UserList {
        let list = UserList(name: "Healthy Groceries")
        
        // Sample items with different scores
        let sampleItems = [
            createSampleHistoryItem(
                name: "Organic Bananas",
                brand: "Fresh Market",
                nutritionGrade: "A",
                novaGroup: 1,
                ecoscoreGrade: "A"
            ),
            createSampleHistoryItem(
                name: "Greek Yogurt",
                brand: "Chobani",
                nutritionGrade: "B",
                novaGroup: 2,
                ecoscoreGrade: "B"
            ),
            createSampleHistoryItem(
                name: "Whole Grain Bread",
                brand: "Nature's Own",
                nutritionGrade: "B",
                novaGroup: 3,
                ecoscoreGrade: "C"
            ),
            createSampleHistoryItem(
                name: "Dark Chocolate",
                brand: "Lindt",
                nutritionGrade: "C",
                novaGroup: 4,
                ecoscoreGrade: "D"
            )
        ]
        
        list.items = sampleItems
        return list
    }
    
    static func createSampleHistoryItem(name: String, brand: String, nutritionGrade: String, novaGroup: Int, ecoscoreGrade: String) -> UserHistory {
        let history = UserHistory(product: Product.mockProduct)
        history.id = UUID().uuidString // Ensure unique ID
        history.productName = name
        history.productBrand = brand
        history.nutritionGrade = nutritionGrade
        history.novaGroup = Double(novaGroup)
        history.ecoscoreGrade = ecoscoreGrade
        return history
    }
}
