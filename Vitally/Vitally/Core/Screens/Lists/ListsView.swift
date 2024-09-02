import SwiftUI

struct ListsView: View {
    @State private var newListName: String = ""
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
                    VStack {
                        TextField("New List Name", text: $newListName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: {
                            if !newListName.isEmpty {
                                listViewModel.createList(name: newListName)
                                newListName = ""
                                isShowingModal = false
                            }
                        }) {
                            Text("Create List")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .padding()
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
