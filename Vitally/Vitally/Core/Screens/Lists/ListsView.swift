import SwiftUI

struct ListsView: View {
    @State private var isShowingModal = false
    @State private var isShowingDeleteAlert = false
    @State private var listToDelete: FoodList? = nil
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(listViewModel.lists) { list in
                        NavigationLink(destination: ListDetailView(list: list)) {
                            Text(list.name)
                        }
                    }
                    .onDelete(perform: confirmDeleteList)
                }
                .listStyle(.plain)
                .navigationTitle("Lists")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isShowingModal = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isShowingModal) {
                    NewListView(isPresented: $isShowingModal)
                        .presentationDetents([.medium])
                        .presentationCornerRadius(30)
                        .environmentObject(listViewModel) // Pass the environment object
                }
                .alert(isPresented: $isShowingDeleteAlert) {
                    Alert(
                        title: Text("Delete List"),
                        message: Text("Are you sure you want to delete this list?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let listToDelete = listToDelete {
                                withAnimation {
                                    listViewModel.deleteList(listToDelete)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .onAppear {
                    listViewModel.fetchLists()
                }
            }
        }
    }
    
    private func confirmDeleteList(at offsets: IndexSet) {
        if let index = offsets.first {
            listToDelete = listViewModel.lists[index]
            isShowingDeleteAlert = true
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .environmentObject(ListViewModel())
    }
}
