import SwiftUI

struct HomeView: View {
    @State private var showGuidelines = false
    @State private var animateGradient = false
    @State private var rotateIcon = false
    @State private var floatingOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                // Animated Background Gradient
                AnimatedGradientBackground(animate: animateGradient)
                
                // Floating particles effect
                FloatingParticlesView()

                VStack(spacing: 50) {
                    Spacer()
                        .frame(height: 20)
                    
                    // App Title Section with Animation
                    VStack(spacing: 16) {
                        // Animated Brain Icon
                        ZStack {
                            // Glow effect
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [.purple.opacity(0.6), .clear],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .blur(radius: 20)
                                .scaleEffect(animateGradient ? 1.2 : 1.0)
                            
                            Image(systemName: "brain.head.profile")
                                .resizable()
                                .frame(width: 90, height: 90)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .cyan, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .cyan.opacity(0.8), radius: 15, x: 0, y: 0)
                                .rotationEffect(.degrees(rotateIcon ? 5 : -5))
                                .offset(y: floatingOffset)
                        }

                        Text("Icon Match Game")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan, .purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                            .scaleEffect(animateGradient ? 1.02 : 1.0)

                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                                .scaleEffect(animateGradient ? 1.2 : 1.0)
                            
                            Text("Match icons AND colors to win!")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                                .scaleEffect(animateGradient ? 1.2 : 1.0)
                        }
                        .shadow(radius: 5)
                    }

                    // Game Difficulty Buttons
                    VStack(spacing: 22) {
                        AnimatedDifficultyButton(
                            title: "Easy",
                            gridSize: 3,
                            colors: [Color.green, Color.mint, Color.cyan],
                            iconName: "hare.fill",
                            description: "3×4 Grid"
                        )
                        
                        AnimatedDifficultyButton(
                            title: "Medium",
                            gridSize: 5,
                            colors: [Color.orange, Color.yellow, Color.pink],
                            iconName: "figure.walk",
                            description: "5×6 Grid"
                        )
                        
                        AnimatedDifficultyButton(
                            title: "Complex",
                            gridSize: 7,
                            colors: [Color.red, Color.purple, Color.pink],
                            iconName: "bolt.fill",
                            description: "7×8 Grid"
                        )
                    }
                    .padding(.horizontal, 30)

                    // Bottom Action Icons
                    HStack(spacing: 70) {
                        ActionIconButton(
                            icon: "book.circle.fill",
                            label: "How to Play",
                            color: .cyan
                        ) {
                            showGuidelines = true
                        }
                        
                        NavigationLink(destination: LeaderboardView()) {
                            ActionIconView(
                                icon: "trophy.fill",
                                label: "Leaderboard",
                                color: .yellow
                            )
                        }
                    }
                    .sheet(isPresented: $showGuidelines) {
                        HowToPlayView()
                    }

                    Spacer()
                }
                .padding(.top, 40)
            }
            .ignoresSafeArea()
            .onAppear {
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // Gradient animation
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            animateGradient = true
        }
        
        // Icon rotation
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            rotateIcon = true
        }
        
        // Floating animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            floatingOffset = -10
        }
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    let animate: Bool
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.9),
                    Color.blue.opacity(0.8),
                    Color.cyan.opacity(0.7)
                ],
                startPoint: animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            
            // Overlay gradient for depth
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.3),
                    Color.clear,
                    Color.purple.opacity(0.3)
                ],
                startPoint: animate ? .top : .bottom,
                endPoint: animate ? .bottom : .top
            )
        }
        .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
    }
}

// MARK: - Floating Particles
struct FloatingParticlesView: View {
    @State private var particles: [ParticleData] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color.opacity(0.6))
                    .frame(width: particle.size, height: particle.size)
                    .blur(radius: particle.blur)
                    .position(particle.position)
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.cyan, .purple, .pink, .yellow, .mint]
        for i in 0..<15 {
            let particle = ParticleData(
                color: colors[i % colors.count],
                size: CGFloat.random(in: 20...60),
                position: CGPoint(
                    x: CGFloat.random(in: 0...400),
                    y: CGFloat.random(in: 0...800)
                ),
                blur: CGFloat.random(in: 5...15)
            )
            particles.append(particle)
            animateParticle(at: i)
        }
    }
    
    private func animateParticle(at index: Int) {
        withAnimation(
            .easeInOut(duration: Double.random(in: 3...6))
            .repeatForever(autoreverses: true)
            .delay(Double.random(in: 0...2))
        ) {
            particles[index].position = CGPoint(
                x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: 0...800)
            )
        }
    }
}

struct ParticleData: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    var position: CGPoint
    let blur: CGFloat
}

// MARK: - Animated Difficulty Button
struct AnimatedDifficultyButton: View {
    let title: String
    let gridSize: Int
    let colors: [Color]
    let iconName: String
    let description: String
    
    @State private var isPressed: Bool = false
    @State private var shimmer: Bool = false
    
    var body: some View {
        NavigationLink(destination: GameView(gridSize: gridSize, level: title)) {
            HStack(spacing: 15) {
                // Icon with glow
                ZStack {
                    Circle()
                        .fill(colors.first!.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .blur(radius: 10)
                    
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                // Title and Description
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Arrow with pulse
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                    .scaleEffect(shimmer ? 1.15 : 1.0)
            }
            .padding()
            .background(
                ZStack {
                    // Base gradient
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Shimmer effect
                    LinearGradient(
                        colors: [
                            .white.opacity(0),
                            .white.opacity(shimmer ? 0.3 : 0),
                            .white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
            )
            .cornerRadius(25)
            .shadow(color: colors.first!.opacity(0.6), radius: isPressed ? 5 : 15, x: 0, y: isPressed ? 2 : 8)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                shimmer = true
            }
        }
    }
}

// MARK: - Action Icon Button
struct ActionIconButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    @State private var bounce = false
    
    var body: some View {
        Button(action: action) {
            ActionIconView(icon: icon, label: label, color: color, bounce: bounce)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                bounce = true
            }
        }
    }
}

struct ActionIconView: View {
    let icon: String
    let label: String
    let color: Color
    var bounce: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.6), .clear],
                            center: .center,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 15)
                
                // Icon
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.8), radius: 10, x: 0, y: 5)
                    .scaleEffect(bounce ? 1.1 : 1.0)
            }
            
            Text(label)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .font(.caption.bold())
                .shadow(radius: 3)
        }
    }
}

#Preview {
    HomeView()
}
