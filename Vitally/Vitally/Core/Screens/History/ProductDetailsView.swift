import SwiftUI

struct ProductDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    var product: Product
    
    var imageSize: CGFloat = 100
    
    @State private var isNutritionalInfoExpanded = true
    @State private var isIngredientsExpanded = false
    @State private var isPositivesExpanded = true
    @State private var isNegativesExpanded = true
    
    enum NutrientType {
        case energy, proteins, carbohydrates, fats, saturatedFat, sugars, salt, sodium, fiber, fruitsVegetablesNuts
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section{
                    detailsHeader
                }
                
                Section {
                    scoreGroupBoxes
                }
                
                Section {
                    Text(formattedAllergens)
                } header: {
                    Text("Allergens")
                }
                
                Section {
                    DisclosureGroup("Positive Nutrients", isExpanded: $isPositivesExpanded) {
                        positiveNutrients
                    }
                }
                
                Section {
                    DisclosureGroup("Negative Nutrients", isExpanded: $isNegativesExpanded) {
                        negativeNutrients
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Product Details")
        }
    }
    
    private var detailsHeader: some View {
        HStack(spacing: 16) {
            ImageLoaderView(urlString: product.imageURL)
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.productName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(product.brands)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Nutri-Score: \(product.nutritionGrades.capitalized)")
                    .font(.subheadline)
                    .padding(.top, 8)
            }
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    private var scoreGroupBoxes: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack {
                HStack(spacing: 8) {
                    VStack(alignment: .leading) {
                        Text("Nutri-Score: \(product.nutritionGrades.capitalized)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Bad Nutritional quality")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Image(nutriScoreImageName(for: product.nutritionGrades))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 55)
                        .cornerRadius(8)
                }
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("NOVA: \(product.nutriments.novaGroup)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(novaGroupDescription(for: product.nutriments.novaGroup))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(novaScoreImageName(for: product.nutriments.novaGroup))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                    .cornerRadius(8)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Eco-Score: \(product.ecoscoreGrade?.capitalized ?? "None Available")")
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
    
    private var positiveNutrients: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            NutrientView(
                name: "Fiber",
                value: "\(product.nutriscoreData.fiber) g", 
                dailyValue: "\(calculateDailyValue(for: Double(product.nutriscoreData.fiber),nutrient: .fiber))%",
                iconName: "laurel.leading"
            )
            NutrientView(
                name: "Proteins", value: "\(product.nutriments.proteins) g",
                dailyValue: "\(calculateDailyValue(for: product.nutriments.proteins, nutrient: .proteins))%",
                iconName: "fish.fill"
            )
            NutrientView(
                    name: "Fruits/Vegetables/Nuts",
                    value: String(format: "%.2f g", Double(product.nutriscoreData.fruitsVegetablesNutsColzaWalnutOliveOils)),
                    dailyValue: String(format: "%.0f%%", calculateDailyValue(for: Double(product.nutriscoreData.fruitsVegetablesNutsColzaWalnutOliveOils), nutrient: .fruitsVegetablesNuts)),
                    iconName: "leaf.fill"
                )
        }
    }
    
    private var negativeNutrients: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            NutrientView(
                name: "Energy", value: "\(product.nutriments.energyKcal) kcal",
                dailyValue: "\(calculateDailyValue(for: Double(product.nutriments.energyKcal), nutrient: .energy))%",
                iconName: "flame.fill"
            )
            NutrientView(
                name: "Sugars", value: "\(product.nutriments.sugars) g",
                dailyValue: "\(calculateDailyValue(for: product.nutriments.sugars, nutrient: .sugars))%",
                iconName: "cube.fill"
            )
            NutrientView(
                name: "Saturated Fat", value: "\(product.nutriments.saturatedFat) g",
                dailyValue: "\(calculateDailyValue(for: product.nutriments.saturatedFat, nutrient: .saturatedFat))%",
                iconName: "drop.triangle.fill"
            )
            NutrientView(
                name: "Salt", value: "\(product.nutriments.salt) g",
                dailyValue: "\(calculateDailyValue(for: product.nutriments.salt, nutrient: .salt))%",
                iconName: "sparkles"
            )
            NutrientView(
                name: "Sodium", value: "\(product.nutriments.sodium) g",
                dailyValue: "\(calculateDailyValue(for: product.nutriments.sodium * 1000, nutrient: .sodium))%",
                iconName: "triangle.fill"
            )
        }
    }
    
    private func calculateDailyValue(for value: Double, nutrient: NutrientType) -> Int {
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
    
    private func nutriScoreImageName(for grade: String) -> String {
        switch grade.lowercased() {
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
    
    private func novaScoreImageName(for group: Int) -> String {
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
    
    private func novaGroupDescription(for group: Int) -> String {
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
    
    private func ecoScoreImageName(for grade: String?) -> String {
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

    private func ecoScoreDescription(for grade: String?) -> String {
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

    
    private var formattedAllergens: String {
        guard let allergens = product.allergens else {
            return "N/A"
        }
        return allergens
            .split(separator: ",")
            .map { $0.replacingOccurrences(of: "en:", with: "").capitalized }
            .joined(separator: ", ")
    }
}

#Preview {
    ProductDetailsView(product: Product.mockProduct)
        .environmentObject(AuthViewModel())
        .environmentObject(HistoryViewModel())
}
