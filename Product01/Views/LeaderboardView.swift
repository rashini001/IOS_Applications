import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = GameViewModel(gridSize: 3, level: "Easy")
    @State private var scores: [ScoreEntry] = []

    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Leaderboard")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        Text("Winners Only")
                            .font(.caption)
                            .foregroundColor(.yellow.opacity(0.8))
                    }
                }
                .shadow(radius: 5)
                .padding(.top, 20)

                if scores.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "trophy.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("No victories yet!")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.title2)
                        
                        Text("Win a game to get on the board!")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.subheadline)
                        
                        Text("💡 Only winning scores are saved")
                            .foregroundColor(.yellow.opacity(0.8))
                            .font(.caption)
                            .padding(.top, 8)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(scores.enumerated()), id: \.element.id) { index, entry in
                                LeaderboardCard(
                                    rank: index + 1,
                                    entry: entry
                                )
                            }
                        }
                        .padding()
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            scores = viewModel.getLeaderboard()
        }
    }
}

struct LeaderboardCard: View {
    let rank: Int
    let entry: ScoreEntry
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank Badge
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(rankColor, lineWidth: 2)
                    .frame(width: 50, height: 50)
                
                if rank <= 3 {
                    Image(systemName: rankIcon)
                        .font(.title2)
                        .foregroundColor(rankColor)
                } else {
                    Text("#\(rank)")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                }
            }
            
            // Score and Level Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(entry.score) points")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    // Winner badge
                    Image(systemName: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                HStack(spacing: 8) {
                    // Level Badge
                    HStack(spacing: 4) {
                        Image(systemName: levelIcon)
                            .font(.caption2)
                        Text(entry.level)
                            .font(.caption.bold())
                    }
                    .foregroundColor(levelColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(levelColor.opacity(0.2))
                    )
                    .overlay(
                        Capsule()
                            .stroke(levelColor, lineWidth: 1)
                    )
                    
                    // Date
                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Trophy or Medal Icon
            if rank <= 3 {
                Image(systemName: "medal.fill")
                    .font(.title)
                    .foregroundColor(rankColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: rank <= 3 ? [rankColor.opacity(0.5), rankColor.opacity(0.2)] : [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: rank <= 3 ? 2 : 1
                )
        )
        .shadow(color: rank <= 3 ? rankColor.opacity(0.3) : .black.opacity(0.3), radius: rank <= 3 ? 8 : 5)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .white.opacity(0.7)
        }
    }
    
    private var rankIcon: String {
        switch rank {
        case 1: return "crown.fill"
        case 2: return "2.circle.fill"
        case 3: return "3.circle.fill"
        default: return "\(rank).circle.fill"
        }
    }
    
    private var levelColor: Color {
        switch entry.level {
        case "Easy": return .green
        case "Medium": return .orange
        case "Complex": return .red
        default: return .white
        }
    }
    
    private var levelIcon: String {
        switch entry.level {
        case "Easy": return "hare.fill"
        case "Medium": return "figure.walk"
        case "Complex": return "bolt.fill"
        default: return "star.fill"
        }
    }
}

#Preview {
    NavigationStack {
        LeaderboardView()
    }
}
