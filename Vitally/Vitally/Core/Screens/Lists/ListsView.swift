import SwiftUI

struct ListsView: View {
    @State private var newListName: String = ""
    @State private var isShowingModal = false
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
                .onAppear {
                    listViewModel.fetchLists()
                }
            }
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .environmentObject(ListViewModel())
    }
}
