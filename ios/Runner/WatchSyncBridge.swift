import Foundation
import WatchConnectivity
import Flutter

final class WatchPhoneCacheStore {
  private enum Key {
    static let snapshot = "watch.phone.snapshot.v1"
    static let settings = "watch.phone.settings.v1"
    static let pendingActions = "watch.phone.pending_actions.v1"
  }

  private let defaults = UserDefaults.standard

  func saveSnapshot(_ payload: [String: Any]) {
    if let sanitized = sanitizeDictionary(payload) {
      defaults.set(sanitized, forKey: Key.snapshot)
    } else {
      defaults.removeObject(forKey: Key.snapshot)
    }
  }

  func saveSettings(_ payload: [String: Any]) {
    if let sanitized = sanitizeDictionary(payload) {
      defaults.set(sanitized, forKey: Key.settings)
    } else {
      defaults.removeObject(forKey: Key.settings)
    }
  }

  func snapshot() -> [String: Any]? {
    defaults.dictionary(forKey: Key.snapshot)
  }

  func settings() -> [String: Any]? {
    defaults.dictionary(forKey: Key.settings)
  }

  func pendingActions() -> [[String: Any]] {
    defaults.array(forKey: Key.pendingActions) as? [[String: Any]] ?? []
  }

  func appendPendingAction(_ payload: [String: Any]) {
    var next = pendingActions()
    guard let actionId = payload["actionId"] as? String,
          !next.contains(where: { ($0["actionId"] as? String) == actionId }) else {
      return
    }
    guard let sanitized = sanitizeDictionary(payload) else {
      return
    }
    next.append(sanitized)
    defaults.set(next, forKey: Key.pendingActions)
  }

  func acknowledgePendingActionIds(_ actionIds: [String]) {
    let remaining = pendingActions().filter { row in
      guard let actionId = row["actionId"] as? String else { return true }
      return !actionIds.contains(actionId)
    }
    defaults.set(remaining, forKey: Key.pendingActions)
  }

  func syncPayload() -> [String: Any] {
    var payload: [String: Any] = [:]
    if let snapshot = snapshot() {
      payload["snapshot"] = snapshot
    }
    if let settings = settings() {
      payload["settings"] = settings
    }
    return payload
  }

  private func sanitizeDictionary(_ payload: [String: Any]) -> [String: Any]? {
    let sanitized = payload.reduce(into: [String: Any]()) { partialResult, entry in
      guard let value = sanitizeValue(entry.value) else { return }
      partialResult[entry.key] = value
    }
    return sanitized.isEmpty ? nil : sanitized
  }

  private func sanitizeValue(_ value: Any?) -> Any? {
    guard let value else { return nil }

    switch value {
    case let string as String:
      return string
    case let number as NSNumber:
      return number
    case let date as Date:
      return date
    case let data as Data:
      return data
    case let dictionary as [String: Any]:
      return sanitizeDictionary(dictionary)
    case let dictionary as [AnyHashable: Any]:
      var normalized: [String: Any] = [:]
      for (key, nestedValue) in dictionary {
        let stringKey = String(describing: key)
        guard let sanitizedValue = sanitizeValue(nestedValue) else { continue }
        normalized[stringKey] = sanitizedValue
      }
      return normalized.isEmpty ? nil : normalized
    case let array as [Any]:
      let sanitized = array.compactMap(sanitizeValue)
      return sanitized.isEmpty ? nil : sanitized
    case is NSNull:
      return nil
    default:
      return String(describing: value)
    }
  }
}

final class WatchPhoneConnectivityBridge: NSObject, WCSessionDelegate {
  private enum MessageType {
    static let fetchSnapshot = "fetch_snapshot"
    static let watchAction = "watch_action"
    static let syncNow = "sync_now"
  }

  private let cacheStore: WatchPhoneCacheStore
  private weak var channel: FlutterMethodChannel?
  private let session: WCSession?

  init(cacheStore: WatchPhoneCacheStore) {
    self.cacheStore = cacheStore
    self.session = WCSession.isSupported() ? WCSession.default : nil
    super.init()
    self.session?.delegate = self
  }

