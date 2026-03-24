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
            print("SDK configured successfully: \(SmartCoach.getVersion())")
        } catch SmartCoachError.missingApiKey {
            // Show alert to developer
            print("API key is missing from Info.plist")
        } catch SmartCoachError.alreadyConfigured {
            // Safe to ignore if you're okay with single configuration
            print("SDK already configured")
        } catch SmartCoachError.invalidBundleId {
            print("Bundle ID mismatch - check developer portal")
        } catch {
            print("Configuration error: \(error.localizedDescription)")
        }
    }
    var body: some Scene {
        WindowGroup {
            FullWorkflowView()
        }
    }
}
