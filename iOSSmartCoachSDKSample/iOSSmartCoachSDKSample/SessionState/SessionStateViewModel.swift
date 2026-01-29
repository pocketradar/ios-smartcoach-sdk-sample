//
//  SessionStateViewModel.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/29/26.
//

import Foundation
import SwiftUI
import SmartCoachSDK

@MainActor
@Observable
class SessionStateViewModel {
    var currentState: SmartCoachSessionState = SmartCoach.currentSessionState()
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
    
    private func monitorSessionState() {
        sessionStateTask = Task { @MainActor in
            do {
                for await state in try await SmartCoach.sessionStateStream() {
                    try Task.checkCancellation()
                    currentState = state
                    handleStateChange(state)
                }
            } catch SmartCoachError.notConfigured {
                errorMessage = "Please configure the SDK"
            } catch {
                errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleStateChange(_ state: SmartCoachSessionState) {
        switch state {
        case .disconnected:
            print("Device disconnected")
            
        case .scanning:
            print("Scanning for devices...")
            
        case .connecting:
            print("Connecting to device...")
            
        case .reconnecting:
            print("Reconnecting to device...")
            
        case .connected:
            print("Device connected and ready")
            
        case .measuring:
            print("Receiving measurements")
        @unknown default:
            print("unknown state")
        }
    }
}
