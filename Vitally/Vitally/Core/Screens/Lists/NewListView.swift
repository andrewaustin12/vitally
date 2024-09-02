import SwiftUI

struct NewListView: View {
    @Binding var isPresented: Bool
    @State private var newListName: String = ""
    @EnvironmentObject var listVM: ListViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create a New List")
                    .font(.headline)
                    .padding(.top, 40)
                
                TextField("Enter list name", text: $newListName)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                
                Button(action: {
                    if !newListName.isEmpty {
                        listVM.createList(name: newListName)
                        newListName = ""
                        isPresented = false
                    }
                }) {
                    Text("Create List")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewListView(isPresented: .constant(true))
            .environmentObject(ListViewModel())
    }
}
