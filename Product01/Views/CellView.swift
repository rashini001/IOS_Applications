import SwiftUI

struct CellView: View {
    let cell: GameCell
    @State private var rotation = 0.0
    @State private var scaleEffect: CGFloat = 1.0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(cell.isMatched
                      ? LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom)
                      : (cell.isRevealed
                         ? cell.gradient
                         : LinearGradient(colors: [.gray, .gray.opacity(0.7)], startPoint: .top, endPoint: .bottom)))
                .shadow(color: cell.isMatched ? .green : .black.opacity(0.3),
                        radius: cell.isMatched ? 12 : 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(cell.isRevealed && !cell.isMatched
                                ? LinearGradient(colors: [.white.opacity(0.5), .clear],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                                : LinearGradient(colors: [.clear, .clear],
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing),
                                lineWidth: 2)
                )

            if cell.isRevealed || cell.isMatched {
                Image(systemName: cell.icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2)
                    .scaleEffect(cell.isMatched ? scaleEffect : 1)
                    .onAppear {
                        if cell.isMatched {
                            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                scaleEffect = 1.15
                            }
                        }
                    }
            } else {
                Text("?")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(height: 60)
        .rotation3DEffect(.degrees(cell.isRevealed || cell.isMatched ? 0 : 180),
                          axis: (x: 0, y: 1, z: 0))
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: cell.isRevealed)
    }
}

#Preview {
    CellView(cell: GameCell(
        icon: "heart.fill",
        gradient: LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing),
        gradientId: 0,
        isRevealed: true
    ))
    .frame(width: 100, height: 100)
    .padding()
}
