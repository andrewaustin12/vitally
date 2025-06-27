import SwiftUI
// import NutriScoreSheetView, NovaScoreSheetView, EcoScoreSheetView

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
    @State private var infoAlert: InfoAlertType?
    
    private let positiveIngredients: [String] = ["fiber", "proteins", "vitamins", "mineral", "omega-3", "antioxidant"]
    private let negativeIngredients: [String] = ["sugars", "salt", "saturated fat", "trans fat", "artificial", "preservative", "coloring"]
    
    enum NutrientType {
        case energy, proteins, carbohydrates, fats, saturatedFat, sugars, salt, sodium, fiber, fruitsVegetablesNuts
    }
    
    enum InfoAlertType: Identifiable {
        case nutri, nova, eco
        var id: Self { self }
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
                
                Section {
                    DisclosureGroup("Macros & Calories", isExpanded: .constant(true)) {
                        macrosSection
                    }
                }
                
                if let allergens = product.allergens, !allergens.isEmpty {
                    Section {
                        DisclosureGroup("Allergens", isExpanded: .constant(true)) {
                            allergenSection(allergens: allergens)
                        }
                    }
                }
                
                if let additives = product.additives, !additives.isEmpty {
                    Section {
                        DisclosureGroup("Additives", isExpanded: .constant(true)) {
                            additivesSection(additives: additives.joined(separator: ", "))
                        }
                    }
                }
                
                Section {
                    DisclosureGroup("Positive Nutrients", isExpanded: $isPositivesExpanded) {
                        positiveNutrientsView
                    }
                }
                
                Section {
                    DisclosureGroup("Negative Nutrients", isExpanded: $isNegativesExpanded) {
                        negativeNutrientsView
                    }
                }
                
                Section {
                    DisclosureGroup("Ingredients", isExpanded: $isIngredientsExpanded) {
                        ingredientsSection
                    }
                }
                
                if let labels = product.labels, !labels.isEmpty {
                    Section {
                        DisclosureGroup("Dietary Labels", isExpanded: .constant(true)) {
                            dietaryLabelsSection(labels: labels)
                        }
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
            .alert(item: $infoAlert) { alert in
                switch alert {
                case .nutri:
                    return Alert(
                        title: Text("About Nutri-Score"),
                        message: Text("Nutri-Score is a nutrition label that ranks food from A (best) to E (worst) based on nutritional quality. It helps you make healthier choices at a glance.\n\nWhy it matters: Nutri-Score makes it easy to compare products and choose healthier options quickly."),
                        dismissButton: .default(Text("Close"))
                    )
                case .nova:
                    return Alert(
                        title: Text("About NOVA"),
                        message: Text("NOVA classifies foods by their level of processing, from 1 (unprocessed) to 4 (ultra-processed). Lower is better for health.\n\nWhy it matters: Highly processed foods are often less healthy. NOVA helps you spot and avoid them."),
                        dismissButton: .default(Text("Close"))
                    )
                case .eco:
                    return Alert(
                        title: Text("About Eco-Score"),
                        message: Text("Eco-Score rates the environmental impact of food from A (best) to E (worst). Lower impact is better for the planet.\n\nWhy it matters: Eco-Score helps you make choices that are better for the environment."),
                        dismissButton: .default(Text("Close"))
                    )
                }
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
                    HStack(spacing: 4) {
                        Text("Nutri-Score: \(product.displayNutritionGrades.capitalized)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Image(systemName: "info.circle")
                            .onTapGesture { infoAlert = .nutri }
                    }
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
                    HStack(spacing: 4) {
                        Text("NOVA: \(Int(product.nutriments.novaGroup ?? 0))")
                            .font(.title3)
                            .fontWeight(.bold)
                        Image(systemName: "info.circle")
                            .onTapGesture { infoAlert = .nova }
                    }
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
                    HStack(spacing: 4) {
                        Text("Eco-Score: \(product.ecoscoreGrade?.capitalized ?? "N/A")")
                            .font(.title3)
                            .fontWeight(.bold)
                        Image(systemName: "info.circle")
                            .onTapGesture { infoAlert = .eco }
                    }
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
    
    private var positiveNutrientsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(getPositiveNutrients(for: product), id: \.0) { nutrient in
                PositiveNutrientCard(name: nutrient.0, value: nutrient.1)
            }
        }
    }
    
    private var negativeNutrientsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(getNegativeNutrients(for: product), id: \.0) { nutrient in
                NegativeNutrientCard(name: nutrient.0, value: nutrient.1)
            }
        }
    }
    
    
    private var ingredientsSection: some View {
        if let ingredients = product.ingredients, !ingredients.isEmpty {
            AnyView(
                VStack(alignment: .leading, spacing: 12) {
                    FlowLayout(spacing: 8) {
                        ForEach(formatIngredientsArray(ingredients), id: \.self) { ingredient in
                            IngredientChip(ingredient: ingredient)
                        }
                    }
                }
            )
        } else {
            AnyView(
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                    Text("No ingredients information available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            )
        }
    }
    
    private func allergenSection(allergens: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(formattedAllergensArray(allergens), id: \.self) { allergen in
                        AllergenChip(allergen: allergen)
                    }
                }
            }
        }
    }
    
    private func additivesSection(additives: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(additives.split(separator: ",").map(String.init), id: \.self) { additive in
                        AdditiveChip(additive: additive.trimmingCharacters(in: .whitespaces))
                    }
                }
            }
        }
    }

    private var macrosSection: some View {
        VStack(spacing: 12) {
            // Serving size indicator
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Nutrition per 100g")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                MacroCard(
                    title: "Calories",
                    value: product.nutriments.energyKcal ?? 0,
                    color: .orange,
                    icon: "flame.fill",
                    dailyRecommended: 2000
                )
                
                MacroCard(
                    title: "Protein",
                    value: product.nutriments.proteins ?? 0,
                    color: .blue,
                    icon: "dumbbell.fill",
                    dailyRecommended: 50
                )
                
                MacroCard(
                    title: "Carbs",
                    value: product.nutriments.carbohydrates ?? 0,
                    color: .green,
                    icon: "leaf.fill",
                    dailyRecommended: 130
                )
                
                MacroCard(
                    title: "Fat",
                    value: product.nutriments.fat ?? 0,
                    color: .red,
                    icon: "drop.fill",
                    dailyRecommended: 65
                )
            }
        }
        .padding(.vertical, 8)
    }
    
    private func dietaryLabelsSection(labels: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(formatLabels(labels), id: \.self) { label in
                    DietaryLabelChip(label: label)
                }
            }
        }
    }
    
    func formattedAllergens(_ allergens: String) -> String {
        allergens
            .split(separator: ",")
            .map { $0.replacingOccurrences(of: "en:", with: "").capitalized }
            .joined(separator: ", ")
    }
    
    func formattedAllergensArray(_ allergens: String) -> [String] {
        allergens
            .split(separator: ",")
            .map { $0.replacingOccurrences(of: "en:", with: "").capitalized.trimmingCharacters(in: .whitespaces) }
    }
    
    func formatIngredientsArray(_ ingredients: String) -> [String] {
        // Split by common separators and clean up
        let separators = [",", ".", "(", ")", "and", "&"]
        var ingredientsList = [ingredients]
        
        for separator in separators {
            ingredientsList = ingredientsList.flatMap { ingredient in
                ingredient.split(separator: separator)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            }
        }
        
        // Clean up and limit to first 8 ingredients for display
        return ingredientsList
            .map { $0.replacingOccurrences(of: "en:", with: "").capitalized }
            .filter { $0.count > 2 } // Filter out very short strings
            .prefix(8)
            .map { $0 }
    }
    
    private func calculateMatchScore() {
        var totalScore: Double = 0
        var totalWeight: Double = 0

        let nutriWeight = 0.6
        let novaWeight = 0.3
        let ecoWeight = 0.1

        if let nutriScore = product.nutriscoreData?.grade {
            totalScore += Double(calculateNutriScoreGrade(nutriScore)) * nutriWeight
            totalWeight += nutriWeight
        }
        if let novaGroup = product.nutriments.novaGroup {
            totalScore += Double(calculateNovaScore(Int(novaGroup))) * novaWeight
            totalWeight += novaWeight
        }
        if let ecoScore = product.ecoscoreGrade {
            totalScore += Double(calculateEcoScore(ecoScore)) * ecoWeight
            totalWeight += ecoWeight
        }

        // If some data is missing, normalize by totalWeight
        let normalizedScore = totalWeight > 0 ? totalScore / totalWeight : 0
        let clampedScore = max(0, min(100, Int(round(normalizedScore))))

        DispatchQueue.main.async {
            self.matchScore = clampedScore
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
        
        // Fiber
        if let fiber = product.nutriscoreData?.fiber, fiber > 0 {
            positiveNutrients.append(("fiber", "\(fiber) g"))
        }
        // Proteins
        if let proteins = product.nutriments.proteins, proteins > 0 {
            positiveNutrients.append(("proteins", "\(proteins) g"))
        }
        // Fruits & Vegetables (always show if > 0)
        if let fruitsVegetables = product.nutriments.fruitsVegetablesNutsEstimateFromIngredients100G, fruitsVegetables > 0 {
            positiveNutrients.append(("fruitsvegetables", "\(Int(fruitsVegetables)) g"))
        }
        // Vitamins/minerals with % daily value (example: vitamin-d_100g_percent)
        if let vitamins = product.vitamins {
            for vitamin in vitamins {
                let key = vitamin.lowercased().replacingOccurrences(of: "-", with: "_")
                // Try to find a % daily value in nutriments (e.g., vitamin_d_100g_percent)
                if let percent = product.nutrimentsValuePercent(for: key), percent > 0 {
                    positiveNutrients.append((vitamin.lowercased(), "\(Int(percent))%"))
                }
            }
        }
        // TODO: Add minerals if available in API and have %
        return positiveNutrients
    }
    
    func getNegativeNutrients(for product: Product) -> [(String, String)] {
        var negativeNutrients = [(String, String)]()
        
        if let sugars = product.nutriments.sugars, sugars > 0 {
            negativeNutrients.append(("sugars", "\(sugars) g"))
        }
        if let salt = product.nutriments.salt, salt > 0 {
            negativeNutrients.append(("salt", "\(salt) g"))
        }
        if let sodium = product.nutriments.sodium, sodium > 0 {
            negativeNutrients.append(("sodium", "\(sodium) g"))
        }
        if let saturatedFat = product.nutriments.saturatedFat, saturatedFat > 0 {
            negativeNutrients.append(("saturatedfat", "\(saturatedFat) g"))
        }
        if let energy = product.nutriments.energyKcal, energy > 0 {
            negativeNutrients.append(("energy", "\(Int(energy)) kcal"))
        }
        // TODO: Add trans fat, cholesterol if available and > 0
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
    
    
    
    func formatLabels(_ labels: [String]) -> [String] {
        return labels
            .map { $0.replacingOccurrences(of: "en:", with: "") }
            .map { $0.replacingOccurrences(of: "-", with: " ") }
            .map { $0.capitalized }
            .filter { !$0.isEmpty }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: Product.mockProduct)
    }
}


