import SwiftUI

struct NovaScoreSheetView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 20) {
            Image("nova-group-1") // Or a generic NOVA image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 70)
                .cornerRadius(12)
                .padding(.top, 20)
            HStack(spacing: 10) {
                Image(systemName: "cube.box.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.blue)
                Text("About NOVA")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 4)
            Text("NOVA classifies foods by their level of processing, from 1 (unprocessed) to 4 (ultra-processed). Lower is better for health.")
                .font(.body)
                .multilineTextAlignment(.center)
            Text("Why it matters: Highly processed foods are often less healthy. NOVA helps you spot and avoid them.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: { dismiss() }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Capsule().fill(Color.accentColor))
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 16)
        .presentationDetents([.medium, .large])
    }
}

// Helper function (if not globally available)
private func novaScoreImageName(for group: Int?) -> String {
    guard let group = group else {
        return "nova-group-unknown"
    }
    switch group {
    case 1: return "nova-group-1"
    case 2: return "nova-group-2"
    case 3: return "nova-group-3"
    case 4: return "nova-group-4"
    default: return "nova-group-unknown"
    }
} 