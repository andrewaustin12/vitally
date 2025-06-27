import SwiftUI

struct MainTab: View {
    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            
            /// HISTORY VIEW
            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("History")
            }
            .tag(0)

            /// SEARCH VIEW
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .tag(1)
            
            /// SCANNER VIEW
            NavigationStack {
                ScannerView()
            }
            .tabItem {
                Image(systemName: "barcode.viewfinder")
                Text("Scan")
            }
            .tag(2)

            /// LISTS VIEW
            NavigationStack {
                ListsView()
            }
            .tabItem {
                Image(systemName: "list.bullet.rectangle.portrait")
                Text("Lists")
            }
            .tag(3)

            /// SETTINGS VIEW
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(4)
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
