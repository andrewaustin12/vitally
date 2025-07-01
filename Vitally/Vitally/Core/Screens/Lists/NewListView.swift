import SwiftUI
import SwiftData

struct CreateListView: View {
    @Binding var isPresented: Bool
    @State private var newListName: String = ""
    @State private var newListDescription: String = ""
    @State private var selectedCategory: String = "Custom"
    @Environment(\.modelContext) private var modelContext
    var product: Product?
    
    // Predefined categories for better organization
    private let categories = ["Shopping", "Favorites", "Meal Plan", "Avoid", "Custom"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Product preview if available
                if let product = product {
                    productPreviewSection(product: product)
                }
                
                // Form fields
                VStack(spacing: 16) {
                    // List name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("List Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter list name", text: $newListName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Category selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description (Optional)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter description", text: $newListDescription, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Create button
                Button(action: createList) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create List")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(createButtonBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .disabled(newListName.isEmpty)
                .opacity(newListName.isEmpty ? 0.6 : 1.0)
            }
            .padding(.top)
            .navigationTitle("Create New List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func productPreviewSection(product: Product) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ImageLoaderView(urlString: product.imageURL)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Adding to new list:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(product.displayName)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(product.displayBrands)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Divider()
        }
    }
    
    private var createButtonBackground: LinearGradient {
        if newListName.isEmpty {
            return LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(gradient: Gradient(colors: [Color.blue]), startPoint: .leading, endPoint: .trailing)
        }
    }
    
    private func createList() {
        guard !newListName.isEmpty else { return }
        
        let description = newListDescription.isEmpty ? nil : newListDescription
        let category = selectedCategory == "Custom" ? nil : selectedCategory
        
        let list = UserList(name: newListName, listDescription: description, category: category)
        modelContext.insert(list)
        
        // If we have a product, add it to the newly created list
        if let product = product {
            // Create a new ListProduct for the list (completely independent of scan history)
            let listProduct = ListProduct(product: product)
            list.items.append(listProduct)
            list.updateLastModified()
            print("✅ Added item to new list: \(list.name)")
        }
        
        // Reset form
        newListName = ""
        newListDescription = ""
        selectedCategory = "Custom"
        
        isPresented = false
    }
}

struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateListView(isPresented: .constant(true), product: Product.mockProduct)
    }
}
