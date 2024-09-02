import SwiftUI

struct NoProductFoundView: View {
    @Binding var isPresented: Bool
    var onDismiss: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)
                .padding(.bottom,2)
            
            Text("No Product Found")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom,2)
            
            Text("The scanned barcode did not match any products.")
                .font(.body)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal)
                .padding(.bottom)
            
            Button(action: {
                isPresented = false
                onDismiss()
            }) {
                Text("OK")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .cornerRadius(20)
        .shadow(radius: 10)
        .onDisappear {
            if !isPresented {
                onDismiss()
            }
        }
    }
}

struct NoProductFoundView_Previews: PreviewProvider {
    static var previews: some View {
        NoProductFoundView(isPresented: .constant(true)) {
            print("Dismissed")
        }
        .background(Color(.systemBackground))
    }
}
