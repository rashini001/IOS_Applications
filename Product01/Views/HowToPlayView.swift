import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                HStack {
                    Text("📖 How to Play")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        GuidelineRow(
                            icon: "hand.tap.fill",
                            title: "Tap to Reveal",
                            description: "Tap on any card to reveal its icon and gradient color."
                        )
                        
                        GuidelineRow(
                            icon: "paintpalette.fill",
                            title: "Match Icon AND Gradient",
                            description: "Find pairs that have the SAME icon AND the SAME gradient color combination. Both must match perfectly!"
                        )
                        
                        GuidelineRow(
                            icon: "xmark.circle.fill",
                            title: "Wrong Match",
                            description: "If the icon or gradient color doesn't match, both cards will flip back."
                        )
                        
                        GuidelineRow(
                            icon: "clock.fill",
                            title: "Beat the Timer",
                            description: "Match all pairs before time runs out to win!"
                        )
                        
                        GuidelineRow(
                            icon: "star.fill",
                            title: "Earn Points",
                            description: "Each correct match earns you 10 points. Try to beat your best score!"
                        )
                        
                        GuidelineRow(
                            icon: "lightbulb.fill",
                            title: "Use Hints",
                            description: "Stuck? Tap the hint button to reveal a matching pair for 2 seconds."
                        )
                        
                        GuidelineRow(
                            icon: "trophy.fill",
                            title: "Difficulty Levels",
                            description: "Choose Easy (3x4), Medium (5x6), or Complex (7x8) to challenge yourself!"
                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
    }
}

struct GuidelineRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.yellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
        )
        .shadow(radius: 5)
    }
}

#Preview {
    HowToPlayView()
}

#Preview("Guideline Row") {
    GuidelineRow(
        icon: "hand.tap.fill",
        title: "Tap to Reveal",
        description: "Tap on any card to reveal its icon and color."
    )
    .padding()
    .background(Color.black)
}
