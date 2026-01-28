//
//  SignalStrengthView.swift
//  SmartCoachSDKDev
//
//  Created by Wyeth Shamp on 1/13/26.
//

import SwiftUI

struct SignalStrengthView: View {
    let level: RadarConnectionStrength  // 0–4
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(index < level.rawValue ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 3, height: CGFloat(index + 1) * 5)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: level)
        .accessibilityLabel(Text("Signal strength: \(level.rawValue) bars"))
    }
}

#Preview {
    SignalStrengthView(level: .weak)
}
