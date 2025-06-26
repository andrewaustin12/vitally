import SwiftUI
import SwiftData

struct ListSelectionView: View {
    @Query(sort: \UserList.lastModified, order: .reverse) private var lists: [UserList]
    @Environment(\.modelContext) private var modelContext
    var product: Product
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                ForEach(lists) { list in
                    Button(action: {
                        addItemToList(list: list, product: product)
                        alertMessage = "\(product.displayName) added to \(list.name)"
                        showAlert = true
                    }) {
                        HStack {
                            Text(list.name)
                            Spacer()
                        }
                    }
                }
                if lists.isEmpty {
                    Text("Please create a list")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Select a List")
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
    
    private func addItemToList(list: UserList, product: Product) {
        let historyItem = UserHistory(product: product)
        list.items.append(historyItem)
        list.updateLastModified()
    }
}

#Preview {
    ListSelectionView(product: Product.mockProduct)
}
