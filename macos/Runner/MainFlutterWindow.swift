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
    case "backupFileMetadata":
      guard let args = call.arguments as? [String: Any],
            let path = args["path"] as? String else {
        result(FlutterError(code: "bad_args", message: "Expected path", details: nil))
        return
      }
      result(iCloudBackupFileMetadata(path: path))
    case "readBackupFile":
      guard let args = call.arguments as? [String: Any],
            let path = args["path"] as? String else {
        result(FlutterError(code: "bad_args", message: "Expected path", details: nil))
        return
      }
      result(readICloudBackupFile(path: path))
    case "writeBackupFile":
      guard let args = call.arguments as? [String: Any],
            let path = args["path"] as? String,
            let value = args["value"] as? String else {
        result(FlutterError(code: "bad_args", message: "Expected path/value", details: nil))
        return
      }
      result(writeICloudBackupFile(path: path, value: value))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func iCloudBackupBaseUrl() -> URL? {
    return FileManager.default
      .url(forUbiquityContainerIdentifier: nil)?
      .appendingPathComponent("Documents", isDirectory: true)
  }

  private func iCloudBackupFileUrl(path: String) -> URL? {
    return iCloudBackupBaseUrl()?.appendingPathComponent(path)
  }

  private func iCloudBackupFileMetadata(path: String) -> [String: Any] {
    guard let fileUrl = iCloudBackupFileUrl(path: path) else {
      return ["exists": false]
    }
    let exists = FileManager.default.fileExists(atPath: fileUrl.path)
    guard exists else { return ["exists": false] }
    let attributes = try? FileManager.default.attributesOfItem(atPath: fileUrl.path)
    let modifiedAt = attributes?[.modificationDate] as? Date
    let size = attributes?[.size] as? NSNumber
    let content = try? String(contentsOf: fileUrl, encoding: .utf8)
    let decoded = content.flatMap { try? JSONSerialization.jsonObject(with: Data($0.utf8)) as? [String: Any] }
    let metadata = decoded?["metadata"] as? [String: Any]
    let scopeSummary = metadata?["scopeSummary"] as? [String: Any]
    return [
      "exists": true,
      "path": path,
      "updatedAtIso": modifiedAt?.ISO8601Format() ?? "",
      "sizeBytes": size?.intValue ?? 0,
      "schemaVersion": metadata?["schemaVersion"] as? Int ?? 0,
      "appVersion": metadata?["appVersion"] as? String ?? "",
      "buildNumber": metadata?["buildNumber"] as? String ?? "",
      "createdAtIso": metadata?["exportedAtIso"] as? String ?? "",
      "deviceLabel": metadata?["deviceLabel"] as? String ?? "",
      "accountLabel": metadata?["accountLabel"] as? String ?? "",
      "scopeSummary": scopeSummary ?? [:],
      "checksum": metadata?["checksum"] as? String ?? "",
    ]
  }

  private func readICloudBackupFile(path: String) -> String? {
    guard let fileUrl = iCloudBackupFileUrl(path: path) else { return nil }
    return try? String(contentsOf: fileUrl, encoding: .utf8)
  }

  private func writeICloudBackupFile(path: String, value: String) -> Bool {
    guard let fileUrl = iCloudBackupFileUrl(path: path) else { return false }
    let directory = fileUrl.deletingLastPathComponent()
    do {
      try FileManager.default.createDirectory(
        at: directory,
        withIntermediateDirectories: true,
        attributes: nil
      )
      try value.write(to: fileUrl, atomically: true, encoding: .utf8)
      return true
    } catch {
      return false
    }
  }
}
