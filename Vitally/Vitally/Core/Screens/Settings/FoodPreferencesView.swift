import SwiftUI

struct FoodPreferencesView: View {
    @EnvironmentObject var foodPreferenceVM: FoodPreferenceViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Nutritional Quality").font(.headline)) {
                Text("Set your preferences for the nutritional quality of the products.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                PreferencePicker(title: "Good nutritional quality", selection: $foodPreferenceVM.preferences.goodNutritionalQuality)
                PreferencePicker(title: "Salt in low quantity", selection: $foodPreferenceVM.preferences.lowSalt)
                PreferencePicker(title: "Sugars in low quantity", selection: $foodPreferenceVM.preferences.lowSugar)
                PreferencePicker(title: "Fat in low quantity", selection: $foodPreferenceVM.preferences.lowFat)
                PreferencePicker(title: "Saturated fat in low quantity", selection: $foodPreferenceVM.preferences.lowSaturatedFat)
            }
            
            Section(header: Text("Allergens").font(.headline)) {
                Text("Specify your allergen preferences.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ForEach(foodPreferenceVM.preferences.allergens.keys.sorted(), id: \.self) { key in
                    PreferencePicker(title: key, selection: Binding(
                        get: { foodPreferenceVM.preferences.allergens[key] ?? .notImportant },
                        set: { foodPreferenceVM.preferences.allergens[key] = $0 }
                    ))
                }
            }
            
            Section(header: Text("Ingredients").font(.headline)) {
                Text("Set your preferences for specific ingredients.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ForEach(foodPreferenceVM.preferences.ingredients.keys.sorted(), id: \.self) { key in
                    PreferencePicker(title: key, selection: Binding(
                        get: { foodPreferenceVM.preferences.ingredients[key] ?? .notImportant },
                        set: { foodPreferenceVM.preferences.ingredients[key] = $0 }
                    ))
                }
            }
            
            Section(header: Text("Labels").font(.headline)) {
                Text("Set your preferences for product labels.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ForEach(foodPreferenceVM.preferences.labels.keys.sorted(), id: \.self) { key in
                    PreferencePicker(title: key, selection: Binding(
                        get: { foodPreferenceVM.preferences.labels[key] ?? .notImportant },
                        set: { foodPreferenceVM.preferences.labels[key] = $0 }
                    ))
                }
            }
        }
        .navigationTitle("Edit Preferences")
    }
}

struct PreferencePicker: View {
    var title: String
    @Binding var selection: ImportanceLevel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            Picker(title, selection: $selection) {
                ForEach(ImportanceLevel.allCases, id: \.self) { level in
                    Text(level.rawValue).tag(level)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FoodPreferencesView()
        .environmentObject(FoodPreferenceViewModel())
}
