//
//  VitallyApp.swift
//  Vitally
//
//  Created by andrew austin on 5/12/24.
//

import SwiftUI
import FirebaseCore


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
    @StateObject var authVM = AuthViewModel()
    @StateObject var historyVM = HistoryViewModel()
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.userSession != nil {
                    MainTab()
                } else if hasCompletedOnboarding {
                    NavigationStack {
                        RegistrationView()
                    }
                } else {
                    NavigationStack {
                        OnboardingTabView()
                    }
                }
            }
            .environmentObject(authVM)
            .environmentObject(historyVM)
        }
    }
    
}
