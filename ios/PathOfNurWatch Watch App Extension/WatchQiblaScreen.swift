import CoreLocation
import SwiftUI

/// Great-circle bearing to the Kaaba, mirrored from the phone's
/// `qibla_direction_math.dart` so both compasses point the same way.
enum WatchQiblaMath {
  static let kaabaLatitude = 21.4225
  static let kaabaLongitude = 39.8262
  static let alignedToleranceDegrees = 7.0

  static func normalizeDegrees(_ value: Double) -> Double {
    let normalized = value.truncatingRemainder(dividingBy: 360)
    return normalized < 0 ? normalized + 360 : normalized
  }

  static func shortestSignedAngleDelta(
    fromDegrees: Double,
    toDegrees: Double
  ) -> Double {
    let delta = normalizeDegrees(toDegrees - fromDegrees)
    return delta > 180 ? delta - 360 : delta
  }

  static func bearingToKaaba(latitude: Double, longitude: Double) -> Double {
    let lat1 = latitude * .pi / 180
    let lat2 = kaabaLatitude * .pi / 180
    let deltaLongitude = (kaabaLongitude - longitude) * .pi / 180

    let y = sin(deltaLongitude) * cos(lat2)
    let x =
      cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLongitude)
    return normalizeDegrees(atan2(y, x) * 180 / .pi)
  }
}

/// Owns the watch's location and heading feed. Follows `WatchSyncService`:
/// a plain NSObject delegate, created on the main thread, so the callbacks
/// land where the published properties are read.
final class WatchQiblaCompassModel: NSObject, ObservableObject,
  CLLocationManagerDelegate
{
  @Published private(set) var authorization: CLAuthorizationStatus = .notDetermined
  @Published private(set) var coordinate: CLLocationCoordinate2D?
  @Published private(set) var headingDegrees: Double?
  /// True while the only fix we have is the one the system had cached when
  /// the screen opened — worth saying out loud rather than pointing confidently.
  @Published private(set) var isApproximate = false

  private let manager = CLLocationManager()

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    authorization = manager.authorizationStatus
  }

  var isAuthorized: Bool {
    authorization == .authorizedWhenInUse || authorization == .authorizedAlways
  }

  var qiblaBearing: Double? {
    guard let coordinate else { return nil }
    return WatchQiblaMath.bearingToKaaba(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude
    )
  }

  /// Where the needle should sit: the Qibla bearing seen from the current
  /// heading. Without a heading the needle shows true bearing instead.
  var needleDegrees: Double? {
    guard let qiblaBearing else { return nil }
    return WatchQiblaMath.normalizeDegrees(qiblaBearing - (headingDegrees ?? 0))
  }

  var isAligned: Bool {
    guard let needleDegrees else { return false }
    let delta = WatchQiblaMath.shortestSignedAngleDelta(
      fromDegrees: 0,
      toDegrees: needleDegrees
    )
    return abs(delta) <= WatchQiblaMath.alignedToleranceDegrees
  }

  func requestAuthorization() {
    manager.requestWhenInUseAuthorization()
  }

  func start() {
    authorization = manager.authorizationStatus
    guard isAuthorized else { return }
    if let cached = manager.location {
      coordinate = cached.coordinate
      isApproximate = true
    }
    manager.startUpdatingLocation()
    if CLLocationManager.headingAvailable() {
      manager.startUpdatingHeading()
    }
  }

  func stop() {
    manager.stopUpdatingLocation()
    if CLLocationManager.headingAvailable() {
      manager.stopUpdatingHeading()
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorization = manager.authorizationStatus
    if isAuthorized {
      start()
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let latest = locations.last else { return }
    coordinate = latest.coordinate
    isApproximate = false
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateHeading newHeading: CLHeading
  ) {
    guard newHeading.headingAccuracy >= 0 else { return }
    headingDegrees = newHeading.magneticHeading
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    // A dropped fix is not worth a scary screen: keep showing the last one.
  }
}

struct WatchQiblaScreen: View {
  @Environment(\.watchPalette) private var palette
  @StateObject private var compass = WatchQiblaCompassModel()

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 10) {
          switch compass.authorization {
          case .notDetermined:
            permissionPrompt
          case .denied, .restricted:
            deniedNotice
          default:
            compassBody
          }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
      }
      .navigationTitle(WatchStrings.qiblaTitle)
      .containerBackground(palette.backgroundGradient, for: .navigation)
    }
    .onAppear { compass.start() }
    .onDisappear { compass.stop() }
  }

  @ViewBuilder
  private var compassBody: some View {
    if let needle = compass.needleDegrees {
      dial(needle: needle)
      Text(
        compass.isAligned
          ? WatchStrings.qiblaAligned
          : degreesLabel(needle)
      )
      .font(WatchType.label)
      .foregroundStyle(compass.isAligned ? palette.success : palette.onSurface)
      .multilineTextAlignment(.center)

      if compass.isApproximate {
        Text(WatchStrings.qiblaApproximate)
          .font(WatchType.caption)
          .foregroundStyle(palette.onSurfaceSubtle)
          .multilineTextAlignment(.center)
      }
    } else {
      ProgressView()
        .tint(palette.accent)
        .padding(.top, 12)
      Text(WatchStrings.qiblaLocating)
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceSubtle)
        .multilineTextAlignment(.center)
    }
  }

  private func dial(needle: Double) -> some View {
    ZStack {
      Circle()
        .strokeBorder(palette.border.opacity(0.5), lineWidth: 2)
      Circle()
        .fill(palette.cardFillSoft)
        .padding(6)
      Image(systemName: "location.north.fill")
        .font(.system(size: 26, weight: .semibold))
        .foregroundStyle(compass.isAligned ? palette.success : palette.accent)
        .rotationEffect(.degrees(needle))
        .animation(.easeInOut(duration: 0.25), value: needle)
    }
    .frame(width: 104, height: 104)
    .accessibilityLabel(WatchStrings.qiblaTitle)
    .accessibilityValue(
      compass.isAligned ? WatchStrings.qiblaAligned : degreesLabel(needle)
    )
  }

  private var permissionPrompt: some View {
    VStack(spacing: 8) {
      Text(WatchStrings.qiblaLocationNeededTitle)
        .font(WatchType.screenTitle)
        .foregroundStyle(palette.onSurface)
        .multilineTextAlignment(.center)
      Text(WatchStrings.qiblaLocationNeededBody)
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceSubtle)
        .multilineTextAlignment(.center)
      Button(WatchStrings.qiblaAllowLocation) {
        compass.requestAuthorization()
      }
      .foregroundStyle(palette.accent)
    }
  }

  private var deniedNotice: some View {
    VStack(spacing: 8) {
      Text(WatchStrings.qiblaLocationNeededTitle)
        .font(WatchType.screenTitle)
        .foregroundStyle(palette.onSurface)
        .multilineTextAlignment(.center)
      Text(WatchStrings.qiblaLocationDeniedBody)
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceSubtle)
        .multilineTextAlignment(.center)
    }
  }

  private func degreesLabel(_ needle: Double) -> String {
    String(
      format: "%.0f°",
      locale: .current,
      WatchQiblaMath.normalizeDegrees(needle)
    )
  }
}
