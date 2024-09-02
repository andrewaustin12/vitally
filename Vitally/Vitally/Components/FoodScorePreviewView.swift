import SwiftUI

struct FoodScorePreviewView: View {
    var percentage: Int
    var description: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorForPercentage(percentage))
                .frame(width: 15, height: 15)
                
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            
            Text(descriptionForPercentage(percentage))
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.trailing)
        }
        
    }
    
    private func colorForPercentage(_ percentage: Int) -> Color {
        switch percentage {
        case 0..<25:
            return .red
        case 25..<50:
            return .orange
        case 50..<75:
            return .yellow
        case 75...100:
            return .green
        default:
            return .gray
        }
    }
    
    private func descriptionForPercentage(_ percentage: Int) -> String {
        switch percentage {
        case 0..<25:
            return "Poor"
        case 25..<50:
            return "Fair"
        case 50..<75:
            return "Good"
        case 75...100:
            return "Very good"
        default:
            return "Unknown match"
        }
    }
}

#Preview {
    FoodScorePreviewView(percentage: 5, description: "Match with your food preferences")
}


#Preview {
    FoodScorePreviewView(percentage: 85, description: "Match with your food preferences")
}
