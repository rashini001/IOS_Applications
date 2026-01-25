import SwiftUI

struct GameCell: Identifiable {
    let id = UUID()
    let icon: String
    let gradient: LinearGradient
    let gradientId: Int  // NEW: Add ID to identify matching gradients
    var isRevealed: Bool = false
    var isMatched: Bool = false
}
