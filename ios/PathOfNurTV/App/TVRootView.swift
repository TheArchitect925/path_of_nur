import SwiftUI

struct TVRootView: View {
  @EnvironmentObject private var appViewModel: TVAppViewModel

  var body: some View {
    TabView(selection: $appViewModel.selectedTab) {
      NavigationView {
        TVHomeScreen(viewModel: appViewModel.homeViewModel)
      }
      .tabItem { Label(NSLocalizedString("Home", comment: ""), systemImage: "house.fill") }
      .tag(TVTab.home)

      NavigationView {
        TVQuranScreen(viewModel: appViewModel.quranViewModel)
      }
      .tabItem { Label(NSLocalizedString("Qur'an", comment: ""), systemImage: "book.closed.fill") }
      .tag(TVTab.quran)
    }
    .background(TVBackgroundView())
  }
}
