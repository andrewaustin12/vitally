import SwiftUI
import SwiftData

struct ListsView: View {
    @State private var isShowingModal = false
    @State private var isShowingDeleteAlert = false
    @State private var listToDelete: UserList? = nil
    
    @Query(sort: \UserList.lastModified, order: .reverse) private var lists: [UserList]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                if lists.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(lists) { list in
                            NavigationLink(destination: ListDetailView(list: list)) {
                                ListRowView(list: list, product: nil as Product?) {
                                    // Empty closure since this is just for display, not adding
                                }
                            }
                        }
                        .onDelete(perform: confirmDeleteList)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingModal = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $isShowingModal) {
                CreateListView(isPresented: $isShowingModal, product: nil)
                    .presentationDetents([.medium])
                    .presentationCornerRadius(30)
            }
            .alert(isPresented: $isShowingDeleteAlert) {
                Alert(
                    title: Text("Delete List"),
                    message: Text("Are you sure you want to delete this list?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let listToDelete = listToDelete {
                            withAnimation {
                                modelContext.delete(listToDelete)
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 80))
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
                isShowingModal = true
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
    
    private func confirmDeleteList(at offsets: IndexSet) {
        if let index = offsets.first {
            listToDelete = lists[index]
            isShowingDeleteAlert = true
        }
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
    }
}
