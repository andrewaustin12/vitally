import SwiftUI

struct NewListView: View {
    @Binding var isPresented: Bool
    @State private var listName: String = ""
    @EnvironmentObject var listVM: ListViewModel

    var body: some View {
        NavigationStack {
            Text("add item")
        }
    }
}

struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewListView(isPresented: .constant(true))
            .environmentObject(ListViewModel())
    }
}
