import SwiftUI

struct ProductDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    var product: Product
    @State private var matchScore: Int = 0
    var imageSize: CGFloat = 120
    
    @State private var isProductScoresExpanded = true
    @State private var isNutritionalInfoExpanded = true
    @State private var isIngredientsExpanded = false
    @State private var isPositivesExpanded = true
    @State private var isNegativesExpanded = true
    @State private var showAddToListSheet = false
    
    private let positiveIngredients: [String] = ["fiber", "proteins", "vitamins", "mineral", "omega-3", "antioxidant"]
    private let negativeIngredients: [String] = ["sugars", "salt", "saturated fat", "trans fat", "artificial", "preservative", "coloring"]
    
    enum NutrientType {
        case energy, proteins, carbohydrates, fats, saturatedFat, sugars, salt, sodium, fiber, fruitsVegetablesNuts
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    detailsHeader
                }
                
                Section {
                    DisclosureGroup("Product Scores", isExpanded: $isProductScoresExpanded) {
                        scoreGroupBoxes
                    }
                }
                
                if let allergens = product.allergens, !allergens.isEmpty {
                    allergenSection(allergens: allergens)
                }
                
                if let additives = product.additives, !additives.isEmpty {
                                additivesSection(additives: additives.joined(separator: ", "))
                            }
                
                Section {
                    DisclosureGroup("Positive Nutrients", isExpanded: $isPositivesExpanded) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(getPositiveNutrients(for: product), id: \.0) { nutrient in
                                NutrientView(name: nutrient.0, value: nutrient.1, isPositive: true)
                            }
                        }
                    }
                }
                
                Section {
                    DisclosureGroup("Negative Nutrients", isExpanded: $isNegativesExpanded) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(getNegativeNutrients(for: product), id: \.0) { nutrient in
                                NutrientView(name: nutrient.0, value: nutrient.1, isPositive: false)
                            }
                        }
                    }
                }
                
                Section {
                    DisclosureGroup("Ingredients", isExpanded: $isIngredientsExpanded) { 
                        ingredientsSection
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Product Details")
            .onAppear {
                calculateMatchScore()
            }
            .onChange(of: product) { 
                calculateMatchScore()
            }
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
                ListSelectionView(product: product)
            }
        }
    }
    
    private var detailsHeader: some View {
        HStack(spacing: 16) {
            ImageLoaderView(urlString: product.imageURL)
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(product.displayBrands)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                MatchPercentageView(percentage: matchScore, description: "Match with your food preferences")
            }
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    private var scoreGroupBoxes: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                VStack(alignment: .leading) {
                    Text("Nutri-Score: \(product.displayNutritionGrades.capitalized)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(nutriScoreDescription(for: String(product.displayNutritionGrades.capitalized)))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Image(nutriScoreImageName(for: product.displayNutritionGrades))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                    .cornerRadius(8)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("NOVA: \(Int(product.nutriments.novaGroup ?? 0))")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(novaGroupDescription(for: Int(product.nutriments.novaGroup ?? 0)))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(novaScoreImageName(for: Int(product.nutriments.novaGroup ?? 0)))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                    .cornerRadius(8)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Eco-Score: \(product.ecoscoreGrade?.capitalized ?? "N/A")")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(ecoScoreDescription(for: product.ecoscoreGrade))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(ecoScoreImageName(for: product.ecoscoreGrade))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    
    private var ingredientsSection: some View {
        if let ingredients = product.ingredients, !ingredients.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(ingredients)
                    .foregroundColor(.primary)
                    .padding(.leading, 4)
            }
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text("None Reported")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.leading)
            }
        }
    }
    
    private func allergenSection(allergens: String) -> some View {
        Section(header: Text("Allergens").font(.headline)) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text(formattedAllergens(allergens))
                    .foregroundColor(.primary)
                    .padding(.leading, 4)
            }
            .padding(8)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private func additivesSection(additives: String) -> some View {
        Section(header: Text("Additives").font(.headline)) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text(additives)
                    .foregroundColor(.primary)
                    .padding(.leading, 4)
            }
            .padding(8)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    func formattedAllergens(_ allergens: String) -> String {
        allergens
            .split(separator: ",")
            .map { $0.replacingOccurrences(of: "en:", with: "").capitalized }
            .joined(separator: ", ")
    }
    
    private func calculateMatchScore() {
        var totalScore = 0
        
        // Nutritional Quality - 60%
        if let nutriScore = product.nutriscoreData?.grade {
            totalScore += calculateNutriScoreGrade(nutriScore) * 60 / 100
        }
        
        
        // Food Processing (NOVA) - 30%
        if let novaGroup = product.nutriments.novaGroup {
            totalScore += calculateNovaScore(Int(novaGroup)) * 30 / 100
        }
        
        // Environmental Impact (Eco-Score) - 10%
        if let ecoScore = product.ecoscoreGrade {
            totalScore += calculateEcoScore(ecoScore) * 10 / 100
        }
        
        DispatchQueue.main.async {
            self.matchScore = totalScore
        }
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
    
    
    func nutriScoreImageName(for grade: String?) -> String {
        guard let grade = grade?.lowercased(), !grade.isEmpty else {
            return "nutri-score-unknown"
        }
        switch grade {
        case "a":
            return "nutri-score-a"
        case "b":
            return "nutri-score-b"
        case "c":
            return "nutri-score-c"
        case "d":
            return "nutri-score-d"
        case "e":
            return "nutri-score-e"
        default:
            return "nutri-score-unknown"
        }
    }
    
    func nutriScoreDescription(for grade: String?) -> String {
        guard let grade = grade?.lowercased(), !grade.isEmpty else {
            return "nutri-score-unknown"
        }
        switch grade {
        case "a":
            return "Very good nutritional quality"
        case "b":
            return "Good nutritional quality"
        case "c":
            return "Average nutritional quality"
        case "d":
            return "Poor nutritional quality"
        case "e":
            return "Bad nutritional quality"
        default:
            return "Nutri Score unknown"
        }
    }

    
    func novaScoreImageName(for group: Int?) -> String {
        guard let group = group else {
            return "nova-group-unknown"
        }
        switch group {
        case 1:
            return "nova-group-1"
        case 2:
            return "nova-group-2"
        case 3:
            return "nova-group-3"
        case 4:
            return "nova-group-4"
        default:
            return "nova-group-unknown"
        }
    }
    
    
    func novaGroupDescription(for group: Int) -> String {
        switch group {
        case 1:
            return "Unprocessed or minimally processed foods"
        case 2:
            return "Processed culinary ingredients"
        case 3:
            return "Processed foods"
        case 4:
            return "Ultra-processed food and drink products"
        default:
            return "Unknown NOVA group"
        }
    }
    
    func ecoScoreImageName(for grade: String?) -> String {
        guard let grade = grade?.lowercased() else {
            return "eco-grade-unknown"
        }
        switch grade {
        case "a":
            return "eco-grade-a"
        case "b":
            return "eco-grade-b"
        case "c":
            return "eco-grade-c"
        case "d":
            return "eco-grade-d"
        case "e":
            return "eco-grade-e"
        default:
            return "eco-grade-unknown"
        }
    }
    
    func ecoScoreDescription(for grade: String?) -> String {
        guard let grade = grade?.lowercased() else {
            return "Not Available"
        }
        switch grade {
        case "a":
            return "Very low environmental impact"
        case "b":
            return "Low environmental impact"
        case "c":
            return "Moderate environmental impact"
        case "d":
            return "High environmental impact"
        case "e":
            return "Very high environmental impact"
        default:
            return "None Available"
        }
    }
    
    func getPositiveNutrients(for product: Product) -> [(String, String)] {
            var positiveNutrients = [(String, String)]()
            
            if let fiber = product.nutriscoreData?.fiber {
                positiveNutrients.append(("Fiber", "\(fiber) g"))
            }
            if let proteins = product.nutriments.proteins {
                positiveNutrients.append(("Proteins", "\(proteins) g"))
            }
            if let vitamins = product.vitamins {
                for vitamin in vitamins {
                    positiveNutrients.append(("Vitamins", vitamin))
                }
            }
            
            return positiveNutrients
        }
        
        func getNegativeNutrients(for product: Product) -> [(String, String)] {
            var negativeNutrients = [(String, String)]()
            
            if let sugars = product.nutriments.sugars {
                negativeNutrients.append(("Sugars", "\(sugars) g"))
            }
            if let salt = product.nutriments.salt {
                negativeNutrients.append(("Salt", "\(salt) g"))
            }
            if let saturatedFat = product.nutriments.saturatedFat {
                negativeNutrients.append(("Saturated Fat", "\(saturatedFat) g"))
            }
            if let energy = product.nutriments.energyKcal {
                negativeNutrients.append(("Energy", "\(energy) kcal"))
            }
            
            return negativeNutrients
        }
    
    func calculateDailyValue(for value: Double, nutrient: NutrientType) -> Int {
        let dailyValues: [NutrientType: Double] = [
            .energy: 2000,
            .proteins: 50,
            .carbohydrates: 300,
            .fats: 70,
            .saturatedFat: 20,
            .sugars: 50,
            .salt: 6,
            .sodium: 2.4,
            .fiber: 25,
            .fruitsVegetablesNuts: 400
        ]
        return Int((value / dailyValues[nutrient]!) * 100)
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: Product.mockProduct)
    }
}
