import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isTapped: Bool = false
    
    private let columns: [GridItem]
    private let gridSize: Int
    private let level: String

    init(gridSize: Int, level: String) {
        self.gridSize = gridSize
        self.level = level
        let adjustedSize = gridSize % 2 == 0 ? gridSize : gridSize + 1
        
        // Initialize StateObject with level
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize, level: level))
        
        // Initialize columns
        self.columns = Array(
            repeating: GridItem(.flexible(), spacing: 12),
            count: adjustedSize
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo],
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 15) {
                // HUD
                HStack {
                    Label("\(viewModel.timeRemaining)", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Label("\(viewModel.score)", systemImage: "star.fill")
                        .font(.headline)
                        .foregroundColor(.yellow)

                    Spacer()

                    Button {
                        viewModel.showHint()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Image(systemName: "lightbulb.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 20)

                // Game instruction with level badge
                HStack {
                    Text("Match icon AND color!")
                        .font(.subheadline.bold())
                        .foregroundColor(.yellow)
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(level)
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(levelColor.opacity(0.3))
                        )
                        .overlay(
                            Capsule()
                                .stroke(levelColor, lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                // Game Grid
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.cells.indices, id: \.self) { index in
                        CellView(cell: viewModel.cells[index])
                            .onTapGesture {
                                viewModel.tapCell(at: index)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                    }
                }
                .padding()
            }

            // Result Popup
            if viewModel.showResult {
                ResultPopupView(isWin: viewModel.isWin) {
                    viewModel.resetGame()
                }
                .environmentObject(viewModel)
            }

            // Floating action icons
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    Button {
                        viewModel.resetGame()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                            .shadow(radius: 5)
                            .scaleEffect(isTapped ? 0.9 : 1)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isTapped)
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in isTapped = true }
                            .onEnded { _ in isTapped = false }
                    )

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .shadow(radius: 5)
                    }

                    NavigationLink(destination: LeaderboardView()) {
                        Image(systemName: "rosette")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                            .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Match All Pairs")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper to get level color
    private var levelColor: Color {
        switch level {
        case "Easy": return .green
        case "Medium": return .orange
        case "Complex": return .red
        default: return .white
        }
    }
}

#Preview {
    NavigationStack {
        GameView(gridSize: 3, level: "Easy")
    }
}
