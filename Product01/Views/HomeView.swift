import SwiftUI

struct MenuView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var navigateToGame = false
    @State private var selectedDifficulty = "Easy"

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Color Match Game")
                    .font(.largeTitle)
                    .bold()

                Button("Easy (3x3)") { startGame(difficulty: "Easy") }
                Button("Medium (5x5)") { startGame(difficulty: "Medium") }
                Button("Complex (7x7)") { startGame(difficulty: "Complex") }

                NavigationLink("", destination: GameView(viewModel: viewModel), isActive: $navigateToGame)
            }
        }
    }

    func startGame(difficulty: String) {
        selectedDifficulty = difficulty
        viewModel.startGame(difficulty: difficulty)
        navigateToGame = true
    }
}

