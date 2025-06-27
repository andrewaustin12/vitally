import SwiftUI

struct SearchCatagoryRowView: View {
    let imageName: String
    let imageSize: CGFloat
    let productName: String
    let brands: String
    let nutritionGrades: String
    
    var body: some View {
        HStack {
            ImageLoaderView(urlString: imageName)
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(productName)
                    .font(.headline)
                Text(brands)
                    .font(.subheadline)
                Text("Nutri-Score: \(nutritionGrades.capitalized)")
                    .font(.callout)
            }
        }
    }
}

#Preview {
    let mockProduct = Product.mockProduct
    return SearchCatagoryRowView(
        imageName: mockProduct.imageURL,
        imageSize: 60,
        productName: mockProduct.displayName,
        brands: mockProduct.displayBrands,
        nutritionGrades: mockProduct.displayNutritionGrades
    )
}
