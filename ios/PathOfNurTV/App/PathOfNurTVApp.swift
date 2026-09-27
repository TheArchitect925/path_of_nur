import SwiftUI

@main
struct PathOfNurTVApp: App {
  @StateObject private var appViewModel = TVAppViewModel()
  @StateObject private var themeController = TVThemeController()
  @Environment(\.scenePhase) private var scenePhase

  init() {
    TVTelemetry.bootstrap()
  }

  var body: some Scene {
    WindowGroup {
      TVRootView()
        .environmentObject(appViewModel)
        .environmentObject(themeController)
        .preferredColorScheme(themeController.palette.isNight ? .dark : .light)
        .onChange(of: scenePhase) { phase in
          guard phase == .active else { return }
          themeController.refresh()
        }
    }
  }
}
