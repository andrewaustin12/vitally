
import SwiftUI


struct HistoryView: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    var imageSize: CGFloat = 55
    
    var body: some View {
        NavigationStack {
            List(historyViewModel.products) { product in
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
            .navigationTitle("History")
            .onAppear {
                historyViewModel.fetchProducts()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
            .environmentObject(AuthViewModel())
            .environmentObject(HistoryViewModel())
    }
}
