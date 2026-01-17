//
//  GameView.swift
//  Product01
//
//  Created by COBSCCOMP242P-056 on 2026-01-16.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    let gridSize: Int
    
    private let spacing: CGFloat = 8
    
    init(gridSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gridSize: gridSize))
        self.gridSize = gridSize
    }
    
    var difficultyName: String {
        switch gridSize {
        case 3: return "EASY"
        case 5: return "MEDIUM"
        case 7: return "HARD"
        default: return "CUSTOM"
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(
                colors: [Color.black, Color.indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // MARK: - Header / Stats
                VStack(spacing: 12) {
                    Text(difficultyName)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 30) {
                        StatBox(title: "SCORE", value: "\(viewModel.score)")
                        StatBox(title: "MOVES", value: "\(viewModel.moves)")
                    }
                }
                .padding(.top)
                
                // MARK: - Game Grid
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: spacing),
                        count: gridSize
                    ),
                    spacing: spacing
                ) {
                    ForEach(viewModel.grid.indices, id: \.self) { index in
                        let cell = viewModel.grid[index]
                        
                        CellView(cell: cell)
                            .onTapGesture {
                                if !viewModel.isGameOver {
                                    viewModel.selectCell(index)
                                }
                            }
                    }
                }
                .padding()
                
                Spacer()
                
                // MARK: - Win / Loss Display
                if viewModel.isGameOver {
                    VStack(spacing: 16) {
                        // Header text
                        Text(viewModel.didWin ? "🎉 YOU WIN!" : "💔 GAME OVER")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(viewModel.didWin ? .green : .red)
                        
                        Text(viewModel.didWin ? "All colors matched successfully!" : "Try again to match all colors!")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                        
                        // Score and Moves
                        HStack(spacing: 20) {
                            StatBox(title: "FINAL SCORE", value: "\(viewModel.score)")
                            StatBox(title: "TOTAL MOVES", value: "\(viewModel.moves)")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: viewModel.didWin ? [Color.green.opacity(0.7), Color.green] : [Color.red.opacity(0.7), Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    .transition(.scale)
                    .animation(.spring(), value: viewModel.isGameOver)
                }
                
                Spacer()
                
                // MARK: - Restart Button
                Button(action: {
                    viewModel.startNewGame(gridSize: gridSize)
                }) {
                    Text("RESTART")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusable Stat Box (UI only)
struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(10)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .frame(minWidth: 80)
    }
}
