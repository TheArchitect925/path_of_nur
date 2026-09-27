import SwiftUI

struct TVRootView: View {
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @EnvironmentObject private var themeController: TVThemeController

  var body: some View {
    ZStack {
      TVBackgroundView()

      HStack(alignment: .top, spacing: 28) {
        TVNavigationSidebar()

        Group {
          switch appViewModel.selectedRoute {
          case .home:
            TVHomeScreen(
              viewModel: appViewModel.homeViewModel,
              quran: appViewModel.quranViewModel
            )
          case .profiles:
            TVProfilesScreen(viewModel: appViewModel.profilesViewModel)
          case .quran:
            TVQuranScreen(viewModel: appViewModel.quranViewModel)
          case .favorites:
            TVFavoritesScreen(viewModel: appViewModel.favoritesViewModel)
          case .settings:
            TVSettingsScreen(
              viewModel: appViewModel.settingsViewModel,
              prayerService: appViewModel.prayerService
            )
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
        // The rail and the section beside it are two parts of one screen.
        // The system moves the focus from the edge of one into the other,
        // whichever side the rail is on, and no screen has to send it.
        .focusSection()
        // Menu steps back to the rail. From the rail it leaves the app, as
        // it does anywhere there is nothing further back.
        .onExitCommand {
          appViewModel.focusNavigation()
        }
      }
      .padding(28)
    }
    .tint(TVTheme.accentStrong)
    // Theme turnover (dawn, dusk, Friday, a Settings choice) is rare;
    // rebuilding the tree by identity is how the static token facade
    // repaints everywhere at once.
    .id(themeController.renderToken)
  }
}
