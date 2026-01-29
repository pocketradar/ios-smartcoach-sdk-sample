# SmartCoachSDK Beta

Welcome to the SmartCoach SDK closed beta! This repository contains a sample app demonstrating how to integrate and use the SmartCoach SDK with your iOS applications.

## 🚀 Getting Started

### Prerequisites

- macOS with Xcode 15.0 or later
- iOS 18.0 or later device/simulator
- Access to this private repository

### Quick Start

1. **Clone the repository:**
```bash
   git clone [repository-url]
   cd ios-smartcoach-sdk-sample
```

2. **Open the sample app:**
```bash
   open iOSSmartCoachSDKSample/iOSSmartCoachSDKSample.xcodeproj
```

3. **Build and run:**
   - Select your target device/simulator
   - Press ⌘R to build and run
   - The SDK package will resolve automatically

## 📚 Viewing Documentation

The SDK includes comprehensive documentation with guides, tutorials, and API reference.

### Access Documentation in Xcode

1. **Open the sample app project**
2. **Build Documentation:** Press **⌃⇧⌘D** (Control-Shift-Command-D) or go to **Product → Build Documentation**
3. **Browse Documentation:** Press **⌘⇧0** (Command-Shift-0) to open the Documentation Browser
4. **Search for "SmartCoach"** to find the SDK documentation

### What's Included

- **Getting Started Guide** - Installation and quick start
- **Configuration Guide** - SDK setup and options
- **Step-by-Step Tutorials:**
  - Connecting Your First Device (15 min)
  - Streaming Measurement Data (20 min)
- **Core Guides:**
  - Device Discovery
  - Connection Management
  - Session State Management
  - Error Handling
  - Best Practices
- **API Reference** - Complete documentation for all public types and methods

### Quick Help

You can also access documentation inline while coding:
- **Option-click** any SmartCoach type or method to see Quick Help
- Documentation appears automatically in **code completion**

## 📦 Using the SDK in Your Own App

Want to integrate SmartCoachSDK into your own application?

### Option 1: Add as Local Package (Recommended for Beta)

1. **Locate the package:**
```
   ios-smartcoach-sdk-sample/SmartCoachSDK-Package/
```

2. **In your app project:**
   - File → Add Package Dependencies...
   - Click **Add Local...**
   - Navigate to and select `SmartCoachSDK-Package`
   - Click **Add Package**

3. **Import and use:**
```swift
   import SmartCoachSDK
   
   try SmartCoach.configure()
```

### Option 2: Extract the XCFramework

If you prefer to manually add the binary framework:

1. **Copy the framework:**
```bash
   cp -r SmartCoachSDK-Package/SmartCoachSDK.xcframework /path/to/your/project/
```

2. **Add to your Xcode project:**
   - Drag `SmartCoachSDK.xcframework` into your project
   - In your target's **General** tab, under **Frameworks, Libraries, and Embedded Content**
   - Set to **Embed & Sign**

3. **Import and use:**
```swift
   import SmartCoachSDK
   
   try SmartCoach.configure()
```

> **Note:** When using the XCFramework directly, you won't have the documentation integrated into Xcode. We recommend using the package approach (Option 1) for the best development experience.

## 🔑 Configuration

### Add Your API Key

Before using the SDK, add your API key to your app's `Info.plist`:
```xml
<key>SmartCoachAPIKey</key>
<string>YOUR_API_KEY_HERE</string>
```

Your API key was provided in your beta invitation email.

### Add Bluetooth Permissions

Add required Bluetooth permissions to `Info.plist`:
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth to connect to SmartCoach devices</string>
```

## 🐛 Reporting Issues

Found a bug or have feedback? We'd love to hear from you!

### How to Report

1. **Check existing issues** to avoid duplicates
2. **Create a new issue** with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - iOS version and device model
   - Relevant code snippets or screenshots

### What to Include

- SDK version (check `SmartCoachSDK-Package/Package.swift`)
- Xcode version
- iOS version and device
- Sample code demonstrating the issue
- Console logs or error messages

## 💬 Getting Help

- **Documentation:** Build documentation in Xcode (⌃⇧⌘D) for complete guides
- **Sample Code:** Check the sample app for working examples
- **Support:** Email <info@pocketradar.com> for urgent issues
- **Feedback:** Use GitHub Issues for bug reports and feature requests

## 📋 Beta Guidelines

### During Beta

- ✅ Test the SDK thoroughly with your use cases
- ✅ Report any issues or unexpected behavior
- ✅ Provide feedback on API design and documentation
- ✅ Share your integration experiences

### Please Don't

- ❌ Share your API key publicly
- ❌ Distribute the SDK outside of approved testers
- ❌ Submit apps using the beta SDK to the App Store
- ❌ Share beta builds publicly

## 🗺️ Repository Structure
```
ios-smartcoach-sdk-sample/
├── SmartCoachSDK-Package/           # SDK Package
│   ├── Package.swift
│   ├── SmartCoachSDK.xcframework/   # Binary framework
│   └── Sources/
│       └── SmartCoachSDK/
│           ├── SmartCoachSDK.docc/  # Documentation
│           └── SmartCoachSDK.swift
│
└── iOSSmartCoachSDKSample/          # Sample App
    ├── iOSSmartCoachSDKSample.xcodeproj
    └── iOSSmartCoachSDKSample/
```

## 📝 Quick Example

Here's a complete example to get you started:
```swift
import SwiftUI
import SmartCoachSDK

@main
struct MyApp: App {
    init() {
        do {
            try SmartCoach.configure()
        } catch {
            print("Configuration failed: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

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
```

## 🎯 Next Steps

1. ✅ Run the sample app to see the SDK in action
2. ✅ Read the documentation (⌃⇧⌘D in Xcode)
3. ✅ Follow the "Connecting Your First Device" tutorial
4. ✅ Integrate the SDK into your own app
5. ✅ Share your feedback with us!

---

**Thank you for participating in the SmartCoach SDK beta!** 🎉

Your feedback is invaluable in helping us build a great developer experience.
