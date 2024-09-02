import Foundation

class FoodPreferenceViewModel: ObservableObject {
    @Published var preferences = UserPreferences() {
        didSet {
            savePreferences()
            preferencesDidChange()
        }
    }
    
    private let preferencesKey = "userPreferences"
    var onPreferencesChange: (() -> Void)?
    
    init() {
        loadPreferences()
    }
    
    private func preferencesDidChange() {
        onPreferencesChange?()
    }
    
    func savePreferences() {
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: preferencesKey)
        }
    }
    
    func loadPreferences() {
        if let savedPreferences = UserDefaults.standard.object(forKey: preferencesKey) as? Data {
            if let decodedPreferences = try? JSONDecoder().decode(UserPreferences.self, from: savedPreferences) {
                self.preferences = decodedPreferences
            }
        }
    }

    
}
