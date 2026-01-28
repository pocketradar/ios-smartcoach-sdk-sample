//
//  iOSSmartCoachSDKSampleApp.swift
//  iOSSmartCoachSDKSample
//
//  Created by Wyeth Shamp on 1/22/26.
//

import SwiftUI
import SmartCoachSDK
@main
struct iOSSmartCoachSDKSampleApp: App {
    init() {
        do {
            try SmartCoach.configure()
        } catch {
            print("SmartCoach failed to configure: \(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
