import SwiftUI

struct ResultPopupView: View {
    let isWin: Bool
    let onRetry: () -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    @EnvironmentObject var viewModel: GameViewModel

    private var leaderboardScores: [ScoreEntry] {
        viewModel.getLeaderboard()
    }

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { }
            
            VStack(spacing: 24) {
                // Animated Result Title
                HStack(spacing: 12) {
                    Image(systemName: isWin ? "sparkles" : "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(isWin ? .green : .red)
                    Text(isWin ? "You Win!" : "Time's Up")
                        .font(.largeTitle.bold())
                        .foregroundColor(isWin ? .green : .red)
                        .shadow(radius: 5)
                }

                // Current Game Score Card
                VStack(spacing: 16) {
                    Text(isWin ? "Victory!" : "Your Score")
                        .font(.headline)
                        .foregroundColor(isWin ? .yellow : .white.opacity(0.8))
                    
                    HStack(spacing: 20) {
                        // Score
                        VStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundColor(.yellow)
                            Text("\(viewModel.score)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            Text("Points")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                        
                        // Level
                        VStack(spacing: 8) {
                            Image(systemName: levelIcon)
                                .font(.title2)
                                .foregroundColor(levelColor)
                            Text(viewModel.level)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Text("Level")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.3))
                        )
                    }
                    
                    // Win/Loss Status
                    if isWin {
                        // Saved to leaderboard indicator
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text("Saved to Leaderboard!")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.2))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.green, lineWidth: 1)
                        )
                        
                        // Best Score
                        if viewModel.score == viewModel.bestScore {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                Text("New Best Score!")
                                    .font(.headline)
                                    .foregroundColor(.yellow)
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(Color.yellow.opacity(0.2))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.yellow, lineWidth: 1)
                            )
                        } else {
                            HStack {
                                Image(systemName: "rosette")
                                    .foregroundColor(.orange)
                                Text("Best: \(viewModel.bestScore)")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        // Loss message
                        HStack {
                            Image(systemName: "xmark.seal.fill")
                                .foregroundColor(.red)
                            Text("Not saved to Leaderboard")
                                .font(.subheadline.bold())
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.2))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.red.opacity(0.5), lineWidth: 1)
                        )
                        
                        Text("Win the game to get on the leaderboard!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.black.opacity(0.5), Color.black.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(radius: 10)

                // Top 5 Leaderboard Preview (only if there are winning scores)
                if !leaderboardScores.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                            Text("Top 5 Winners")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                        }

                        ForEach(Array(leaderboardScores.prefix(5).enumerated()), id: \.element.id) { index, entry in
                            HStack {
                                // Rank
                                Text("#\(index + 1)")
                                    .font(.caption.bold())
                                    .foregroundColor(index < 3 ? .yellow : .white.opacity(0.7))
                                    .frame(width: 30, alignment: .leading)
                                
                                // Winner checkmark
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                
                                // Score
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundColor(.yellow)
                                    Text("\(entry.score)")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.white)
                                }
                                .frame(width: 60, alignment: .leading)
                                
                                // Level Badge
                                HStack(spacing: 4) {
                                    Image(systemName: getLevelIcon(entry.level))
                                        .font(.caption2)
                                    Text(entry.level)
                                        .font(.caption2.bold())
                                }
                                .foregroundColor(getLevelColor(entry.level))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(getLevelColor(entry.level).opacity(0.2))
                                )
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.3))
                    )
                }

                // Play Again Button
                Button {
                    onRetry()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                        Text(isWin ? "Play Again" : "Try Again")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: isWin ? [.green, .green.opacity(0.7)] : [.orange, .orange.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: isWin ? .green.opacity(0.5) : .orange.opacity(0.5), radius: 10)
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.95), .blue.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.5), radius: 20)
            .scaleEffect(scale)
            .opacity(opacity)
            .padding(.horizontal, 30)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1
                opacity = 1
            }
        }
    }
    
    private var levelColor: Color {
        switch viewModel.level {
        case "Easy": return .green
        case "Medium": return .orange
        case "Complex": return .red
        default: return .white
        }
    }
    
    private var levelIcon: String {
        switch viewModel.level {
        case "Easy": return "hare.fill"
        case "Medium": return "figure.walk"
        case "Complex": return "bolt.fill"
        default: return "star.fill"
        }
    }
    
    private func getLevelColor(_ level: String) -> Color {
        switch level {
        case "Easy": return .green
        case "Medium": return .orange
        case "Complex": return .red
        default: return .white
        }
    }
    
    private func getLevelIcon(_ level: String) -> String {
        switch level {
        case "Easy": return "hare.fill"
        case "Medium": return "figure.walk"
        case "Complex": return "bolt.fill"
        default: return "star.fill"
        }
    }
}
