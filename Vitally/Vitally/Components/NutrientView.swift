import SwiftUI

struct NutrientView: View {
    var name: String
    var value: String
    var isPositive: Bool

    var body: some View {
        HStack {
            Image(systemName: isPositive ? iconForPositiveNutrient(name) : iconForNegativeNutrient(name))
                .foregroundColor(isPositive ? .green : .red)
            HStack {
                Text(name.capitalized)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(value)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func iconForPositiveNutrient(_ nutrient: String) -> String {
        let nutrientIcons: [String: String] = [
            "fiber": "leaf.fill",
            "proteins": "fish",
            "vitamins": "pills.fill",
            "mineral": "diamond.fill",
            "omega-3": "fish.fill",
            "antioxidant": "sparkles"
        ]
        return nutrientIcons[nutrient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)] ?? "checkmark"
    }

    private func iconForNegativeNutrient(_ nutrient: String) -> String {
        let nutrientIcons: [String: String] = [
            "sugars": "cube.fill",
            "salt": "sparkles",
            "saturated fat": "drop.triangle.fill",
            "trans fat": "exclamationmark.triangle.fill",
            "artificial": "xmark.circle.fill",
            "preservative": "exclamationmark.octagon.fill",
            "coloring": "paintbrush.fill"
        ]
        return nutrientIcons[nutrient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)] ?? "x.circle"
    }
}

#Preview("Positive Nutrient") {
    NutrientView(name: "proteins", value: "5 g", isPositive: true)
}

#Preview("Negative Nutrient") {
    NutrientView(name: "sugar", value: "10 g", isPositive: false)
}
