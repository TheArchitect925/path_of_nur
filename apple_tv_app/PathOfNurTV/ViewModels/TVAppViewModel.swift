import Foundation

final class TVAppViewModel: ObservableObject {
    @Published var selectedTab: TVTab = .home
    let homeViewModel = TVHomeViewModel()
    let prayerViewModel = TVPrayerViewModel()
    let dhikrViewModel = TVDhikrViewModel()
    let learnViewModel = TVLearnViewModel()
    let prophetsViewModel = TVProphetsViewModel()
    let libraryViewModel = TVLibraryViewModel()
    let progressViewModel = TVProgressViewModel()
    let settingsViewModel = TVSettingsViewModel()
}
