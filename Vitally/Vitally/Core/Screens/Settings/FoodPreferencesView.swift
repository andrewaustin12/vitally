import SwiftUI
import SwiftData

struct FoodPreferencesView: View {
    @Query private var preferences: [UserPreference]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedCategories: Set<String> = []
    
    private let availableCategories = [
        "Good Nutritional Quality",
        "Low Salt",
        "Low Sugar", 
        "Low Fat",
        "Low Saturated Fat",
        "No Processing",
        "No Additives",
        "Vegan",
        "Vegetarian",
        "Organic",
        "Fair Trade",
        "Low Environmental Impact"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Food Preferences").font(.headline)) {
                Text("Select the food preferences that are important to you.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ForEach(availableCategories, id: \.self) { category in
                    let isEnabled = preferences.first { $0.category == category }?.isEnabled ?? false
                    
                    HStack {
                        Text(category)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { isEnabled },
                            set: { newValue in
                                togglePreference(category: category, isEnabled: newValue)
                            }
                        ))
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                Button("Clear All Preferences") {
                    clearAllPreferences()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Food Preferences")
        .onAppear {
            loadSelectedCategories()
        }
    }
    
    private func togglePreference(category: String, isEnabled: Bool) {
        if let existingPreference = preferences.first(where: { $0.category == category }) {
            if isEnabled {
                existingPreference.isEnabled = true
            } else {
                modelContext.delete(existingPreference)
            }
        } else if isEnabled {
            let newPreference = UserPreference(category: category, isEnabled: true)
            modelContext.insert(newPreference)
        }
    }
    
    private func clearAllPreferences() {
        for preference in preferences {
            modelContext.delete(preference)
        }
    }
    
    private func loadSelectedCategories() {
        selectedCategories = Set(preferences.filter { $0.isEnabled }.map { $0.category })
    }
}

#Preview {
    FoodPreferencesView()
}
