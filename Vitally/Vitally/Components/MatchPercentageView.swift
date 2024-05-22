import SwiftUI

struct MatchPercentageView: View {
    var percentage = 86
    var description = "Match with your food preferences"
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorForPercentage(percentage))
                .frame(width: 37, height: 37)
                .overlay(
                    Text("\(percentage)")
                        .font(.headline)
                        .foregroundColor(.white)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            
            
            Text(descriptionForPercentage(percentage))
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.trailing)
            
        }
        .background(colorForPercentage(percentage).opacity(0.2))
        .cornerRadius(10)
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
            return "Poor match"
        case 25..<50:
            return "Fair match"
        case 50..<75:
            return "Good match"
        case 75...100:
            return "Very good match"
        default:
            return "Unknown match"
        }
    }
}

#Preview {
    MatchPercentageView(percentage: 85, description: "Match with your food preferences")
}



//struct MatchPercentageView: View {
//    var percentage: Int
//    var description: String
//    
//    var body: some View {
//        HStack {
//            Circle()
//                .fill(Color.green)
//                .frame(width: 50, height: 50)
//                .overlay(
//                    Text("\(percentage)%")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                )
//            Text(description)
//                .font(.headline)
//                .padding(.leading, 8)
//        }
//        .padding()
//        .background(Color.green.opacity(0.2))
//        .cornerRadius(10)
//    }
//}
//
//#Preview {
//    MatchPercentageView(percentage: 91, description: "Very good match")
//}
