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
    .tabViewStyle(.carousel)
    .background(WatchTheme.backgroundGradient.ignoresSafeArea())
  }
}
