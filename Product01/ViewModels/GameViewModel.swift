import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            Text("Match the Colors!")
                .font(.headline)
                .padding()

            Text("Target Pattern:")
            VStack(spacing: 2) {
                ForEach(0..<viewModel.size, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<viewModel.size, id: \.self) { col in
                            Rectangle()
                                .foregroundColor(viewModel.targetGrid[row][col].color)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            .padding(.bottom)

            Text("Your Grid:")
            VStack(spacing: 2) {
                ForEach(0..<viewModel.size, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<viewModel.size, id: \.self) { col in
                            let tile = viewModel.grid[row][col]
                            Rectangle()
                                .foregroundColor(tile.currentColor)
                                .frame(width: 40, height: 40)
                                .border(viewModel.selectedTile?.id == tile.id ? Color.black : Color.clear, width: 2)
                                .onTapGesture {
                                    viewModel.selectTile(tile: tile)
                                }
                        }
                    }
                }
            }
            .padding()

            Button("Reset Game") {
                viewModel.resetGame()
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showResult) {
            Alert(title: Text("Game Over"), message: Text(viewModel.resultMessage), dismissButton: .default(Text("OK"), action: {
                viewModel.resetGame()
            }))
        }
    }
}
