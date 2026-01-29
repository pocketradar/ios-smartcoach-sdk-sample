//
//  ScanningView.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/29/26.
//

import SwiftUI
import SmartCoachSDK

struct ScanningView: View {
    @State private var viewModel = ScanningViewModel()
    var body: some View {
        VStack {
            scanningButton
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.availableDevices, id: \.id) { device in
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text(device.id)
                                    .font(.headline)
                                Text("RSSI: \(device.rssi)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            // Signal strength indicator
                            SignalStrengthView(level: RadarConnectionStrength(rssi: device.rssi))
                                .frame(width: 24, height: 24)
                            Button("Connect") {
                                viewModel.connectToDevice(device)
                            }.buttonStyle(.bordered)
                            
                        }
                    }
                }.padding()
            }
        }
    }
    
    @ViewBuilder
    private var scanningButton: some View {
        if viewModel.isScanning {
            Button("Stop Scanning") {
                viewModel.stopScanning()
            }.buttonStyle(.bordered)
        } else {
            Button("Start Scanning") {
                viewModel.startScanning()
            }.buttonStyle(.bordered)
        }
    }
}

#Preview {
    ScanningView()
}
