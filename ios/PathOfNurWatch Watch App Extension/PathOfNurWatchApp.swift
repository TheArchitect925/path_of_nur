import SwiftUI
import UserNotifications
import WatchKit

private enum WatchPrayerReminderNotification {
  static let categoryId = "PRAYER_REMINDER"
  static let markPrayedActionId = "MARK_PRAYED"
  static let markPrayedLateActionId = "MARK_PRAYED_LATE"
  static let snoozeActionId = "SNOOZE"
  static let openAppActionId = "OPEN_APP"
  static let payloadKey = "payload"
}

private struct WatchReminderNotificationPayload {
  let prayerId: String?
  let logicalDate: String?
  let route: String?
  let watchRoute: String?

  var isPrayerReminder: Bool {
    guard let prayerId, !prayerId.isEmpty, let logicalDate, !logicalDate.isEmpty else {
      return false
    }
    return true
  }

  var preferredURL: URL? {
    if let watchRoute, let url = URL(string: watchRoute) {
      return url
    }
    if let prayerId, !prayerId.isEmpty {
      return URL(string: "pathofnurwatch://prayer?prayerId=\(prayerId)")
    }
    return URL(string: "pathofnurwatch://prayer")
  }

  var encoded: String {
    let payload: [String: String] = [
      "prayerId": prayerId ?? "",
      "logicalDate": logicalDate ?? "",
      "route": route ?? "",
      "watchRoute": watchRoute ?? "",
    ]
    guard let data = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
      return "{}"
    }
    return String(decoding: data, as: UTF8.self)
  }

  static func decode(from userInfo: [AnyHashable: Any]) -> WatchReminderNotificationPayload? {
    guard let rawPayload = userInfo[WatchPrayerReminderNotification.payloadKey] as? String,
          let data = rawPayload.data(using: .utf8),
          let decoded = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      return nil
    }
    return WatchReminderNotificationPayload(
      prayerId: decoded["prayerId"] as? String,
      logicalDate: decoded["logicalDate"] as? String,
      route: decoded["route"] as? String,
      watchRoute: decoded["watchRoute"] as? String
    )
  }
}

final class WatchPrayerNotificationCoordinator: NSObject, UNUserNotificationCenterDelegate {
  static let shared = WatchPrayerNotificationCoordinator()

  private enum PendingAction {
    case route(URL)
    case markPrayed(String)
    case markPrayedLate(String)
    case snooze(WatchReminderNotificationPayload)
  }

  private weak var model: WatchAppModel?
  private let center = UNUserNotificationCenter.current()
  private var pendingActions: [PendingAction] = []

  @MainActor
  func configure(model: WatchAppModel) {
    self.model = model
    center.delegate = self
    center.setNotificationCategories([
      UNNotificationCategory(
        identifier: WatchPrayerReminderNotification.categoryId,
        actions: [
          UNNotificationAction(
            identifier: WatchPrayerReminderNotification.markPrayedActionId,
            title: WatchStrings.notificationActionMarkPrayed,
            options: [.foreground]
          ),
          UNNotificationAction(
            identifier: WatchPrayerReminderNotification.markPrayedLateActionId,
            title: WatchStrings.notificationActionMarkPrayedLate,
            options: [.foreground]
          ),
          UNNotificationAction(
            identifier: WatchPrayerReminderNotification.snoozeActionId,
            title: WatchStrings.notificationActionSnooze,
            options: [.foreground]
          ),
          UNNotificationAction(
            identifier: WatchPrayerReminderNotification.openAppActionId,
            title: WatchStrings.notificationActionOpen,
            options: [.foreground]
          ),
        ],
        intentIdentifiers: [],
        options: []
      ),
    ])
    flushPendingActions()
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    guard let payload = WatchReminderNotificationPayload.decode(
      from: response.notification.request.content.userInfo
    ) else {
      completionHandler()
      return
    }

    Task { @MainActor in
      switch response.actionIdentifier {
      case WatchPrayerReminderNotification.markPrayedActionId:
        runOrQueue(.markPrayed(payload.prayerId ?? ""))
      case WatchPrayerReminderNotification.markPrayedLateActionId:
        runOrQueue(.markPrayedLate(payload.prayerId ?? ""))
      case WatchPrayerReminderNotification.snoozeActionId:
        runOrQueue(.snooze(payload))
      case WatchPrayerReminderNotification.openAppActionId,
           UNNotificationDefaultActionIdentifier:
        route(payload.preferredURL)
      default:
        break
      }
      completionHandler()
    }
  }

