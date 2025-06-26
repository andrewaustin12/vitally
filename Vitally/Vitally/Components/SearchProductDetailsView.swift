import SwiftUI

struct SearchProductDetailsView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let imageURL = URL(string: product.imageURL) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(product.displayName)
                .font(.title)
                .fontWeight(.bold)
            
            Text(product.displayBrands)
                .font(.headline)
                .foregroundColor(.gray)
            
            if let ingredients = product.ingredients {
                Text("Ingredients: \(ingredients)")
                    .font(.body)
            }
            
            if let allergens = product.allergens {
                Text("Allergens: \(allergens)")
                    .font(.body)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Product Details")
    }
}

#Preview {
    SearchProductDetailsView(product: Product.mockProduct)
}
