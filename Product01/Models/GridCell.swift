//
//  GameLevel.swift
//  Product01
//
//  Created by COBSCCOMP24.2P-056 on 2026-01-12.
//



import SwiftUI

struct GridCell: Identifiable {
    let id = UUID()
    var color: Color
    var isMatched: Bool = false
    var isRevealed: Bool = false  // Shows if the cell is currently visible
}
