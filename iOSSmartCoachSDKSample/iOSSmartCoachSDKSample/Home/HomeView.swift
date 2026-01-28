//
//  HomeView.swift
//  SmartCoachSDKDev
//
//  Created by Wyeth Shamp on 1/28/26.
//

import SwiftUI
import SmartCoachSDK

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var measurementFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        return formatter
    }
    @ViewBuilder
    func deviceInfoView(device: any SmartCoachRadar) -> some View {
        VStack {
            Text("Device ID: \(device.id)")
                .font(.headline)
            Text("RSSI: \(device.rssi)")
            Text("Device Type: \(device.deviceType.description)")
            Text("MAC Address: \(device.macAddress ?? "")")
            Text("Measurement Unit: \(device.measurementUnit.description)")
            Text("Batter Level: \(device.batteryLevel.description)")
            //Text("Measurement State: \(device.measurementState.description)")
            Text("Power Source: \(device.powerSource.description)")
            Text("Model Number: \(device.modelNumber ?? "unknown")")
        }
    }
    
    var body: some View {
        VStack {
            
            RadarStatusView(state: $viewModel.sessionState)
            Spacer().frame(height: 50)
            connectionActionButton
            Spacer().frame(height: 50)
            switch viewModel.sessionState {
            case .scanning:
                deviceListView
            case let .connected(connectedDevice):
                VStack(spacing: 16) {
                    deviceInfoView(device: connectedDevice)
                    
                    Divider()
                    Button("Start Measuring") {
                        viewModel.startMeasuring()
                    }.buttonStyle(.bordered)
                }
            case let .measuring(connectedDevice):
                
                VStack(spacing: 16) {
                    deviceInfoView(device: connectedDevice)
                    Divider()
                    Button("Stop Measuring") {
                        viewModel.stopMeasuring()
                    }.buttonStyle(.bordered)
                }
                if viewModel.speeds.isEmpty {
                    Text("Waiting for readings...")
                        .foregroundColor(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(viewModel.speeds.prefix(10).enumerated()), id: \.offset) { _, speed in
                            HStack {
                                Text(measurementFormatter.string(from: speed))
                                    .font(.system(.body, design: .monospaced))
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                
            default:
                EmptyView()
            }
            Spacer()
        }.task {
            await viewModel.startMonitoring()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    @ViewBuilder
    private var deviceListView: some View {
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
    
    @ViewBuilder
    private var connectionActionButton: some View {
        switch viewModel.sessionState {
        case .disconnected:
            Button("Scan for Devices") {
                viewModel.startScanning()
            }
            .buttonStyle(.borderedProminent)
            
        case .connected, .connecting, .reconnecting, .measuring:
            Button("Disconnect") {
                viewModel.disconnect()
            }
            .buttonStyle(.bordered)
//        case .measuring:
//            Button("Stop Measuring") {
//                viewModel.stopMeasuring()
//            }
//            .buttonStyle(.bordered)
        case .scanning:
            Button("Stop Scanning") {
                viewModel.stopScanning()
            }
            .buttonStyle(.bordered)
        @unknown default:
            EmptyView()
        }
    }
}

#Preview {
    HomeView()
}
