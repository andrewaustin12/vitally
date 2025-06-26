import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading && viewModel.products.isEmpty {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.products) { product in
                            productRow(for: product)
                        }
                        if viewModel.isLoading && !viewModel.products.isEmpty {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.0)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Product Search")
            .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
    @ViewBuilder
    private func productRow(for product: SearchResultProduct) -> some View {
        SearchCatagoryRowView(
            imageName: product.imageURL ?? "",
            imageSize: 60,
            productName: product.productName,
            brands: product.brands,
            nutritionGrades: product.nutritionGrades
        )
        .padding(.vertical, 8)
        .onAppear {
            loadMoreIfNeeded(for: product)
        }
    }
    
    private func loadMoreIfNeeded(for product: SearchResultProduct) {
        if product == viewModel.products.last && viewModel.canLoadMore {
            Task {
                await viewModel.performSearch()
            }
        }
    }
}

#Preview {
    SearchView()
}
