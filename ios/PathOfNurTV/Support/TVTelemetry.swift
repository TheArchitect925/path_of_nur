import Foundation

private var tvTelemetryBootstrapUserDefaults: UserDefaults = .standard

private func tvTelemetryHandleUncaughtException(_ exception: NSException) {
  TVTelemetry.recordUncaughtException(
    exception,
    userDefaults: tvTelemetryBootstrapUserDefaults
  )
}

enum TVTelemetry {
  private static let analyticsKey = "PathOfNurTV.diagnostics.analytics.v1"
  private static let crashKey = "PathOfNurTV.diagnostics.crash.v1"
  private static let qualityKey = "PathOfNurTV.diagnostics.quality.v1"
  private static var bootstrapped = false

  static func bootstrap(userDefaults: UserDefaults = .standard) {
    guard !bootstrapped else { return }
    bootstrapped = true
    tvTelemetryBootstrapUserDefaults = userDefaults

    NSSetUncaughtExceptionHandler(tvTelemetryHandleUncaughtException)

    logEvent(
      "tvos_app_bootstrap",
      metadata: [
        "mode": isRunningPreviews ? "preview" : "app",
      ],
      userDefaults: userDefaults
    )
  }

  static func logEvent(
    _ name: String,
    metadata: [String: String] = [:],
    userDefaults: UserDefaults = .standard
  ) {
    append(
      key: analyticsKey,
      maxCount: 120,
      payload: [
        "name": name,
        "atIso": isoNow(),
        "metadata": metadata,
      ],
      userDefaults: userDefaults
    )
  }

  static func logQualityNote(
    _ name: String,
    metadata: [String: String] = [:],
    userDefaults: UserDefaults = .standard
  ) {
    append(
      key: qualityKey,
      maxCount: 80,
      payload: [
        "name": name,
        "atIso": isoNow(),
        "metadata": metadata,
      ],
      userDefaults: userDefaults
    )
  }

  static func recordError(
    _ name: String,
    message: String,
    metadata: [String: String] = [:],
    userDefaults: UserDefaults = .standard
  ) {
    recordCrash(
      type: name,
      message: message,
      metadata: metadata,
      userDefaults: userDefaults
    )
    logQualityNote(
      "tvos_error_recorded",
      metadata: [
        "name": name,
        "message": message,
      ].merging(metadata) { current, _ in current },
      userDefaults: userDefaults
    )
  }

  static func diagnosticsSummary(
    userDefaults: UserDefaults = .standard
  ) -> TVDiagnosticsSummary {
    let analytics = entries(forKey: analyticsKey, userDefaults: userDefaults)
    let crashes = entries(forKey: crashKey, userDefaults: userDefaults)
    let quality = entries(forKey: qualityKey, userDefaults: userDefaults)

    let lastEvent = analytics.first?["name"] as? String ?? tvLocalized("No recent diagnostics events")
    let lastQuality = quality.first?["name"] as? String ?? tvLocalized("No recent quality notes")

    return TVDiagnosticsSummary(
      eyebrow: tvLocalized("Diagnostics"),
      title: tvLocalized("Local analytics and crash safety"),
      subtitle: String(
        format: tvLocalized("Stored events: %d • stored crash reports: %d"),
        analytics.count,
        crashes.count
      ),
      supportingLine: String(
        format: tvLocalized("Latest event: %@. Latest quality note: %@."),
        localizedEventName(lastEvent),
        localizedEventName(lastQuality)
      ),
      chips: [
        tvLocalized("Local only"),
        crashes.isEmpty ? tvLocalized("No stored crashes") : tvLocalized("Crash buffer active"),
        quality.isEmpty ? tvLocalized("QA notes ready") : tvLocalized("Quality notes stored"),
      ]
    )
  }

  private static func recordCrash(
    type: String,
    message: String,
    metadata: [String: String],
    userDefaults: UserDefaults
  ) {
    append(
      key: crashKey,
      maxCount: 40,
      payload: [
        "type": type,
        "message": message,
        "atIso": isoNow(),
        "metadata": metadata,
      ],
      userDefaults: userDefaults
    )
  }

  private static func append(
    key: String,
    maxCount: Int,
    payload: [String: Any],
    userDefaults: UserDefaults
  ) {
    let current = userDefaults.stringArray(forKey: key) ?? []
    guard
      let data = try? JSONSerialization.data(withJSONObject: payload, options: []),
      let string = String(data: data, encoding: .utf8)
    else {
      return
    }
    let next = ([string] + current).prefix(maxCount)
    userDefaults.set(Array(next), forKey: key)
  }

  private static func entries(
    forKey key: String,
    userDefaults: UserDefaults
  ) -> [[String: Any]] {
    let raw = userDefaults.stringArray(forKey: key) ?? []
    return raw.compactMap { item in
      guard
        let data = item.data(using: .utf8),
        let decoded = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      else {
        return nil
      }
      return decoded
    }
  }

  private static func localizedEventName(_ name: String) -> String {
    switch name {
    case "tvos_app_bootstrap":
      return tvLocalized("App bootstrap")
    case "tvos_route_opened":
      return tvLocalized("Route opened")
    case "tvos_profile_switched":
      return tvLocalized("Profile switched")
    case "tvos_settings_changed":
      return tvLocalized("Settings changed")
    case "tvos_listening_mode_opened":
      return tvLocalized("Listening mode opened")
    case "tvos_listening_mode_closed":
      return tvLocalized("Listening mode closed")
    case "tvos_playback_error":
      return tvLocalized("Playback error")
    case "tvos_error_recorded":
      return tvLocalized("Error recorded")
    default:
      return name.replacingOccurrences(of: "_", with: " ")
    }
  }

  private static func isoNow() -> String {
    ISO8601DateFormatter().string(from: Date())
  }

  private static var isRunningPreviews: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }

  fileprivate static func recordUncaughtException(
    _ exception: NSException,
    userDefaults: UserDefaults
  ) {
    recordCrash(
      type: "uncaught_exception",
      message: exception.reason ?? exception.name.rawValue,
      metadata: [
        "name": exception.name.rawValue,
      ],
      userDefaults: userDefaults
    )
  }
}
