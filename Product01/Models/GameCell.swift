//
//  GameLevel.swift
//  Product01
//
//  Created by COBSCCOMP24.2P-056 on 2026-01-12.
import SwiftUI

struct ColorModel: Identifiable {
    let id = UUID()
    let color: Color
    var isMatched: Bool = false
    var isSelected: Bool = false
}
