import SwiftUI

@main
struct PathOfNurTVApp: App {
  @StateObject private var appViewModel = TVAppViewModel()

  init() {
    TVTelemetry.bootstrap()
  }

  var body: some Scene {
    WindowGroup {
      TVRootView()
        .environmentObject(appViewModel)
        .preferredColorScheme(.dark)
    }
  }
}
