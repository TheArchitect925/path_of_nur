import Foundation
import WatchConnectivity

final class WatchSyncService: NSObject, WCSessionDelegate {
  static let cacheDidUpdateNotification = Notification.Name("WatchSyncService.cacheDidUpdate")
  static let reachabilityDidChangeNotification = Notification.Name("WatchSyncService.reachabilityDidChange")

  private enum MessageType {
    static let fetchSnapshot = "fetch_snapshot"
    static let watchAction = "watch_action"
    static let syncNow = "sync_now"
  }

  private enum ContextKey {
    static let snapshot = "snapshot"
    static let settings = "settings"
  }

  private let cacheStore: WatchCacheStore
  private let session: WCSession?

  init(cacheStore: WatchCacheStore) {
    self.cacheStore = cacheStore
    self.session = WCSession.isSupported() ? WCSession.default : nil
    super.init()
    self.session?.delegate = self
    self.session?.activate()
  }

  var isReachable: Bool {
    session?.isReachable == true
  }

  func fetchLatestSnapshot() async -> (WatchDailySnapshotPayload, WatchSettingsPayload?)? {
    guard isReachable else {
      guard let snapshot = cacheStore.loadSnapshot() else { return nil }
      return (snapshot, cacheStore.loadSettings())
    }
    let reply = await sendMessage([ "type": MessageType.fetchSnapshot ])
    guard
      let payload = reply,
      let snapshot = decode(WatchDailySnapshotPayload.self, from: payload["snapshot"])
    else {
      guard let snapshot = cacheStore.loadSnapshot() else { return nil }
      return (snapshot, cacheStore.loadSettings())
    }
    let settings = decodeOptional(WatchSettingsPayload.self, from: payload["settings"])
    cacheStore.saveSnapshot(snapshot)
    if let settings = settings {
      cacheStore.saveSettings(settings)
    }
    return (snapshot, settings)
  }

  func syncNow() async -> (WatchDailySnapshotPayload, WatchSettingsPayload?)? {
    guard isReachable else {
      return await flushPendingActions()
    }
    let reply = await sendMessage([ "type": MessageType.syncNow ])
    guard
      let payload = reply,
      let snapshot = decode(WatchDailySnapshotPayload.self, from: payload["snapshot"])
    else {
      return await fetchLatestSnapshot()
    }
    let settings = decodeOptional(WatchSettingsPayload.self, from: payload["settings"])
    cacheStore.saveSnapshot(snapshot)
    if let settings {
      cacheStore.saveSettings(settings)
    }
    _ = await flushPendingActions()
    return (snapshot, settings)
  }

  @discardableResult
  func sendAction(_ action: WatchActionEnvelopePayload) async -> WatchSyncResponsePayload? {
    guard isReachable else {
      transferInBackground(action)
      enqueue(action)
      return nil
    }
    let reply = await sendMessage([
      "type": MessageType.watchAction,
      "action": action.toDictionary(),
    ])
    guard
      let payload = reply,
      let response = decode(WatchSyncResponsePayload.self, from: payload["response"])
    else {
      transferInBackground(action)
      enqueue(action)
      return nil
    }
    cacheStore.saveSnapshot(response.snapshot)
    removePendingAction(id: action.actionId)
    return response
  }

  func flushPendingActions() async -> (WatchDailySnapshotPayload, WatchSettingsPayload?)? {
    let pending = cacheStore.loadPendingActions()
    guard !pending.isEmpty else {
      if let snapshot = cacheStore.loadSnapshot() {
        return (snapshot, cacheStore.loadSettings())
      }
      return await fetchLatestSnapshot()
    }

    var latestResponse: WatchSyncResponsePayload?
    for action in pending {
      if let response = await sendAction(action) {
        latestResponse = response
      }
    }

    if let response = latestResponse {
      return (response.snapshot, cacheStore.loadSettings())
    }
    guard let snapshot = cacheStore.loadSnapshot() else { return nil }
    return (snapshot, cacheStore.loadSettings())
  }

  private func enqueue(_ action: WatchActionEnvelopePayload) {
    var pending = cacheStore.loadPendingActions()
    if pending.contains(where: { $0.actionId == action.actionId }) {
      return
    }
    pending.append(action)
    cacheStore.savePendingActions(pending)
  }

  private func removePendingAction(id: String) {
    let pending = cacheStore.loadPendingActions().filter { $0.actionId != id }
    cacheStore.savePendingActions(pending)
  }

  private func sendMessage(_ message: [String: Any]) async -> [String: Any]? {
    guard let session else { return nil }
    return await withCheckedContinuation { continuation in
      session.sendMessage(message) { reply in
        continuation.resume(returning: reply)
      } errorHandler: { _ in
        continuation.resume(returning: nil)
      }
    }
  }

  private func transferInBackground(_ action: WatchActionEnvelopePayload) {
    guard let session else { return }
    guard session.activationState == .activated else { return }
    session.transferUserInfo([
      "action": action.toDictionary(),
    ])
  }

  private func decode<T: Decodable>(_ type: T.Type, from value: Any?) -> T? {
    guard let value else { return nil }
    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: value) else { return nil }
    return try? WatchCodec.decoder.decode(type, from: data)
  }

  private func decodeOptional<T: Decodable>(_ type: T.Type, from value: Any?) -> T? {
    decode(type, from: value)
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    NotificationCenter.default.post(name: Self.reachabilityDidChangeNotification, object: nil)
    if !session.receivedApplicationContext.isEmpty {
      ingestContext(session.receivedApplicationContext)
    }
  }

  func sessionReachabilityDidChange(_ session: WCSession) {
    NotificationCenter.default.post(name: Self.reachabilityDidChangeNotification, object: nil)
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    ingestContext(applicationContext)
  }

  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    ingestContext(userInfo)
  }

  private func ingestContext(_ context: [String: Any]) {
    var updated = false
    if let snapshot = decode(WatchDailySnapshotPayload.self, from: context[ContextKey.snapshot]) {
      cacheStore.saveSnapshot(snapshot)
      updated = true
    }
    if let settings = decodeOptional(WatchSettingsPayload.self, from: context[ContextKey.settings]) {
      cacheStore.saveSettings(settings)
      updated = true
    }
    if updated {
      NotificationCenter.default.post(name: Self.cacheDidUpdateNotification, object: nil)
    }
  }
}
