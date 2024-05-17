import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    var imageSize: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .searchable(text: $searchText)
            
            .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchView()
}
