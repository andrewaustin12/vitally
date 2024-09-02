import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject var viewModel = FoodProductViewModel()
    @EnvironmentObject var historyViewModel: HistoryViewModel
    @State private var showDetailsSheet = false
    @State private var showNoProductSheet = false
    @State private var isScanning = true
    @State private var isFlashlightOn = false
    
    var body: some View {
        VStack {
            // Title for the Scanner View
            HStack {
                Button(action: toggleFlashlight) {
                    Image(systemName: isFlashlightOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(isFlashlightOn ? .yellow : .blue)
                        .frame(width: 35, height: 35)
                        .padding()
                }
                
                Text("Scan a Product")
                    .font(.largeTitle)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Scanner area
            Scanner(didFindCode: { code in
                Task {
                    await viewModel.fetchFoodProduct(barcode: code)
                    if let product = viewModel.product {
                        historyViewModel.addProductToHistory(product)
                        showDetailsSheet = true
                    } else {
                        showNoProductSheet = true
                    }
                    isScanning = false  // Stop scanning after a barcode is processed
                }
            }, isScanning: $isScanning)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $showDetailsSheet, onDismiss: {
            isScanning = true  // Restart scanning when the sheet is dismissed
            viewModel.resetProduct()  // Reset the product details
        }) {
            if let product = viewModel.product {
                ProductDetailsView(product: product)
                    .presentationDetents([.fraction(0.30), .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
            } else {
                Text("No product details available")
            }
        }
        .sheet(isPresented: $showNoProductSheet) {
            NoProductFoundView(isPresented: $showNoProductSheet) {
                isScanning = true  // Restart scanning after sheet dismissal
                viewModel.resetProduct()  // Reset the product details
            }.presentationDetents([.fraction(0.35)])
        }
    }

    // Function to toggle the flashlight
    private func toggleFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            if device.torchMode == .on {
                device.torchMode = .off
                isFlashlightOn = false
            } else {
                try device.setTorchModeOn(level: 1.0)
                isFlashlightOn = true
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
}

#Preview {
    ScannerView()
        .environmentObject(HistoryViewModel())
        .environmentObject(AuthViewModel())
}
