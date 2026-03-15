import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private let iCloudSyncChannelName = "path_of_nur/icloud_sync"

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    let iCloudSyncChannel = FlutterMethodChannel(
      name: iCloudSyncChannelName,
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    iCloudSyncChannel.setMethodCallHandler { call, result in
      self.handleICloudSyncCall(call: call, result: result)
    }

    super.awakeFromNib()
  }

  private func handleICloudSyncCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let store = NSUbiquitousKeyValueStore.default
    switch call.method {
    case "isAvailable":
      result(FileManager.default.ubiquityIdentityToken != nil)
    case "readValue":
      guard let args = call.arguments as? [String: Any],
            let key = args["key"] as? String else {
        result(FlutterError(code: "bad_args", message: "Expected key", details: nil))
        return
      }
      store.synchronize()
      result(store.string(forKey: key))
    case "writeValue":
      guard let args = call.arguments as? [String: Any],
            let key = args["key"] as? String,
            let value = args["value"] as? String else {
        result(FlutterError(code: "bad_args", message: "Expected key/value", details: nil))
        return
      }
      store.set(value, forKey: key)
      result(store.synchronize())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
