# SmartCoachSDK Documentation

This package contains comprehensive DocC documentation for the SmartCoachSDK.

## 📦 Package Contents

### Root Documentation
- `SmartCoachSDK.md` - Main landing page with overview and topic organization

### Getting Started Guides
- `GettingStarted.md` - Installation and quick start guide
- `Configuration.md` - SDK configuration and setup
- `ErrorHandling.md` - Comprehensive error handling guide

### Core Guides
- `DeviceDiscovery.md` - Scanning and discovering devices
- `ConnectionManagement.md` - Advanced connection patterns
- `SessionStateManagement.md` - Monitoring state changes
- `AutoReconnect.md` - Automatic reconnection strategies

### Reference
- `CommonErrors.md` - Quick troubleshooting reference
- `BestPractices.md` - Recommended patterns and practices

### Tutorials
- `ConnectingYourFirstDevice.tutorial` - Step-by-step device connection
- `StreamingMeasurementData.tutorial` - Real-time measurement display

## 🚀 Installation Instructions

### Step 1: Create Documentation Catalog

1. Open your **SmartCoachSDK project** (not the sample app)
2. Select your framework target
3. Go to **File → New → File**
4. Search for "**Documentation Catalog**"
5. Name it `SmartCoachSDK.docc`
6. Make sure it's added to your framework target

### Step 2: Add Documentation Files

1. Copy all `.md` and `.tutorial` files into the `SmartCoachSDK.docc` folder
2. The structure should look like:
   ```
   SmartCoachSDK.xcframework/
   └── SmartCoachSDK.docc/
       ├── SmartCoachSDK.md (root)
       ├── GettingStarted.md
       ├── Configuration.md
       ├── ErrorHandling.md
       ├── DeviceDiscovery.md
       ├── ConnectionManagement.md
       ├── SessionStateManagement.md
       ├── AutoReconnect.md
       ├── CommonErrors.md
       ├── BestPractices.md
       ├── ConnectingYourFirstDevice.tutorial
       └── StreamingMeasurementData.tutorial
   ```

### Step 3: Add Documentation Comments to Public API

Add inline documentation to your public Swift files:

```swift
/// A powerful SDK for integrating SmartCoach devices.
///
/// Use ``SmartCoach`` to configure the SDK, scan for devices,
/// and receive measurement data.
///
/// ## Topics
///
/// ### Configuration
/// - ``configure(deviceConfigurationOptions:)``
///
/// ### Device Management
/// - ``startScanning(connectToLastPairedDevice:)``
/// - ``connect(to:)``
/// - ``disconnect()``
@MainActor
public enum SmartCoach {
    /// Configures the SmartCoach SDK.
    ///
    /// Call this method once at app launch before using any other SDK features.
    ///
    /// - Parameter deviceConfigurationOptions: Configuration options for device behavior.
    ///   Pass `nil` to use default settings.
    ///
    /// - Throws: ``SmartCoachError`` if configuration fails.
    ///
    /// ## Example
    /// ```swift
    /// do {
    ///     try SmartCoach.configure()
    /// } catch {
    ///     print("Configuration failed: \(error)")
    /// }
    /// ```
    public static func configure(deviceConfigurationOptions: SmartCoachDeviceConfigurationOptions? = nil) throws {
        // Implementation
    }
}
```

### Step 4: Build Documentation

1. In Xcode, select **Product → Build Documentation** (⌃⇧⌘D)
2. Wait for the build to complete
3. Xcode will open the Documentation Browser with your docs

### Step 5: Export Documentation Archive (Optional)

To share documentation or host it online:

1. After building, find the `.doccarchive` file in your build products:
   - Go to **Product → Show Build Folder in Finder**
   - Navigate to the `.doccarchive` file
2. Copy this file to distribute with your SDK
3. Users can double-click to open in Xcode

## 📖 Viewing Documentation

### In Xcode (Developers using your SDK)

1. **Quick Help** - Option-click any SmartCoach symbol
2. **Documentation Browser** - Press ⌘⇧0 and search for "SmartCoach"
3. **Code Completion** - Documentation appears automatically while typing

### Online Hosting (Optional)

Host documentation as a website:

1. Build documentation as described above
2. Use Xcode's built-in hosting or a static site generator
3. Deploy to your web server or GitHub Pages

## 🎯 What Users Will See

When developers use your SDK, they'll see:

### 1. Landing Page
Beautiful overview with organized topics and links to guides

### 2. Step-by-Step Tutorials
- Connecting Your First Device (15 min)
- Streaming Measurement Data (20 min)

### 3. Comprehensive Guides
- Getting Started
- Configuration
- Error Handling
- Device Discovery
- Connection Management
- Session State Management
- Auto-Reconnect
- Best Practices

### 4. Quick Reference
- Common Errors troubleshooting guide
- Complete error code reference

### 5. API Documentation
Full documentation for all public types and methods with:
- Descriptions
- Parameters
- Return values
- Throws information
- Code examples
- Related articles

## 💡 Customization Tips

### Add Your Own Branding

Edit `SmartCoachSDK.md` to include:
- Company information
- Support links
- Version information
- License details

### Add Images

Create a `Resources` folder in `.docc`:

```
SmartCoachSDK.docc/
├── Resources/
│   ├── hero-image.png
│   ├── connection-flow.png
│   └── measurement-screenshot.png
└── SmartCoachSDK.md
```

Reference in markdown:
```markdown
![Connection Flow](connection-flow.png)
```

### Add More Tutorials

Create new `.tutorial` files following the same structure as the examples.

### Add Code Snippets

Create code snippet files in a `Resources` folder for use in tutorials:

```
Resources/
├── step1.swift
├── step2.swift
└── step3.swift
```

## 🔧 Troubleshooting

### Documentation not showing in Xcode

1. Clean build folder: **Product → Clean Build Folder**
2. Rebuild documentation: **Product → Build Documentation**
3. Ensure `.docc` is in the framework target, not sample app

### Links not working

- Use `<doc:ArticleName>` for article links
- Use `` ``SymbolName`` `` for API symbol links
- Check file names match exactly (case-sensitive)

### Images not showing

- Images must be in `Resources` folder inside `.docc`
- Use relative paths: `![Alt text](image-name.png)`
- Supported formats: PNG, JPG, GIF, SVG

## 📚 Resources

- [Apple's DocC Documentation](https://developer.apple.com/documentation/docc)
- [DocC Tutorial](https://developer.apple.com/documentation/docc/tutorial-syntax)
- [Writing Great Documentation](https://developer.apple.com/documentation/docc/writing-symbol-documentation-in-your-source-files)

## 🤝 Contributing

To update or add documentation:

1. Edit the markdown files in `SmartCoachSDK.docc`
2. Rebuild documentation to preview changes
3. Update inline code comments for API documentation
4. Test all links and examples

## ✅ Next Steps

1. ✅ Add these files to your SDK's `.docc` catalog
2. ✅ Add inline documentation comments to your public API
3. ✅ Build and review the documentation
4. ✅ Share the `.doccarchive` with SDK consumers
5. ✅ Consider hosting documentation online

---

**Need help?** Open an issue or contact support at [support@smartcoach.com](mailto:support@smartcoach.com)
