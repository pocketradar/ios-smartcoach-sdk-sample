//
//  AnimatedElipsisTextView.swift
//  SmartCoachSDKDev
//
//  Created by Wyeth Shamp on 1/13/26.
//

import SwiftUI

struct AnimatedElipsisTextView: View {
    let text: String
    @State private var dotCount: Int = 1
    private let maxDots = 3
    private let interval: TimeInterval = 0.5
    
    var body: some View {
        Text(text + String(repeating: ".", count: dotCount))
            .frame(minWidth: 140, alignment: .leading)
            .font(.headline)
            .onAppear {
                startAnimation()
            }
            .onDisappear {
                dotCount = 1
            }
    }
    
    private func startAnimation() {
        Task {
            while !Task.isCancelled {
                try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                dotCount = dotCount % maxDots + 1
            }
        }
    }
}

#Preview {
    AnimatedElipsisTextView(text: "Connecting")
}

