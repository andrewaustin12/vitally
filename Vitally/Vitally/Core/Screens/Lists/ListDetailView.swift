import SwiftUI

struct ListDetailView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    var list: FoodList
    var imageSize: CGFloat = 55

    var body: some View {
        List {
            ForEach(list.items) { product in
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
            .onDelete { indexSet in
                removeItems(at: indexSet)
            }
        }
        .listStyle(.plain)
        .navigationTitle(list.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action to add item
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func removeItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = list.items[index]
            listViewModel.removeItem(from: list.id, product: product)
        }
    }
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListDetailView(list: FoodList(id: "1", name: "Sample List", items: [Product.mockProduct]))
                .environmentObject(ListViewModel())
        }
    }
}
