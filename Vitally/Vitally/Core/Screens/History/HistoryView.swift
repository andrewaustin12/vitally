import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    var imageSize: CGFloat = 55

    var body: some View {
        NavigationStack {
            List {
                ForEach(historyViewModel.products) { product in
                    NavigationLink(destination: ProductDetailsView(product: product)) {
                        HStack {
                            ImageLoaderView(urlString: product.imageURL)
                                .frame(width: imageSize, height: imageSize)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(product.productName)
                                    .font(.headline)
                                Text(product.brands)
                                    .font(.subheadline)
                                Text("Nutri-Score: \(product.nutritionGrades.capitalized)")
                                    .font(.callout)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteProduct)
            }
            .listStyle(.plain)
            .navigationTitle("History")
            .onAppear {
                historyViewModel.fetchProducts()
            }
        }
    }

    private func deleteProduct(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = historyViewModel.products[index]
            historyViewModel.deleteProduct(product)
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(AuthViewModel())
        .environmentObject(HistoryViewModel())
}
