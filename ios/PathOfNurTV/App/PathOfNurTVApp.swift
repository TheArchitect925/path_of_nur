import SwiftUI

@main
struct PathOfNurTVApp: App {
  @StateObject private var appViewModel = TVAppViewModel()

  var body: some Scene {
    WindowGroup {
      TVRootView()
        .environmentObject(appViewModel)
        .preferredColorScheme(.dark)
    }
  }
}
