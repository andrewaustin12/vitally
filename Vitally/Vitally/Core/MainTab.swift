//
//  MainTab.swift
//  Vitally
//
//  Created by andrew austin on 5/12/24.
//

import SwiftUI

struct MainTab: View {
    @State private var selectedIndex = 0
    
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            HistoryView()
                .onAppear{
                    selectedIndex = 0
                }
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text("History")
                }.tag(0)
            ScannerView()
                .onAppear{
                    selectedIndex = 1
                }
                .tabItem{
                    Image(systemName: "barcode.viewfinder")
                    Text("Scan")
                }.tag(1)
            TestView()
                .onAppear{
                    selectedIndex = 2
                }
                .tabItem{
                    Image(systemName: "icloud.slash")
                    Text("Test")
                }.tag(2)
            SearchView()
                .onAppear{
                    selectedIndex = 3
                }
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(3)
            SettingsView()
                .onAppear{
                    selectedIndex = 4
                }
                .tabItem{
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(4)
        }
    }
}

#Preview {
    MainTab()
        .environmentObject(AuthViewModel())
        .environmentObject(HistoryViewModel())
}
