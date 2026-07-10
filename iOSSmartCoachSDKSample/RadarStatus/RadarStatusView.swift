//
//  RadarStatusView.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/13/26.
//

import SwiftUI
import SmartCoachSDK

struct RadarStatusView: View {
    let state: SmartCoachSessionState
    var body: some View {
        ZStack {
            switch state {
            case .connected(let device), .measuring(let device):
                HStack {
                    SignalStrengthView(level: RadarConnectionStrength(rssi: device.rssi))
                    Text("Connected")
                }
            case .disconnected:
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Radar not connected")
                }
            case .connecting:
                AnimatedElipsisTextView(text: "Connecting")
            case .reconnecting:
                AnimatedElipsisTextView(text: "Reconnecting")
            case .scanning:
                AnimatedElipsisTextView(text: "Scanning")
            @unknown default:
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Radar not connected")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var status: SmartCoachSessionState = .connected(MockRadar())
    RadarStatusView(state: status)
}
#Preview {
    @Previewable @State var status: SmartCoachSessionState = .disconnected(nil)
    RadarStatusView(state: status)
}

#Preview {
    @Previewable @State var status: SmartCoachSessionState = .scanning([])
    RadarStatusView(state: status)
}


struct MockRadar: SmartCoachRadar {
    let id = "345"
    let rssi = 45
    let deviceType: DeviceType = .smartCoach1
    let macAddress: String? = nil
    var measurementUnit: RadarMeasurementUnit = .unknown
    var batteryLevel: RadarBatteryLevel = .unknown
    //var measurementState: RadarMeasurementState = .unknown
    var powerSource: RadarPowerSource = .unknown
    var modelNumber: String? = nil
}
