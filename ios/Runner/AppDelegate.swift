import ActivityKit
import Flutter
import UIKit
import Vision
import ImageIO
import WatchConnectivity

@available(iOS 16.1, *)
struct PrayerCountdownAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var showCurrentPrayer: Bool
    var currentPrayerId: String?
    var currentPrayerName: String?
    var currentPrayerArabicName: String?
    var currentRemainingSeconds: Int?
    var currentPrayerAtEpoch: Int?
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
    var useStableDynamicIsland: Bool
    var useStableLockScreenWidget: Bool
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

@available(iOS 16.1, *)
struct FastingCountdownAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var arabicTitle: String
    var metricLabel: String
    var remainingSeconds: Int
    var targetAtEpoch: Int
    var targetRoute: String
    var showDua: Bool
    var duaTitle: String
    var duaArabic: String
    var duaTranslation: String
  }

  var entryId: String
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let liveActivityChannelName = "path_of_nur/live_activities"
  private let navigationChannelName = "path_of_nur/navigation"
  private let iCloudSyncChannelName = "path_of_nur/icloud_sync"
  private let platformRuntimeChannelName = "path_of_nur/platform_runtime"
  private let creationImageLabelingChannelName = "path_of_nur/creation_image_labeling"
  private let watchSyncChannelName = "path_of_nur/watch_sync"
  private let pendingRouteKey = "path_of_nur.pending_route"
  static weak var shared: AppDelegate?
  private var navigationChannel: FlutterMethodChannel?
  private let watchPhoneCacheStore = WatchPhoneCacheStore()
  private lazy var watchConnectivityBridge = WatchPhoneConnectivityBridge(
    cacheStore: watchPhoneCacheStore
  )

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppDelegate.shared = self
    if let registrar = self.registrar(forPlugin: "PathOfNurLiveActivityBridge") {
      let channel = FlutterMethodChannel(
        name: liveActivityChannelName,
        binaryMessenger: registrar.messenger()
      )
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handleLiveActivityCall(call: call, result: result)
      }

      let navigationChannel = FlutterMethodChannel(
        name: navigationChannelName,
        binaryMessenger: registrar.messenger()
      )
      self.navigationChannel = navigationChannel
      navigationChannel.setMethodCallHandler { [weak self] call, result in
        self?.handleNavigationCall(call: call, result: result)
      }

      let iCloudSyncChannel = FlutterMethodChannel(
        name: iCloudSyncChannelName,
        binaryMessenger: registrar.messenger()
      )
      iCloudSyncChannel.setMethodCallHandler { [weak self] call, result in
        self?.handleICloudSyncCall(call: call, result: result)
      }

      let platformRuntimeChannel = FlutterMethodChannel(
        name: platformRuntimeChannelName,
        binaryMessenger: registrar.messenger()
      )
      platformRuntimeChannel.setMethodCallHandler { [weak self] call, result in
        self?.handlePlatformRuntimeCall(call: call, result: result)
      }

      let creationImageLabelingChannel = FlutterMethodChannel(
        name: creationImageLabelingChannelName,
        binaryMessenger: registrar.messenger()
      )
      creationImageLabelingChannel.setMethodCallHandler { [weak self] call, result in
        self?.handleCreationImageLabelingCall(call: call, result: result)
      }

      let watchSyncChannel = FlutterMethodChannel(
        name: watchSyncChannelName,
        binaryMessenger: registrar.messenger()
      )
      watchSyncChannel.setMethodCallHandler { [weak self] call, result in
        self?.handleWatchSyncCall(call: call, result: result)
      }
      watchConnectivityBridge.attach(channel: watchSyncChannel)
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
    case "updateFastingCountdown":
      if #available(iOS 16.1, *) {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "bad_args", message: "Expected dictionary", details: nil))
          return
        }
        updateFastingCountdown(args: args, result: result)
      } else {
        result(false)
      }
    case "endFastingCountdown":
      if #available(iOS 16.1, *) {
        Task {
          await endFastingActivities()
          result(true)
        }
      } else {
        result(false)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handlePlatformRuntimeCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isIosSimulator":
      #if targetEnvironment(simulator)
        result(true)
      #else
        result(false)
      #endif
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleWatchSyncCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "updateWatchSnapshot":
      guard let payload = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad_args", message: "Expected snapshot payload", details: nil))
        return
      }
      watchPhoneCacheStore.saveSnapshot(payload)
      watchConnectivityBridge.publishLatestContext()
      result(true)
    case "updateWatchSettings":
      guard let payload = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad_args", message: "Expected settings payload", details: nil))
        return
      }
      watchPhoneCacheStore.saveSettings(payload)
      watchConnectivityBridge.publishLatestContext()
      result(true)
    case "fetchPendingWatchActions":
      result(watchPhoneCacheStore.pendingActions())
    case "acknowledgePendingWatchActions":
      guard
        let payload = call.arguments as? [String: Any],
        let actionIds = payload["actionIds"] as? [String]
      else {
        result(FlutterError(code: "bad_args", message: "Expected actionIds", details: nil))
        return
      }
      watchPhoneCacheStore.acknowledgePendingActionIds(actionIds)
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleCreationImageLabelingCall(
    call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    switch call.method {
    case "detectLabels":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad_args", message: "Expected dictionary", details: nil))
        return
      }
      detectCreationImageLabels(args: args, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func detectCreationImageLabels(
    args: [String: Any],
    result: @escaping FlutterResult
  ) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        guard let width = args["width"] as? NSNumber,
              let height = args["height"] as? NSNumber,
              let planes = args["planes"] as? [[String: Any]],
              let firstPlane = planes.first,
              let typedBytes = firstPlane["bytes"] as? FlutterStandardTypedData,
              let bytesPerRow = firstPlane["bytesPerRow"] as? NSNumber else {
          throw NSError(
            domain: "creation_image_labeling",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Missing image payload"]
          )
        }

        let cgImage = try self.makeClassificationImage(
          bytes: typedBytes.data,
          width: width.intValue,
          height: height.intValue,
          bytesPerRow: bytesPerRow.intValue
        )
        let request = VNClassifyImageRequest()
        let rotation = (args["rotation"] as? NSNumber)?.intValue ?? 0
        let orientation = self.cgOrientation(forRotationDegrees: rotation)
        let handler = VNImageRequestHandler(
          cgImage: cgImage,
          orientation: orientation,
          options: [:]
        )
        try handler.perform([request])

        let threshold = Float((args["confidenceThreshold"] as? NSNumber)?.doubleValue ?? 0.7)
        let observations = (request.results as? [VNClassificationObservation]) ?? []
        let payload = observations
          .filter { $0.confidence >= threshold }
          .prefix(8)
          .map { observation in
            [
              "label": observation.identifier,
              "confidence": Double(observation.confidence),
            ]
          }

        DispatchQueue.main.async {
          result(payload)
        }
      } catch {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: "ios_image_labeling",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      }
    }
  }

  private func makeClassificationImage(
    bytes: Data,
    width: Int,
    height: Int,
    bytesPerRow: Int
  ) throws -> CGImage {
    guard let provider = CGDataProvider(data: bytes as CFData) else {
      throw NSError(
        domain: "creation_image_labeling",
        code: 2,
        userInfo: [NSLocalizedDescriptionKey: "Unable to create image provider"]
      )
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo.byteOrder32Little.union(
      CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    )
    guard let image = CGImage(
      width: width,
      height: height,
      bitsPerComponent: 8,
      bitsPerPixel: 32,
      bytesPerRow: bytesPerRow,
      space: colorSpace,
      bitmapInfo: bitmapInfo,
      provider: provider,
      decode: nil,
      shouldInterpolate: false,
      intent: .defaultIntent
    ) else {
      throw NSError(
        domain: "creation_image_labeling",
        code: 3,
        userInfo: [NSLocalizedDescriptionKey: "Unable to build CGImage from camera bytes"]
      )
    }
    return image
  }

  private func cgOrientation(forRotationDegrees rotation: Int) -> CGImagePropertyOrientation {
    switch rotation {
    case 90:
      return .right
    case 180:
      return .down
    case 270:
      return .left
    default:
      return .up
    }
  }

  private func handleNavigationCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPendingRoute":
      let defaults = UserDefaults.standard
      let route = defaults.string(forKey: pendingRouteKey)
      defaults.removeObject(forKey: pendingRouteKey)
      result(route)
    default:
      result(FlutterMethodNotImplemented)
    }
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
    let currentPrayerAtIso = args["currentPrayerAtIso"] as? String
    let currentPrayerAt = currentPrayerAtIso.flatMap { ISO8601DateFormatter().date(from: $0) }
    let currentPrayerAtEpoch = currentPrayerAt.map { Int($0.timeIntervalSince1970) }
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
    let useStableDynamicIsland = (args["useStableDynamicIsland"] as? Bool) ?? false
    let useStableLockScreenWidget = (args["useStableLockScreenWidget"] as? Bool) ?? false

    let contentState = PrayerCountdownAttributes.ContentState(
      showCurrentPrayer: showCurrentPrayer,
      currentPrayerId: currentPrayerId,
      currentPrayerName: currentPrayerName,
      currentPrayerArabicName: currentPrayerArabicName,
      currentRemainingSeconds: currentRemainingSeconds,
      currentPrayerAtEpoch: currentPrayerAtEpoch,
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
      nextTargetAtEpoch: nextTargetAtEpoch,
      useStableDynamicIsland: useStableDynamicIsland,
      useStableLockScreenWidget: useStableLockScreenWidget
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

  @available(iOS 16.1, *)
  private func updateFastingCountdown(args: [String: Any], result: @escaping FlutterResult) {
    let title = (args["title"] as? String) ?? "Fast"
    let arabicTitle = (args["arabicTitle"] as? String) ?? ""
    let metricLabel = (args["metricLabel"] as? String) ?? "Ends in"
    let remainingSeconds = max(0, (args["remainingSeconds"] as? Int) ?? 0)
    let targetAtIso = (args["targetAtIso"] as? String) ?? ""
    let targetAt = ISO8601DateFormatter().date(from: targetAtIso)
      ?? Date().addingTimeInterval(TimeInterval(remainingSeconds))
    let targetAtEpoch = Int(targetAt.timeIntervalSince1970)
    let targetRoute = (args["targetRoute"] as? String) ?? "/learn/hub/duas"
    let showDua = (args["showDua"] as? Bool) ?? false
    let duaTitle = (args["duaTitle"] as? String) ?? ""
    let duaArabic = (args["duaArabic"] as? String) ?? ""
    let duaTranslation = (args["duaTranslation"] as? String) ?? ""

    let contentState = FastingCountdownAttributes.ContentState(
      title: title,
      arabicTitle: arabicTitle,
      metricLabel: metricLabel,
      remainingSeconds: remainingSeconds,
      targetAtEpoch: targetAtEpoch,
      targetRoute: targetRoute,
      showDua: showDua,
      duaTitle: duaTitle,
      duaArabic: duaArabic,
      duaTranslation: duaTranslation
    )

    Task {
      do {
        if let existing = Activity<FastingCountdownAttributes>.activities.first {
          await existing.update(using: contentState)
          result(true)
          return
        }

        let attributes = FastingCountdownAttributes(entryId: UUID().uuidString)
        _ = try Activity.request(
          attributes: attributes,
          contentState: contentState,
          pushType: nil
        )
        result(true)
      } catch {
        result(
          FlutterError(
            code: "fasting_live_activity_error",
            message: "Unable to update fasting live activity",
            details: error.localizedDescription
          )
        )
      }
    }
  }

  @available(iOS 16.1, *)
  private func endFastingActivities() async {
    for activity in Activity<FastingCountdownAttributes>.activities {
      await activity.end(dismissalPolicy: .immediate)
    }
  }

  func handleIncomingRouteURL(_ url: URL) {
    guard url.scheme == "pathofnur" else { return }
    let route = url.absoluteString
    UserDefaults.standard.set(route, forKey: pendingRouteKey)
    navigationChannel?.invokeMethod("openRoute", arguments: route)
  }
}
