import ActivityKit
import Flutter
import UIKit

@available(iOS 16.1, *)
struct PrayerCountdownAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var prayerId: String
    var prayerName: String
    var prayerArabicName: String
    var remainingSeconds: Int
    var endAtEpoch: Int
  }

  var prayerId: String
  var prayerName: String
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
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @available(iOS 16.1, *)
  private func updatePrayerCountdown(args: [String: Any], result: @escaping FlutterResult) {
    let prayerId = (args["prayerId"] as? String) ?? "prayer"
    let prayerName = (args["prayerName"] as? String) ?? "Prayer"
    let prayerArabicName = (args["prayerArabicName"] as? String) ?? ""
    let remainingSeconds = max(0, (args["remainingSeconds"] as? Int) ?? 0)
    let endAt = Date().addingTimeInterval(TimeInterval(remainingSeconds))
    let endAtEpoch = Int(endAt.timeIntervalSince1970)

    let contentState = PrayerCountdownAttributes.ContentState(
      prayerId: prayerId,
      prayerName: prayerName,
      prayerArabicName: prayerArabicName,
      remainingSeconds: remainingSeconds,
      endAtEpoch: endAtEpoch
    )

    Task {
      do {
        if let existing = Activity<PrayerCountdownAttributes>.activities.first {
          await existing.update(using: contentState)
          result(true)
          return
        }

        let attributes = PrayerCountdownAttributes(
          prayerId: prayerId,
          prayerName: prayerName
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
}
