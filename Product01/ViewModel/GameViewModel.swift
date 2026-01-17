//
//  GridViewModel.swift
//  Product01
//
//  Created by COBSCCOMP242P-057 on 2026-01-16.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // @Published triggers a UI refresh whenever these values change
    @Published var grid: [GridCell] = []
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var moves: Int = 0
    @Published var lives: Int = 5
    @Published var didWin: Bool = false
    @Published var matchedPairsCount: Int = 0
    
    private var totalPairsNeeded: Int = 0
    private var firstSelectedIndex: Int? = nil
    private var secondSelectedIndex: Int? = nil
    private var isProcessing: Bool = false
    
    // List all vibrant colors for the game
    private let normalColors: [Color] = [
        Color(red: 240/255, green: 43/255, blue: 29/255),   // vibrant red
        Color(red: 34/255, green: 160/255, blue: 59/255),   // vibrant green
        Color(red: 26/255, green: 115/255, blue: 232/255),  // vibrant blue
        Color(red: 252/255, green: 194/255, blue: 0/255),   // vibrant yellow
        Color(red: 244/255, green: 121/255, blue: 32/255),  // vibrant orange
        Color(red: 111/255, green: 48/255, blue: 214/255),  // vibrant purple
        Color(red: 0/255, green: 191/255, blue: 213/255)    // vibrant cyan
    ]
    
    init(gridSize: Int) {
        startNewGame(gridSize: gridSize)
    }
    
    // Setup a new game with shuffled pairs
    func startNewGame(gridSize: Int) {
        score = 0
        moves = 0
        lives = 5
        isGameOver = false
        didWin = false
        matchedPairsCount = 0
        grid = []
        firstSelectedIndex = nil
        secondSelectedIndex = nil
        isProcessing = false
        
        let totalCells = gridSize * gridSize
        totalPairsNeeded = totalCells / 2
        
        // Generate color pairs
        var allColors: [Color] = []
        
        // Create pairs
        for i in 0..<totalPairsNeeded {
            let colorIndex = i % normalColors.count
            let color = normalColors[colorIndex]
            allColors.append(color)
            allColors.append(color)
        }
        
        // Handle odd number of cells (like 3x3 = 9)
        if totalCells % 2 == 1 {
            allColors.append(normalColors.randomElement()!)
        }
        
        // Shuffle and create grid
        allColors.shuffle()
        grid = allColors.map { GridCell(color: $0) }
    }
    
    // Handles what happens when user taps a cell
    func selectCell(_ index: Int) {
        // Prevent interaction if processing, cell is matched, or already revealed
        guard !isProcessing,
              !grid[index].isMatched,
              !grid[index].isRevealed,
              !isGameOver else { return }
        
        // Reveal the cell
        grid[index].isRevealed = true
        
        // First cell selection
        if firstSelectedIndex == nil {
            firstSelectedIndex = index
        }
        // Second cell selection
        else if secondSelectedIndex == nil && index != firstSelectedIndex {
            secondSelectedIndex = index
            moves += 1
            isProcessing = true
            
            // Check for match after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.checkForMatch()
            }
        }
    }
    
    // Check if the two revealed cells match
    private func checkForMatch() {
        guard let first = firstSelectedIndex,
              let second = secondSelectedIndex else {
            isProcessing = false
            return
        }
        
        if grid[first].color == grid[second].color {
            // MATCH FOUND!
            grid[first].isMatched = true
            grid[second].isMatched = true
            score += 10
            matchedPairsCount += 1
            
            // Check for win condition
            if matchedPairsCount >= totalPairsNeeded {
                // Player matched all pairs - WIN!
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isGameOver = true
                    self.didWin = true
                }
            }
        } else {
            // NO MATCH
            grid[first].isRevealed = false
            grid[second].isRevealed = false
            lives -= 1
            
            // Check for game over (no lives left)
            if lives <= 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isGameOver = true
                    self.didWin = false
                }
            }
        }
        
        // Reset selection
        firstSelectedIndex = nil
        secondSelectedIndex = nil
        isProcessing = false
    }
}
