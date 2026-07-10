# SmartCoach iOS SDK Sample App

This repository contains a sample app demonstrating how to integrate and use the [Pocket Radar SmartCoach SDK](https://github.com/pocketradar/smartcoach-ios-sdk) in an iOS application.

> **This SDK is currently in beta.** Please do not submit apps using the beta SDK to the App Store.

## Requirements

- Xcode 26.0 or later (the SDK package manifest uses Swift tools 6.2)
- An iOS 18.0 or later **physical device** for live scanning and measuring — the app
  builds and runs on the Simulator, but Bluetooth is unavailable there
- A valid Pocket Radar API key

## What This Sample Shows

The app boots into a full working example (`FullWorkflowView` / `FullWorkflowViewModel`)
demonstrating the SDK's canonical integration pattern:

- One async `startMonitoring()` loop observing `SmartCoach.sessionStateStream()`,
  driven by the view's `.task` modifier — all UI state derives from the stream
- Scanning, connecting, live speed streaming, and disconnecting, with the
  wait-for-`.connected` sequencing the SDK requires
- Error surfacing via the `.disconnected(error)` state and thrown `SmartCoachError`s

## Getting an API Key

API keys are issued only to approved Pocket Radar partners. If you don't have one, contact:

**[partners@pocketradar.com](mailto:partners@pocketradar.com)**

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/pocketradar/ios-smartcoach-sdk-sample
cd ios-smartcoach-sdk-sample
```

### 2. Open the project

```bash
open iOSSmartCoachSDKSample.xcodeproj
```

### 3. Add your API key

The project ships without an API key — you must add your own before building. In `Info.plist` replace `YOUR_API_KEY_HERE` with your key:

```xml
<key>SmartCoachAPIKey</key>
<string>YOUR_API_KEY_HERE</string>
```

> **Never commit your API key to source control.**

### 4. Build and run

- Select your target device or simulator
- Press `⌘R` to build and run
- The SDK package will resolve automatically via Swift Package Manager

## Documentation

The SDK includes comprehensive DocC documentation bundled directly in the package. Once the project builds, documentation is available in Xcode's Documentation Browser.

**Build Documentation:** `⌃⇧⌘D` or **Product → Build Documentation**

**Browse Documentation:** `⌘⇧0` to open the Documentation Browser, then search for "SmartCoach"

**Quick Help:** Option-click any SmartCoach type or method for inline documentation

## SDK Repository

The SmartCoach SDK is available at:

**[https://github.com/pocketradar/smartcoach-ios-sdk](https://github.com/pocketradar/smartcoach-ios-sdk)**

For SDK installation instructions, API reference, and integration guides see the SDK repository. It also ships **agent skills** — recipes that let an AI coding assistant (Claude Code today) integrate SDK capabilities into your own app; see the SDK repository's "AI-Assisted Integration" section.

## Feedback & Reporting Issues

Please use [GitHub Issues](https://github.com/pocketradar/ios-smartcoach-sdk-sample/issues) to report bugs or issues with the sample app. For SDK-specific issues please open an issue in the [SDK repository](https://github.com/pocketradar/smartcoach-ios-sdk/issues).

For urgent support contact [partners@pocketradar.com](mailto:partners@pocketradar.com).
