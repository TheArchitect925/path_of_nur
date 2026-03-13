import ActivityKit
import Flutter
import UIKit

@available(iOS 16.1, *)
struct PrayerCountdownAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var showCurrentPrayer: Bool
    var currentPrayerId: String?
    var currentPrayerName: String?
    var currentPrayerArabicName: String?
    var currentRemainingSeconds: Int?
    var showRamadanCountdown: Bool
    var ramadanPrayerId: String?
    var ramadanPrayerName: String?
    var ramadanPrayerArabicName: String?
    var ramadanRemainingSeconds: Int?
    var ramadanTargetAtEpoch: Int?
    var nextPrayerId: String
    var nextPrayerName: String
    var nextPrayerArabicName: String
    var nextRemainingSeconds: Int
    var nextTargetAtEpoch: Int
  }

  var nextPrayerId: String
  var nextPrayerName: String
}

@available(iOS 16.1, *)
struct QuranPlaybackAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var surahNumber: Int
    var surahName: String
    var surahArabicName: String
    var ayahNumber: Int
    var reciterName: String
    var isPlaying: Bool
    var elapsedSeconds: Int
    var totalSeconds: Int
  }

  var sessionId: String
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let liveActivityChannelName = "path_of_nur/live_activities"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let registrar = self.registrar(forPlugin: "PathOfNurLiveActivityBridge") {
      let channel = FlutterMethodChannel(
        name: liveActivityChannelName,
        binaryMessenger: registrar.messenger()
      )
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handleLiveActivityCall(call: call, result: result)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func handleLiveActivityCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isSupported":
      if #available(iOS 16.1, *) {
        result(ActivityAuthorizationInfo().areActivitiesEnabled)
      } else {
        result(false)
      }
    case "updatePrayerCountdown":
      if #available(iOS 16.1, *) {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "bad_args", message: "Expected dictionary", details: nil))
          return
        }
        updatePrayerCountdown(args: args, result: result)
      } else {
        result(false)
      }
    case "endPrayerCountdown":
      if #available(iOS 16.1, *) {
        Task {
          await endPrayerActivities()
          result(true)
        }
      } else {
        result(false)
      }
    case "updateQuranPlayback":
      if #available(iOS 16.1, *) {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "bad_args", message: "Expected dictionary", details: nil))
          return
        }
        updateQuranPlayback(args: args, result: result)
      } else {
        result(false)
      }
    case "endQuranPlayback":
      if #available(iOS 16.1, *) {
        Task {
          await endQuranActivities()
          result(true)
        }
      } else {
        result(false)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @available(iOS 16.1, *)
  private func updatePrayerCountdown(args: [String: Any], result: @escaping FlutterResult) {
    let showCurrentPrayer = (args["showCurrentPrayer"] as? Bool) ?? false
    let currentPrayerId = args["currentPrayerId"] as? String
    let currentPrayerName = args["currentPrayerName"] as? String
    let currentPrayerArabicName = args["currentPrayerArabicName"] as? String
    let rawCurrentRemaining = args["currentRemainingSeconds"] as? Int
    let currentRemainingSeconds = rawCurrentRemaining == nil
      ? nil
      : max(0, rawCurrentRemaining ?? 0)
    let showRamadanCountdown = (args["showRamadanCountdown"] as? Bool) ?? false
    let ramadanPrayerId = args["ramadanPrayerId"] as? String
    let ramadanPrayerName = args["ramadanPrayerName"] as? String
    let ramadanPrayerArabicName = args["ramadanPrayerArabicName"] as? String
    let rawRamadanRemaining = args["ramadanRemainingSeconds"] as? Int
    let ramadanRemainingSeconds = rawRamadanRemaining == nil
      ? nil
      : max(0, rawRamadanRemaining ?? 0)
    let ramadanTargetAtIso = args["ramadanTargetAtIso"] as? String
    let ramadanTargetAt = ramadanTargetAtIso.flatMap { ISO8601DateFormatter().date(from: $0) }
    let ramadanTargetAtEpoch = ramadanTargetAt.map { Int($0.timeIntervalSince1970) }

    let nextPrayerId = (args["nextPrayerId"] as? String) ?? "prayer"
    let nextPrayerName = (args["nextPrayerName"] as? String) ?? "Prayer"
    let nextPrayerArabicName = (args["nextPrayerArabicName"] as? String) ?? ""
    let nextRemainingSeconds = max(0, (args["nextRemainingSeconds"] as? Int) ?? 0)
    let nextTargetAtIso = (args["nextTargetAtIso"] as? String) ?? ""
    let nextTargetAt = ISO8601DateFormatter().date(from: nextTargetAtIso)
      ?? Date().addingTimeInterval(TimeInterval(nextRemainingSeconds))
    let nextTargetAtEpoch = Int(nextTargetAt.timeIntervalSince1970)

    let contentState = PrayerCountdownAttributes.ContentState(
      showCurrentPrayer: showCurrentPrayer,
      currentPrayerId: currentPrayerId,
      currentPrayerName: currentPrayerName,
      currentPrayerArabicName: currentPrayerArabicName,
      currentRemainingSeconds: currentRemainingSeconds,
      showRamadanCountdown: showRamadanCountdown,
      ramadanPrayerId: ramadanPrayerId,
      ramadanPrayerName: ramadanPrayerName,
      ramadanPrayerArabicName: ramadanPrayerArabicName,
      ramadanRemainingSeconds: ramadanRemainingSeconds,
      ramadanTargetAtEpoch: ramadanTargetAtEpoch,
      nextPrayerId: nextPrayerId,
      nextPrayerName: nextPrayerName,
      nextPrayerArabicName: nextPrayerArabicName,
      nextRemainingSeconds: nextRemainingSeconds,
      nextTargetAtEpoch: nextTargetAtEpoch
    )

    Task {
      do {
        if let existing = Activity<PrayerCountdownAttributes>.activities.first {
          await existing.update(using: contentState)
          result(true)
          return
        }

        let attributes = PrayerCountdownAttributes(
          nextPrayerId: nextPrayerId,
          nextPrayerName: nextPrayerName
        )
        _ = try Activity.request(
          attributes: attributes,
          contentState: contentState,
          pushType: nil
        )
        result(true)
      } catch {
        result(
          FlutterError(
            code: "live_activity_error",
            message: "Unable to update prayer live activity",
            details: error.localizedDescription
          )
        )
      }
    }
  }

  @available(iOS 16.1, *)
  private func endPrayerActivities() async {
    for activity in Activity<PrayerCountdownAttributes>.activities {
      await activity.end(dismissalPolicy: .immediate)
    }
  }

  @available(iOS 16.1, *)
  private func updateQuranPlayback(args: [String: Any], result: @escaping FlutterResult) {
    let surahNumber = max(1, (args["surahNumber"] as? Int) ?? 1)
    let surahName = (args["surahName"] as? String) ?? "Surah"
    let surahArabicName = (args["surahArabicName"] as? String) ?? ""
    let ayahNumber = max(1, (args["ayahNumber"] as? Int) ?? 1)
    let reciterName = (args["reciterName"] as? String) ?? "Reciter"
    let isPlaying = (args["isPlaying"] as? Bool) ?? false
    let elapsedSeconds = max(0, (args["elapsedSeconds"] as? Int) ?? 0)
    let totalSeconds = max(0, (args["totalSeconds"] as? Int) ?? 0)

    let contentState = QuranPlaybackAttributes.ContentState(
      surahNumber: surahNumber,
      surahName: surahName,
      surahArabicName: surahArabicName,
      ayahNumber: ayahNumber,
      reciterName: reciterName,
      isPlaying: isPlaying,
      elapsedSeconds: elapsedSeconds,
      totalSeconds: totalSeconds
    )

    Task {
      do {
        if let existing = Activity<QuranPlaybackAttributes>.activities.first {
          await existing.update(using: contentState)
          result(true)
          return
        }
        let attributes = QuranPlaybackAttributes(sessionId: UUID().uuidString)
        _ = try Activity.request(
          attributes: attributes,
          contentState: contentState,
          pushType: nil
        )
        result(true)
      } catch {
        result(
          FlutterError(
            code: "quran_live_activity_error",
            message: "Unable to update quran live activity",
            details: error.localizedDescription
          )
        )
      }
    }
  }

  @available(iOS 16.1, *)
  private func endQuranActivities() async {
    for activity in Activity<QuranPlaybackAttributes>.activities {
      await activity.end(dismissalPolicy: .immediate)
    }
  }
}
