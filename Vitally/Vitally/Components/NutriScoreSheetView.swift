import SwiftUI

struct NutriScoreSheetView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 20) {
            Image("nutri-score-a") // Or a generic Nutri-Score image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 70)
                .cornerRadius(12)
                .padding(.top, 20)
            HStack(spacing: 10) {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.green)
                Text("About Nutri-Score")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 4)
            Text("Nutri-Score is a nutrition label that ranks food from A (best) to E (worst) based on nutritional quality. It helps you make healthier choices at a glance.")
                .font(.body)
                .multilineTextAlignment(.center)
            Text("Why it matters: Nutri-Score makes it easy to compare products and choose healthier options quickly.")
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
private func nutriScoreImageName(for grade: String?) -> String {
    guard let grade = grade?.lowercased(), !grade.isEmpty else {
        return "nutri-score-unknown"
    }
    switch grade {
    case "a": return "nutri-score-a"
    case "b": return "nutri-score-b"
    case "c": return "nutri-score-c"
    case "d": return "nutri-score-d"
    case "e": return "nutri-score-e"
    default: return "nutri-score-unknown"
    }
} 