  @MainActor
  private func scheduleSnooze(for payload: WatchReminderNotificationPayload) {
    guard payload.isPrayerReminder,
          let prayerId = payload.prayerId,
          let logicalDate = payload.logicalDate,
          let model else {
      route(payload.preferredURL)
      return
    }

    let snoozeMinutes = model.prayerReminderSnoozeMinutes
    let identifier = snoozeIdentifier(prayerId: prayerId, logicalDate: logicalDate)
    center.removePendingNotificationRequests(withIdentifiers: [identifier])

    let title = model.prayerState.prayers.first(where: { $0.prayerId == prayerId })?.displayName
      ?? WatchStrings.prayerTitle
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = WatchStrings.notificationPrayerReminderBody
    content.categoryIdentifier = WatchPrayerReminderNotification.categoryId
    content.userInfo = [WatchPrayerReminderNotification.payloadKey: payload.encoded]
    if !model.quietModeEnabled {
      content.sound = .default
    }

    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: TimeInterval(snoozeMinutes * 60),
      repeats: false
    )
    let request = UNNotificationRequest(
      identifier: identifier,
      content: content,
      trigger: trigger
    )
    center.add(request)
    model.logPrayerReminderSnoozeRequested(
      prayerId: prayerId,
      logicalDate: logicalDate,
      minutes: snoozeMinutes
    )
  }

  @MainActor
  private func route(_ url: URL?) {
    guard let url else { return }
    runOrQueue(.route(url))
  }

  @MainActor
  private func runOrQueue(_ action: PendingAction) {
    guard model != nil else {
      pendingActions.append(action)
      return
    }
    perform(action)
  }

  @MainActor
  private func flushPendingActions() {
    guard model != nil, !pendingActions.isEmpty else { return }
    let actions = pendingActions
    pendingActions.removeAll()
    for action in actions {
      perform(action)
    }
  }

  @MainActor
  private func perform(_ action: PendingAction) {
    guard let model else {
      pendingActions.append(action)
      return
    }
    switch action {
    case let .route(url):
      model.handleOpenURL(url)
    case let .markPrayed(prayerId):
      guard !prayerId.isEmpty else { return }
      model.handlePrayerReminderAction(prayerId: prayerId, timing: .onTime)
    case let .markPrayedLate(prayerId):
      guard !prayerId.isEmpty else { return }
      model.handlePrayerReminderAction(prayerId: prayerId, timing: .late)
    case let .snooze(payload):
      scheduleSnooze(for: payload)
    }
  }

  private func snoozeIdentifier(prayerId: String, logicalDate: String) -> String {
    "watch.prayer.\(prayerId).snooze.\(logicalDate)"
  }
}

final class WatchExtensionDelegate: NSObject, WKApplicationDelegate {
  func applicationDidFinishLaunching() {
    UNUserNotificationCenter.current().delegate = WatchPrayerNotificationCoordinator.shared
  }
}

@main
struct PathOfNurWatchApp: App {
  @WKApplicationDelegateAdaptor(WatchExtensionDelegate.self) private var extensionDelegate
  @StateObject private var model = WatchAppModel()
  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      WatchRootView()
        .environmentObject(model)
        .task {
          WatchPrayerNotificationCoordinator.shared.configure(model: model)
        }
        .onOpenURL { url in
          model.handleOpenURL(url)
        }
    }
    .onChange(of: scenePhase) { _, phase in
      model.handleScenePhase(phase)
    }
  }
}
