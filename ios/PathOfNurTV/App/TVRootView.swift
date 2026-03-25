import SwiftUI

struct TVRootView: View {
  @EnvironmentObject private var appViewModel: TVAppViewModel

  var body: some View {
    ZStack {
      TVBackgroundView()

      HStack(alignment: .top, spacing: 28) {
        TVNavigationSidebar()

        Group {
          switch appViewModel.selectedRoute {
          case .home:
            TVHomeScreen(viewModel: appViewModel.homeViewModel)
          case .profiles:
            TVProfilesScreen(viewModel: appViewModel.profilesViewModel)
          case .quran:
            TVQuranScreen(viewModel: appViewModel.quranViewModel)
          case .favorites:
            TVFavoritesScreen(viewModel: appViewModel.favoritesViewModel)
          case .settings:
            TVSettingsScreen(viewModel: appViewModel.settingsViewModel)
          case .arabic:
            TVArabicScreen(viewModel: appViewModel.arabicViewModel)
          case .learn:
            TVLearnScreen(viewModel: appViewModel.learnViewModel)
          case .games:
            TVGamesScreen(viewModel: appViewModel.gamesViewModel)
          case .prayer:
            TVPrayerScreen(viewModel: appViewModel.prayerViewModel)
          case .dhikr:
            TVDhikrScreen(viewModel: appViewModel.dhikrViewModel)
          case .kids:
            TVKidsScreen(viewModel: appViewModel.kidsViewModel)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      }
      .padding(28)
    }
    .tint(TVTheme.accentStrong)
  }
}
