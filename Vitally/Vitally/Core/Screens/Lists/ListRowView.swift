import SwiftUI

struct ListRowView: View {
    let list: UserList
    let product: Product?
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack(spacing: 16) {
                // List icon based on category
                listIcon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(list.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let description = list.listDescription, !description.isEmpty {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        if let category = list.category, !category.isEmpty {
                            Text(category)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(categoryColor(for: category))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Text("\(list.uniqueItemCount) items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Only show plus icon if we have a product (for adding functionality)
                if product != nil {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var listIcon: some View {
        ZStack {
            Circle()
                .fill(iconBackgroundColor)
                .frame(width: 40, height: 40)
            
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
        }
    }
    
    private var iconName: String {
        switch list.category?.lowercased() {
        case "shopping":
            return "cart"
        case "favorites":
            return "heart"
        case "meal plan":
            return "fork.knife"
        case "avoid":
            return "xmark.shield"
        default:
            return "list.bullet"
        }
    }
    
    private var iconBackgroundColor: Color {
        switch list.category?.lowercased() {
        case "shopping":
            return .blue
        case "favorites":
            return .red
        case "meal plan":
            return .green
        case "avoid":
            return .orange
        default:
            return .gray
        }
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category.lowercased() {
        case "shopping":
            return .blue
        case "favorites":
            return .red
        case "meal plan":
            return .green
        case "avoid":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    ListRowView(
        list: UserList(name: "Sample List", listDescription: "A sample list for testing", category: "Shopping"),
        product: Product.mockProduct
    ) {
        // Add action
    }
} 