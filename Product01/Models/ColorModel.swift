//
//  GameLevel.swift
//  Product01
//
//  Created by COBSCCOMP24.2P-056 on 2026-01-12.
import SwiftUI

class Tile: Identifiable, ObservableObject {
    let id = UUID()
    let color: Color           // Target color
    @Published var currentColor: Color // Player selected color

    init(color: Color, currentColor: Color? = nil) {
        self.color = color
        self.currentColor = currentColor ?? .gray
    }
}
