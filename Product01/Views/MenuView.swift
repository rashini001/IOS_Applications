//
//  MainView.swift
//  Product01
//
//  Created by COBSCCOMP24.2P-056 on 2026-01-17.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.black, Color.indigo],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    // Title Section
                    VStack(spacing: 12) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                        
                        Text("LET'S PLAY")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // Difficulty Buttons
                    VStack(spacing: 25) {
                        
                        NavigationLink {
                            GameView(gridSize: 3)
                        } label: {
                            CleanGameButton(title: "EASY", colors: [.green, .teal])
                        }
                        
                        NavigationLink {
                            GameView(gridSize: 5)
                        } label: {
                            CleanGameButton(title: "MEDIUM", colors: [.orange, .yellow])
                        }
                        
                        NavigationLink {
                            GameView(gridSize: 7)
                        } label: {
                            CleanGameButton(title: "COMPLEX", colors: [.red, .pink])
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Clean Game Button
struct CleanGameButton: View {
    let title: String
    let colors: [Color]
    
    var body: some View {
        Text(title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: colors.first!.opacity(0.6), radius: 10, x: 0, y: 6)
    }
}
