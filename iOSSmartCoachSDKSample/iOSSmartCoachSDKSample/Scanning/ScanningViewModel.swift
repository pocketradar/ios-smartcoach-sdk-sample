//
//  ScanningViewModel.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/29/26.
//

import Foundation
import SwiftUI
import SmartCoachSDK

@MainActor
@Observable
class ScanningViewModel {
    var availableDevices: [any SmartCoachRadar] = []
    var errorMessage: String?
    private var scanningObservationsTask: Task<Void, Never>?
    var isScanning = false

    // Available in Swift 6.2
    // Otherwise start startScanningObservations needs to be async and called from the view.task
    isolated deinit {
        resetScanning()
    }
    
    func startScanning() {
        guard !isScanning else { return }
        resetScanning()
        startScanningObservations()
        Task {
            do {
                isScanning = true
                try await SmartCoach.startScanning(connectToLastPairedDevice: false)
            } catch {
                self.errorMessage = "Failed to start scan: \(error.localizedDescription)"
            }
        }
    }
    
    func stopScanning() {
        resetScanning()
        isScanning = false
        Task {
            do {
                try await SmartCoach.stopScanning()
            } catch {
                self.errorMessage = "Failed to stop scan: \(error.localizedDescription)"
            }
        }
    }
    
    func connectToDevice(_ device: any SmartCoachRadar) {
        // Connect to device
    }
    
    private func startScanningObservations() {
        resetScanning()
        scanningObservationsTask = Task { @MainActor in
            do {
                for await state in try await SmartCoach.sessionStateStream() {
                    try Task.checkCancellation()
                    if case let .scanning(devices) = state {
                        availableDevices = devices
                    }
                }
            } catch SmartCoachError.notConfigured {
                errorMessage = "Please configure the SDK"
            } catch {
                errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                print(error.localizedDescription)
            }
        }
    }
    
    private func resetScanning() {
        scanningObservationsTask?.cancel()
        scanningObservationsTask = nil
        availableDevices.removeAll()
    }
}
