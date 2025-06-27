import SwiftUI

struct EcoScoreSheetView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 20) {
            Image("eco-grade-a") // Or a generic Eco-Score image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 70)
                .cornerRadius(12)
                .padding(.top, 20)
            HStack(spacing: 10) {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.green)
                Text("About Eco-Score")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 4)
            Text("Eco-Score rates the environmental impact of food from A (best) to E (worst). Lower impact is better for the planet.")
                .font(.body)
                .multilineTextAlignment(.center)
            Text("Why it matters: Eco-Score helps you make choices that are better for the environment.")
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
private func ecoScoreImageName(for grade: String?) -> String {
    guard let grade = grade?.lowercased() else {
        return "eco-grade-unknown"
    }
    switch grade {
    case "a": return "eco-grade-a"
    case "b": return "eco-grade-b"
    case "c": return "eco-grade-c"
    case "d": return "eco-grade-d"
    case "e": return "eco-grade-e"
    default: return "eco-grade-unknown"
    }
} 