import WatchKit

enum WatchHaptics {
  static func autoDhikrTick(enabled: Bool, intervalSeconds: Double) {
    guard enabled else { return }
    if intervalSeconds <= 1.5 {
      WKInterfaceDevice.current().play(.directionDown)
    } else {
      WKInterfaceDevice.current().play(.click)
    }
  }

  static func autoDhikrControl(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.click)
  }

  static func rhythm(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.click)
  }

  static func confirmation(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.start)
  }

  static func increment(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.click)
  }

  static func milestone(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.directionUp)
  }

  static func success(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.success)
  }

  static func completion(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.notification)
  }

  static func antiRush(enabled: Bool) {
    guard enabled else { return }
    WKInterfaceDevice.current().play(.notification)
  }
}
