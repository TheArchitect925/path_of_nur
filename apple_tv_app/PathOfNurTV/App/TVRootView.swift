import SwiftUI

struct TVRootView: View {
    @EnvironmentObject private var appViewModel: TVAppViewModel

    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            NavigationStack {
                TVHomeScreen(viewModel: appViewModel.homeViewModel)
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(TVTab.home)

            NavigationStack {
                TVPrayerScreen(viewModel: appViewModel.prayerViewModel)
            }
            .tabItem { Label("Prayer", systemImage: "clock.fill") }
            .tag(TVTab.prayer)

            NavigationStack {
                TVDhikrScreen(viewModel: appViewModel.dhikrViewModel)
            }
            .tabItem { Label("Dhikr", systemImage: "sparkles") }
            .tag(TVTab.dhikr)

            NavigationStack {
                TVLearnScreen(viewModel: appViewModel.learnViewModel)
            }
            .tabItem { Label("Learn", systemImage: "book.fill") }
            .tag(TVTab.learn)

            NavigationStack {
                TVLibraryScreen(viewModel: appViewModel.libraryViewModel)
            }
            .tabItem { Label("Library", systemImage: "headphones") }
            .tag(TVTab.library)

            NavigationStack {
                TVProgressScreen(viewModel: appViewModel.progressViewModel)
            }
            .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
            .tag(TVTab.progress)

            NavigationStack {
                TVSettingsScreen(viewModel: appViewModel.settingsViewModel)
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(TVTab.settings)
        }
        .background(TVBackgroundView())
    }
}
