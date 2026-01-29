# Device Discovery

Learn how to scan for and connect to SmartCoach radar devices.

## Overview

Device discovery is the process of scanning for nearby SmartCoach devices via Bluetooth and establishing a connection. The SDK provides simple methods to handle the entire discovery and connection workflow.

## Scanning for Devices

Start scanning for nearby SmartCoach devices:

```swift
do {
    try await SmartCoach.startScanning()
    print("Scanning for devices...")
} catch {
    print("Failed to start scanning: \(error)")
}
```

### Auto-Connect to Last Device

If you want to automatically connect to the previously paired device:

```swift
try await SmartCoach.startScanning(connectToLastPairedDevice: true)
```

This is useful for:
- Returning users who have already paired a device
- Apps with single-device workflows
- Minimizing user friction in the connection process

## Stopping a Scan

Stop scanning when you no longer need to discover devices:

```swift
do {
    try await SmartCoach.stopScanning()
    print("Stopped scanning")
} catch {
    print("Failed to stop scanning: \(error)")
}
```

**Best Practice**: Always stop scanning once you've found and connected to a device to conserve battery.

## Connecting to a Device

Once you have a ``SmartCoachRadar`` device reference (typically from your device discovery UI), connect to it:

```swift
let device: SmartCoachRadar = selectedDevice

do {
    try await SmartCoach.connect(to: device)
    print("Connected to \(device.name)")
} catch {
    print("Connection failed: \(error)")
}
```

## Disconnecting

Disconnect from the currently connected device:

```swift
await SmartCoach.disconnect()
print("Disconnected from device")
```

> Note: `disconnect()` does not throw errors - it always succeeds.

## Complete Discovery Flow

Here's a complete example showing device discovery and connection:

```swift
@MainActor
class DeviceDiscoveryViewModel: ObservableObject {
    @Published var isScanning = false
    @Published var discoveredDevices: [SmartCoachRadar] = []
    @Published var connectedDevice: SmartCoachRadar?
    
    func startDiscovery() async {
        isScanning = true
        
        do {
            try await SmartCoach.startScanning()
            
            // In a real app, you'd listen for device discovery events
            // and populate discoveredDevices
            
        } catch SmartCoachError.bluetoothNotAvailable {
            print("Bluetooth is not available")
        } catch SmartCoachError.failedToStartScanning {
            print("Failed to start scanning")
        } catch {
            print("Unexpected error: \(error)")
        }
        
        isScanning = false
    }
    
    func connect(to device: SmartCoachRadar) async {
        do {
            // Stop scanning first
            try await SmartCoach.stopScanning()
            
            // Connect to selected device
            try await SmartCoach.connect(to: device)
            
            connectedDevice = device
            print("Successfully connected to \(device.name)")
            
        } catch SmartCoachError.failedToConnect {
            print("Connection failed - device may be out of range")
        } catch {
            print("Connection error: \(error)")
        }
    }
    
    func disconnect() async {
        await SmartCoach.disconnect()
        connectedDevice = nil
        print("Disconnected")
    }
    
    func quickConnect() async {
        do {
            // Automatically connect to last paired device
            try await SmartCoach.startScanning(connectToLastPairedDevice: true)
            print("Reconnected to previous device")
        } catch {
            print("Auto-connect failed: \(error)")
        }
    }
}
```

## Connection States

Monitor connection state changes using the session state stream:

```swift
let stateStream = try await SmartCoach.sessionStateStream()

for await state in stateStream {
    switch state {
    case .disconnected:
        print("Device disconnected")
        
    case .scanning:
        print("Scanning for devices")
        
    case .connecting:
        print("Connecting to device")
        
    case .connected:
        print("Device connected")
        
    case .measuring:
        print("Receiving measurements")
    }
}
```

See <doc:SessionStateManagement> for more details.

## Common Errors

### Bluetooth Not Available

```swift
catch SmartCoachError.bluetoothNotAvailable {
    // Bluetooth is off or not authorized
    // Prompt user to enable Bluetooth in Settings
}
```

### Failed to Start Scanning

```swift
catch SmartCoachError.failedToStartScanning {
    // Scanning couldn't start
    // This might be temporary - retry after a delay
}
```

### Failed to Connect

```swift
catch SmartCoachError.failedToConnect {
    // Device connection failed
    // Device may be out of range or already connected to another device
}
```

## Best Practices

### 1. Stop Scanning After Connection

```swift
// ✅ Good
try await SmartCoach.startScanning()
// User selects device...
try await SmartCoach.stopScanning()
try await SmartCoach.connect(to: selectedDevice)

// ❌ Bad - wastes battery
try await SmartCoach.startScanning()
try await SmartCoach.connect(to: selectedDevice)
// Forgot to stop scanning!
```

### 2. Handle Bluetooth Permissions

Request Bluetooth permissions before scanning:

```swift
import CoreBluetooth

func checkBluetoothPermissions() {
    let manager = CBCentralManager()
    
    switch manager.authorization {
    case .allowedAlways:
        // Ready to scan
        break
    case .denied, .restricted:
        // Show settings prompt
        showBluetoothPermissionAlert()
    case .notDetermined:
        // Will prompt automatically
        break
    @unknown default:
        break
    }
}
```

### 3. Provide Visual Feedback

Show users what's happening during discovery:

```swift
struct ScanningView: View {
    @StateObject var viewModel = DeviceDiscoveryViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isScanning {
                ProgressView("Scanning for devices...")
            }
            
            List(viewModel.discoveredDevices) { device in
                Button(device.name) {
                    Task {
                        await viewModel.connect(to: device)
                    }
                }
            }
        }
    }
}
```

### 4. Auto-Connect for Returning Users

Use auto-connect for better UX with returning users:

```swift
func handleAppLaunch() async {
    if hasConnectedBefore {
        do {
            // Seamlessly reconnect
            try await SmartCoach.startScanning(connectToLastPairedDevice: true)
        } catch {
            // Fall back to manual device selection
            showDeviceSelectionScreen()
        }
    } else {
        showDeviceSelectionScreen()
    }
}
```

### 5. Handle Unexpected Disconnections

React appropriately when connection is lost:

```swift
let stateStream = try await SmartCoach.sessionStateStream()

for await state in stateStream {
    if case .disconnected = state {
        // Connection lost
        if shouldAutoReconnect {
            try? await SmartCoach.startScanning(connectToLastPairedDevice: true)
        } else {
            showReconnectPrompt()
        }
    }
}
```

## See Also

- ``SmartCoach/startScanning(connectToLastPairedDevice:)``
- ``SmartCoach/stopScanning()``
- ``SmartCoach/connect(to:)``
- ``SmartCoach/disconnect()``
- ``SmartCoachRadar``
- <doc:ConnectionManagement>
- <doc:SessionStateManagement>
