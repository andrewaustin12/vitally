import SwiftUI

struct ListSelectionView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    var product: Product
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                ForEach(listViewModel.lists) { list in
                    Button(action: {
                        listViewModel.addItem(to: list.id, product: product)
                        alertMessage = "\(product.productName) added to \(list.name)"
                        showAlert = true
                    }) {
                        HStack {
                            Text(list.name)
                            Spacer()
                        }
                    }
                }
                if listViewModel.lists.isEmpty {
                    Text("Please create a list")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Select a List")
            .onAppear {
                listViewModel.fetchLists()
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
}

#Preview {
    ListSelectionView(product: Product.mockProduct)
        .environmentObject(ListViewModel())
}
