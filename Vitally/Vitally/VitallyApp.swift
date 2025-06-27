import SwiftUI
import FirebaseCore
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct VitallyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var foodProductVM = FoodProductViewModel()

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTab()
                } else {
                    NavigationStack {
                        OnboardingTabView()
                    }
                }
            }
            .environmentObject(foodProductVM)
        }
        .modelContainer(for: [UserHistory.self, UserList.self, UserPreference.self], isAutosaveEnabled: true)
    }
}
