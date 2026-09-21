//
//  FullWorkflowViewModel.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/28/26.
//

import Foundation
import SmartCoachSDK

@MainActor
@Observable
class FullWorkflowViewModel {
    var sessionState: SmartCoachSessionState = SmartCoach.currentSessionState()
    var errorMessage: String?
    var availableDevices: [any SmartCoachRadar] = []
    var speeds: [Measurement<UnitSpeed>] = []
    private var speedsTask: Task<Void, Never>?

    /// Observes SDK session state for the lifetime of the calling task.
    ///
    /// Drive this from the view's `.task` modifier — SwiftUI cancels the task
    /// automatically when the view disappears, so there is no stored task to manage
    /// and no manual teardown to forget.
    func startMonitoring() async {
        do {
            for await state in try await SmartCoach.sessionStateStream() {
                sessionState = state
                switch state {
                case let .scanning(devices):
                    availableDevices = devices
                    cancelSpeedsTask()
                case .measuring:
                    availableDevices.removeAll()
                case let .disconnected(error):
                    availableDevices.removeAll()
                    cancelSpeedsTask()
                    // Surface the error but keep observing — exiting the loop here
                    // would leave the UI blind to every later state change.
                    if let error {
                        errorMessage = error.localizedDescription
                    }
                default:
                    availableDevices.removeAll()
                    cancelSpeedsTask()
                }
            }
        } catch SmartCoachError.notConfigured {
            errorMessage = "Please configure the SDK"
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }

    func connectToDevice(_ device: any SmartCoachRadar) {
        guard sessionState.rootState != .connected else { return }
        Task {
            do {
                try await SmartCoach.connect(to: device)
            } catch {
                errorMessage = "Connection failed: \(error.localizedDescription)"
            }
        }
    }

    func disconnect() {
        Task {
            await SmartCoach.disconnect()
        }
    }

    func startScanning(autoConnect: Bool) {
        guard sessionState.rootState != .scanning else { return }
        Task {
            do {
                try await SmartCoach.startScanning(connectToLastPairedDevice: autoConnect)
            } catch {
                errorMessage = "Failed to start scan: \(error.localizedDescription)"
            }
        }
    }

    func stopScanning() {
        Task {
            do {
                try await SmartCoach.stopScanning()
            } catch {
                errorMessage = "Failed to stop scan: \(error.localizedDescription)"
            }
        }
    }

    func startMeasuring() {
        // Measuring is only valid from .connected — the SDK enforces this
        // (SmartCoachError.invalidSessionState); the guard keeps the UI honest.
        guard sessionState.rootState == .connected else { return }
        speeds.removeAll()
        speedsTask = Task { [weak self] in
            do {
                // The stream completes when measuring stops, the device disconnects,
                // or the connection is lost — the loop ends on its own.
                for await speed in try await SmartCoach.startMeasuring() {
                    self?.speeds.insert(speed.measurement, at: 0)
                }
            } catch {
                self?.errorMessage = "Failed to start measuring: \(error.localizedDescription)"
            }
        }
    }

    func stopMeasuring() {
        cancelSpeedsTask()
        guard sessionState.rootState == .measuring else { return }
        Task {
            do {
                try await SmartCoach.stopMeasuring()
            } catch {
                errorMessage = "Failed to stop measuring: \(error.localizedDescription)"
            }
        }
    }

    private func cancelSpeedsTask() {
        speedsTask?.cancel()
        speedsTask = nil
        speeds.removeAll()
    }

    // No deinit cleanup is needed (or possible — deinit is nonisolated and cannot touch
    // this @MainActor property): the speeds task captures self weakly, so it cannot keep
    // this view model alive, and the measurement stream completes on stopMeasuring,
    // disconnect, or connection loss, ending the task with it.
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
