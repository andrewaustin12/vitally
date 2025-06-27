import SwiftUI

struct InvalidBarcodeView: View {
    @Binding var isPresented: Bool
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
                .padding(.top, 20)
            
            // Title
            Text("Invalid Code Detected")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Message
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
            
            // Tips
            VStack(alignment: .leading, spacing: 12) {
                Text("Tips for scanning:")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(.blue)
                    Text("Make sure only one barcode is visible")
                }
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(.blue)
                    Text("Look for the black and white bars on product packaging")
                }
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "3.circle.fill")
                        .foregroundColor(.blue)
                    Text("Avoid QR codes, URLs, or other non-product codes")
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Dismiss button
            Button(action: {
                isPresented = false
                onDismiss()
            }) {
                Text("Try Again")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    InvalidBarcodeView(
        isPresented: .constant(true),
        message: "Invalid barcode or QR code detected. Please scan only product barcodes (8-14 digit numbers)."
    ) {
        print("Dismissed")
    }
} 