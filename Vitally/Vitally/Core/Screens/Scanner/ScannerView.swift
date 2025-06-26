import SwiftUI
import AVFoundation
import SwiftData

struct InvalidBarcodeView: View {
    @Binding var isPresented: Bool
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                    .padding(.top, 10)
                
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
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tips for scanning:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("Make sure only one barcode is visible")
                            .font(.subheadline)
                    }
                    
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("Look for the black and white bars on product packaging")
                            .font(.subheadline)
                    }
                    
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("Avoid QR codes, URLs, or other non-product codes")
                            .font(.subheadline)
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
                .padding(.bottom, 10)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        isPresented = false
                        onDismiss()
                    }
                }
            }
        }
    }
}

struct ScannerView: View {
    @StateObject var viewModel = FoodProductViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showDetailsSheet = false
    @State private var showNoProductSheet = false
    @State private var showInvalidBarcodeSheet = false
    @State private var isScanning = true
    @State private var isFlashlightOn = false
    @State private var invalidBarcodeMessage = ""
    @State private var lastScannedCode = ""
    @State private var isScannerPaused = false
    
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
            ZStack {
                if isScanning && !isScannerPaused {
                    Scanner(didFindCode: { code in
                        handleScannedCode(code)
                    }, isScanning: $isScanning)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .padding()
                } else {
                    // Placeholder when scanner is disabled
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding()
                }
                
                // Overlay when scanner is paused
                if isScannerPaused {
                    VStack {
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        Text("Scanner Paused")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Tap 'Try Again' to resume")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showDetailsSheet, onDismiss: {
            isScanning = true  // Restart scanning when the sheet is dismissed
            isScannerPaused = false
            lastScannedCode = ""
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
                isScannerPaused = false
                lastScannedCode = ""
                viewModel.resetProduct()  // Reset the product details
            }.presentationDetents([.fraction(0.35)])
        }
        .sheet(isPresented: $showInvalidBarcodeSheet) {
            InvalidBarcodeView(isPresented: $showInvalidBarcodeSheet, message: invalidBarcodeMessage) {
                // Restart scanning with a small delay to prevent rapid re-scanning
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isScanning = true
                    isScannerPaused = false
                    lastScannedCode = ""  // Clear the last scanned code
                    viewModel.resetProduct()
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    private func addToHistory(_ product: Product) {
        print("📝 Starting to add product to history: \(product.displayName)")
        
        // Always create a new history entry for each scan
        let history = UserHistory(product: product)
        print("📦 Created UserHistory object with ID: \(history.id)")
        print("📦 UserHistory barcode: \(history.barcode)")
        print("📦 UserHistory productName: \(history.productName)")
        
        modelContext.insert(history)
        print("💾 Inserted history into modelContext")
        
        // Explicitly save the context
        do {
            try modelContext.save()
            print("✅ Added history entry for: \(product.displayName)")
            print("💾 History saved successfully")
            
            // Verify the save by trying to fetch it
            let fetchDescriptor = FetchDescriptor<UserHistory>()
            let savedItems = try modelContext.fetch(fetchDescriptor)
            print("🔍 Verification: Found \(savedItems.count) total history items in database")
            
        } catch {
            print("❌ Error saving history: \(error.localizedDescription)")
            print("❌ Error details: \(error)")
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

    private func handleScannedCode(_ code: String) {
        print("📱 Scanned barcode: \(code)")
        
        // Check if it's a valid barcode format
        let numericOnly = code.trimmingCharacters(in: .whitespacesAndNewlines)
        let isNumeric = numericOnly.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        let isValidLength = numericOnly.count >= 8 && numericOnly.count <= 14
        
        if !isNumeric || !isValidLength {
            print("❌ Invalid barcode format detected: \(code)")
            // Immediately pause scanner to prevent further scanning
            isScanning = false
            isScannerPaused = true
            lastScannedCode = code
            invalidBarcodeMessage = "Invalid barcode or QR code detected. Please scan only product barcodes (8-14 digit numbers)."
            showInvalidBarcodeSheet = true
            return
        }
        
        // Only process if we're currently scanning
        guard isScanning else { return }
        
        Task {
            await viewModel.fetchFoodProduct(barcode: code)
            if let product = viewModel.product {
                print("✅ Product found: \(product.displayName)")
                addToHistory(product)
                showDetailsSheet = true
            } else {
                print("❌ No product found for barcode: \(code)")
                showNoProductSheet = true
            }
            isScanning = false  // Stop scanning after a barcode is processed
            isScannerPaused = false
        }
    }
}

#Preview {
    ScannerView()
}
