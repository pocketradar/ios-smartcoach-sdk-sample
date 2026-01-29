//
//  ConnectionViewModel.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/29/26.
//

import Foundation
import SwiftUI
import SmartCoachSDK

@MainActor
@Observable
class ConnectionViewModel {
    var sessionState: SmartCoachSessionState = SmartCoach.currentSessionState()
    var errorMessage: String?
    private var sessionStateTask: Task<Void, Never>?
    
    init() {
        monitorSessionState()
    }
    
    // Available in Swift 6.2
    // Otherwise start startScanningObservations needs to be async and called from the view.task
    isolated deinit {
        sessionStateTask?.cancel()
        sessionStateTask = nil
    }
    
    func connectToDevice(_ device: any SmartCoachRadar) {
        guard sessionState.rootState == .disconnected else { return }
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
        // handle scanning
    }
    
    private func monitorSessionState() {
        sessionStateTask = Task { @MainActor in
            do {
                for await state in try await SmartCoach.sessionStateStream() {
                    try Task.checkCancellation()
                    sessionState = state
                }
            } catch SmartCoachError.notConfigured {
                errorMessage = "Please configure the SDK"
            } catch {
                errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                print(error.localizedDescription)
            }
        }
    }
}