  func attach(channel: FlutterMethodChannel) {
    self.channel = channel
    session?.activate()
    publishLatestContext()
  }

  func publishLatestContext() {
    guard let session else { return }
    guard session.activationState == .activated else { return }
    let payload = cacheStore.syncPayload()
    guard !payload.isEmpty else { return }
    do {
      try session.updateApplicationContext(payload)
    } catch {
      // Best-effort push. Interactive pull remains available.
    }
    if session.isComplicationEnabled && session.remainingComplicationUserInfoTransfers > 0 {
      session.transferCurrentComplicationUserInfo(payload)
    }
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    publishLatestContext()
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    session.activate()
  }

  func session(
    _ session: WCSession,
    didReceiveMessage message: [String : Any],
    replyHandler: @escaping ([String : Any]) -> Void
  ) {
    handle(message: message, replyHandler: replyHandler)
  }

  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    if let action = userInfo["action"] as? [String: Any] {
      cacheStore.appendPendingAction(action)
    }
  }

  private func handle(
    message: [String: Any],
    replyHandler: @escaping ([String: Any]) -> Void
  ) {
    switch message["type"] as? String {
    case MessageType.fetchSnapshot, MessageType.syncNow:
      requestLatestPayload(replyHandler: replyHandler)
    case MessageType.watchAction:
      guard let action = message["action"] as? [String: Any] else {
        replyHandler([
          "accepted": false,
          "snapshot": cacheStore.snapshot() ?? [:],
          "settings": cacheStore.settings() ?? [:],
        ])
        return
      }
      ingestWatchAction(action, replyHandler: replyHandler)
    default:
      replyHandler([
        "accepted": false,
        "snapshot": cacheStore.snapshot() ?? [:],
        "settings": cacheStore.settings() ?? [:],
      ])
    }
  }

  private func requestLatestPayload(replyHandler: @escaping ([String: Any]) -> Void) {
    guard let channel else {
      replyHandler([
        "snapshot": cacheStore.snapshot() ?? [:],
        "settings": cacheStore.settings() ?? [:],
      ])
      return
    }

    channel.invokeMethod("requestLatestWatchSnapshot", arguments: nil) { [weak self] result in
      guard let self else { return }
      if let payload = result as? [String: Any] {
        if let snapshot = payload["snapshot"] as? [String: Any] {
          cacheStore.saveSnapshot(snapshot)
        }
        if let settings = payload["settings"] as? [String: Any] {
          cacheStore.saveSettings(settings)
        }
        publishLatestContext()
        replyHandler(payload)
        return
      }
      replyHandler([
        "snapshot": cacheStore.snapshot() ?? [:],
        "settings": cacheStore.settings() ?? [:],
      ])
    }
  }

  private func ingestWatchAction(
    _ action: [String: Any],
    replyHandler: @escaping ([String: Any]) -> Void
  ) {
    guard let channel else {
      cacheStore.appendPendingAction(action)
      replyHandler([
        "accepted": true,
        "queued": true,
        "snapshot": cacheStore.snapshot() ?? [:],
        "settings": cacheStore.settings() ?? [:],
      ])
      return
    }

    channel.invokeMethod("ingestWatchAction", arguments: action) { [weak self] result in
      guard let self else { return }
      if let response = result as? [String: Any] {
        if let snapshot = response["snapshot"] as? [String: Any] {
          cacheStore.saveSnapshot(snapshot)
        }
        if let settings = response["settings"] as? [String: Any] {
          cacheStore.saveSettings(settings)
        }
        publishLatestContext()
        replyHandler([
          "accepted": true,
          "queued": false,
          "response": response,
          "snapshot": cacheStore.snapshot() ?? [:],
          "settings": cacheStore.settings() ?? [:],
        ])
        return
      }

      cacheStore.appendPendingAction(action)
      replyHandler([
        "accepted": true,
        "queued": true,
        "snapshot": cacheStore.snapshot() ?? [:],
        "settings": cacheStore.settings() ?? [:],
      ])
    }
  }
}
