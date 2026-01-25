import SwiftUI
import Combine

// Score Entry Model
struct ScoreEntry: Codable, Identifiable {
    let id: UUID
    let score: Int
    let level: String
    let date: Date
    
    init(score: Int, level: String) {
        self.id = UUID()
        self.score = score
        self.level = level
        self.date = Date()
    }
}

class GameViewModel: ObservableObject {

    @Published var cells: [GameCell] = []
    @Published var showResult = false
    @Published var isWin = false
    @Published var timeRemaining = 0
    @Published var score = 0
    @Published var bestScore = UserDefaults.standard.integer(forKey: "BestScore")

    private let originalGridSize: Int
    let gridSize: Int
    let level: String
    private var timer: Timer?

    private var selectedIndices: [Int] = []
    private var matchedPairs = 0

    private let icons = [
        "heart.fill", "star.fill", "moon.fill",
        "bolt.fill", "flame.fill", "leaf.fill",
        "cloud.fill", "sun.max.fill"
    ]
    
    // Gradient colors for cells with IDs
    private let gradients: [(gradient: LinearGradient, id: Int)] = [
        (LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), 0),
        (LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing), 1),
        (LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing), 2),
        (LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing), 3),
        (LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing), 4),
        (LinearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing), 5),
        (LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), 6),
        (LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing), 7)
    ]

    init(gridSize: Int, level: String) {
        self.originalGridSize = gridSize
        self.gridSize = gridSize % 2 == 0 ? gridSize : gridSize + 1
        self.level = level
        self.timeRemaining = self.gridSize * 12
        startGame()
    }

    func startGame() {
        let totalCells = gridSize * gridSize
        let pairCount = totalCells / 2

        // Create pairs with icon, gradient, and gradientId
        var pairs: [(icon: String, gradient: LinearGradient, gradientId: Int)] = []
        
        for i in 0..<pairCount {
            let icon = icons[i % icons.count]
            let gradientData = gradients[i % gradients.count]
            // Add the same icon-gradient combination twice (to create a pair)
            pairs.append((icon: icon, gradient: gradientData.gradient, gradientId: gradientData.id))
            pairs.append((icon: icon, gradient: gradientData.gradient, gradientId: gradientData.id))
        }

        pairs.shuffle()
        cells = pairs.map { GameCell(icon: $0.icon, gradient: $0.gradient, gradientId: $0.gradientId) }

        matchedPairs = 0
        score = 0
        selectedIndices.removeAll()
        startTimer()
    }

    func tapCell(at index: Int) {
        guard index < cells.count else { return }
        guard !cells[index].isRevealed else { return }
        guard selectedIndices.count < 2 else { return }

        cells[index].isRevealed = true
        selectedIndices.append(index)

        if selectedIndices.count == 2 {
            checkMatch()
        }
    }

    private func checkMatch() {
        let first = selectedIndices[0]
        let second = selectedIndices[1]

        // Check if both icon AND gradientId match
        if cells[first].icon == cells[second].icon &&
           cells[first].gradientId == cells[second].gradientId {
            cells[first].isMatched = true
            cells[second].isMatched = true
            matchedPairs += 1
            score += 10
            selectedIndices.removeAll()

            if score > bestScore {
                bestScore = score
                UserDefaults.standard.set(bestScore, forKey: "BestScore")
            }

            // MODIFIED: Removed saveScoreToLeaderboard from here
            if matchedPairs == cells.count / 2 {
                isWin = true
                endGame()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.cells[first].isRevealed = false
                self.cells[second].isRevealed = false
                self.selectedIndices.removeAll()
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            // MODIFIED: Removed saveScoreToLeaderboard from here
            if self.timeRemaining <= 0 {
                self.isWin = false
                self.endGame()
            }
        }
    }

    // MODIFIED: Now saves to leaderboard only if player won
    private func endGame() {
        timer?.invalidate()
        showResult = true
        
        // Only save to leaderboard if player won
        if isWin {
            saveScoreToLeaderboard(score)
        }
    }

    func resetGame() {
        timer?.invalidate()
        showResult = false
        isWin = false
        timeRemaining = gridSize * 12
        startGame()
    }

    func showHint() {
        let unmatched = cells.indices.filter { !cells[$0].isMatched && !cells[$0].isRevealed }
        guard unmatched.count >= 2 else { return }

        // Find matching pairs based on both icon AND gradientId
        for i in 0..<(unmatched.count-1) {
            for j in (i+1)..<unmatched.count {
                if cells[unmatched[i]].icon == cells[unmatched[j]].icon &&
                   cells[unmatched[i]].gradientId == cells[unmatched[j]].gradientId {
                    cells[unmatched[i]].isRevealed = true
                    cells[unmatched[j]].isRevealed = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.cells[unmatched[i]].isRevealed = false
                        self.cells[unmatched[j]].isRevealed = false
                    }
                    return
                }
            }
        }
    }

    // MARK: - LEADERBOARD (Only saves winning scores)
    private func saveScoreToLeaderboard(_ newScore: Int) {
        var leaderboard = getLeaderboard()
        let newEntry = ScoreEntry(score: newScore, level: level)
        leaderboard.append(newEntry)
        leaderboard.sort { $0.score > $1.score }
        if leaderboard.count > 10 {
            leaderboard = Array(leaderboard.prefix(10))
        }
        
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: "LeaderboardV2")
        }
    }

    func getLeaderboard() -> [ScoreEntry] {
        guard let data = UserDefaults.standard.data(forKey: "LeaderboardV2"),
              let decoded = try? JSONDecoder().decode([ScoreEntry].self, from: data) else {
            return []
        }
        return decoded
    }
}
