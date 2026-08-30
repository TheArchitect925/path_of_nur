import SwiftUI

struct WatchRootView: View {
  @EnvironmentObject private var model: WatchAppModel

  var body: some View {
    TabView(selection: $model.selectedTab) {
      WatchHomeView()
        .tag(WatchRootTab.home)
      PrayerCheckInScreen()
        .tag(WatchRootTab.prayer)
      DhikrWatchScreen()
        .tag(WatchRootTab.dhikr)
      ProgressWatchScreen()
        .tag(WatchRootTab.progress)
      WatchUtilityScreen()
        .tag(WatchRootTab.utility)
    }
    .tabViewStyle(.verticalPage)
    .environment(\.watchPalette, model.palette)
    .background(model.palette.backgroundGradient.ignoresSafeArea())
    .animation(.easeInOut(duration: 0.3), value: model.palette)
    .sheet(item: $model.presentedAuxScreen) { screen in
      auxScreen(screen)
        .environmentObject(model)
        .environment(\.watchPalette, model.palette)
    }
  }

  @ViewBuilder
  private func auxScreen(_ screen: WatchAuxScreen) -> some View {
    switch screen {
    case .qibla:
      WatchQiblaScreen()
    case .names:
      WatchNamesScreen()
    case .quranRemote:
      WatchQuranRemoteScreen()
    }
  }
}
