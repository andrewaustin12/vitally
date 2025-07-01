import SwiftUI
import SwiftData

struct ListSelectionView: View {
    @Query(sort: \UserList.lastModified, order: .reverse) private var lists: [UserList]
    @Environment(\.modelContext) private var modelContext
    var product: Product
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showCreateList = false
    @Environment(\.presentationMode) var presentationMode
    
    // Predefined categories for better organization
    private let categories = ["Shopping", "Favorites", "Meal Plan", "Avoid", "Custom"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Product preview header
                productPreviewHeader
                
                // Lists section
                if lists.isEmpty {
                    emptyStateView
                } else {
                    listsSection
                }
            }
            .navigationTitle("Add to List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateList = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showCreateList) {
                CreateListView(isPresented: $showCreateList, product: product)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Item Added"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    private var productPreviewHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ImageLoaderView(urlString: product.imageURL)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(product.displayBrands)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack {
                        Image(nutriScoreImageName(for: product.displayNutritionGrades))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        
                        if let novaGroup = product.nutriments.novaGroup {
                            Image(novaScoreImageName(for: Int(novaGroup)))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Lists Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create your first list to start organizing products")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showCreateList = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create First List")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
    
    private var listsSection: some View {
        List {
            ForEach(lists) { list in
                ListRowView(list: list, product: product) {
                    addItemToList(list: list, product: product)
                    alertMessage = "\(product.displayName) added to \(list.name)"
                    showAlert = true
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func addItemToList(list: UserList, product: Product) {
        // Create a new ListProduct for the list (completely independent of scan history)
        let listProduct = ListProduct(product: product)
        
        // Check if item with same barcode is already in this list
        let existingInList = list.items.first { $0.productCode == product.code }
        
        if existingInList == nil {
            // Item not in list, add it
            list.items.append(listProduct)
            list.updateLastModified()
            print("✅ Added new item to list: \(list.name)")
        } else {
            print("⚠️ Item already exists in list: \(list.name)")
        }
    }
    
    // Helper functions for score images
    private func nutriScoreImageName(for grade: String) -> String {
        return "nutri-score-\(grade.lowercased())"
    }
    
    private func novaScoreImageName(for group: Int) -> String {
        return "nova-group-\(group)"
    }
}

#Preview {
    ListSelectionView(product: Product.mockProduct)
}
