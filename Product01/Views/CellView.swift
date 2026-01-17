//
//  GridCellView.swift
//  Product01
//
//  Created by COBSCCOMP24.2P-056 on 2026-01-12.
//
//

//

import SwiftUI

struct CellView: View {
    var cell: GridCell
    
    var body: some View {
        ZStack {
            // Show color only when revealed or matched
            if cell.isRevealed || cell.isMatched {
                Rectangle()
                    .fill(cell.color)
            } else {
                // Hidden state - all cells look the same (gray)
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.7), Color.gray.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Checkmark when matched
            if cell.isMatched {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
            }
            
            // Question mark when hidden
            if !cell.isRevealed && !cell.isMatched {
                Text("")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(8)
        .shadow(radius: 2)
        .animation(.easeInOut(duration: 0.3), value: cell.isRevealed)
        .animation(.easeInOut(duration: 0.3), value: cell.isMatched)
    }
}
