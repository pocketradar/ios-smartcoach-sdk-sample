//
//  HomeViewModel.swift
//  SmartCoachSDKDev
//
//  Created by Wyeth Shamp on 1/28/26.
//

import Foundation
import SwiftUI
import SmartCoachSDK

@MainActor
@Observable
class HomeViewModel {
    var sessionState: SmartCoachSessionState = SmartCoach.currentSessionState()
    var errorMessage: String?
    var availableDevices: [any SmartCoachRadar] = []
    var selectedDevice: (any SmartCoachRadar)?
    var speeds: [Measurement<UnitSpeed>] = []
    var speedsTask: Task<Void, Never>?
    func startMonitoring() async {

        do {
            for await value in try await SmartCoach.sessionStateStream() {
                try Task.checkCancellation()
                sessionState = value
                switch value {
                    
                case let .scanning(devices):
                    availableDevices = devices
                    cancelSpeedsTask()
                case .measuring:
                    availableDevices.removeAll()
                default:
                    availableDevices.removeAll()
                    cancelSpeedsTask()
                }
            }
        } catch SmartCoachError.notConfigured {
            errorMessage = "Please configure the SDK"
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)" 
            print(error.localizedDescription)
        }
            
    }
    
    func connectToDevice(_ device: any SmartCoachRadar) {
        guard sessionState.rootState != .connected else { return }
        Task {
            do {
                try await SmartCoach.connect(to: device)
            } catch {
                self.errorMessage = "Connection failed: \(error.localizedDescription)"
            }
        }
    }
    
    func disconnect() {
        Task {
            await SmartCoach.disconnect()
        }
    }
    
    func startScanning() {
        guard sessionState.rootState != .scanning else { return }
        Task {
            do {
                try await SmartCoach.startScanning(connectToLastPairedDevice: false)
            } catch {
                self.errorMessage = "Failed to start scan: \(error.localizedDescription)"
            }
        }
    }
    
    func stopScanning() {
        Task {
            do {
                try await SmartCoach.stopScanning()
            } catch {
                self.errorMessage = "Failed to stop scan: \(error.localizedDescription)"
            }
        }
    }
    
    func startMeasuring() {
        guard sessionState.rootState != .measuring else { return }
        speeds.removeAll()
        speedsTask = Task {
            do {
                for await speed in try await SmartCoach.startMeasuring() {
                    await MainActor.run {
                        self.speeds.insert(speed.measurement, at: 0)
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to start measuring: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func cancelSpeedsTask() {
        speedsTask?.cancel()
        speedsTask = nil
        speeds.removeAll()
    }
    
    func stopMeasuring() {
        cancelSpeedsTask()
        guard sessionState.rootState == .measuring else { return }
        Task {
            do {
                try await SmartCoach.stopMeasuring()
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to stop measuring: \(error.localizedDescription)"
                }
            }
        }
    }
}


enum RadarConnectionStatus {
    case connected(any SmartCoachRadar)
    case disconnected
    case connecting
    case reconnecting
    case scanning
}

enum RadarConnectionStrength: Int {
    case none = 0
    case weak
    case low
    case medium
    case strong
}

extension RadarConnectionStrength {
    init(rssi: Int) {
        switch rssi {
        case ..<(-90):
            self = .none
        case -90..<(-70):
            self = .weak
        case -70..<(-60):
            self = .low
        case -60..<(-50):
            self = .medium
        default:
            self = .strong
        }
    }
}
