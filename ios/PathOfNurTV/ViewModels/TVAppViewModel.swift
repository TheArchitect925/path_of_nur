import AVFoundation
import Foundation

final class TVAppViewModel: ObservableObject {
  @Published var selectedTab: TVTab = .home

  let homeViewModel = TVHomeViewModel()
  let quranViewModel = TVQuranViewModel()
}

final class TVHomeViewModel: ObservableObject {
  @Published private(set) var hero: TVHeroContent = TVSeedRepository.homeHero()
  @Published private(set) var verse: TVHomeVerse = TVSeedRepository.homeVerse()
  @Published private(set) var prayerSummaryLine: String = ""
  @Published private(set) var prayerSummaryDetail: String = ""
  @Published private(set) var prayerTimes: [TVPrayerTime] = []
  @Published private(set) var actions: [TVShelfItem] = TVSeedRepository.homeActions()
  @Published private(set) var continueReading: TVContinueReadingSummary = TVSeedRepository.continueReading

  private var timer: Timer?

  init() {
    refresh()
    timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      self?.refresh()
    }
  }

  deinit {
    timer?.invalidate()
  }

  func refresh() {
    let snapshot = TVSeedRepository.homePrayerSnapshot(date: Date())
    prayerSummaryLine = snapshot.summaryLine
    prayerSummaryDetail = snapshot.detailLine
    prayerTimes = snapshot.prayerTimes
  }
}

final class TVQuranViewModel: ObservableObject {
  @Published private(set) var surahs: [TVQuranSurah] = TVSeedRepository.quranSurahs
  @Published private(set) var dailyVerse: TVQuranDailyVerse = TVSeedRepository.dailyVerse
  @Published private(set) var continueReading: TVContinueReadingSummary = TVSeedRepository.continueReading
  @Published var selectedSurah: TVQuranSurah
  @Published var selectedAyahIndex: Int = 0
  @Published var selectedReciter: TVQuranReciter = .husary
  @Published private(set) var isPlaying = false
  @Published private(set) var playbackErrorMessage: String?

  private let player = AVPlayer()
  private var endObserver: NSObjectProtocol?

  init() {
    selectedSurah = TVSeedRepository.quranSurahs.first!
    endObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.playNextAyah(autoStart: true)
    }
  }

  deinit {
    if let endObserver {
      NotificationCenter.default.removeObserver(endObserver)
    }
  }

  var selectedAyahs: [TVQuranAyah] {
    TVSeedRepository.ayahs(for: selectedSurah.number)
  }

  var selectedAyah: TVQuranAyah? {
    guard selectedAyahIndex >= 0 && selectedAyahIndex < selectedAyahs.count else {
      return nil
    }
    return selectedAyahs[selectedAyahIndex]
  }

  var continueReadingLine: String {
    String(
      format: tvLocalized("Continue with %@ %d:%d"),
      continueReading.surahName,
      continueReading.surahNumber,
      continueReading.ayahNumber
    )
  }

  var readerSubtitle: String {
    let surah = selectedSurah
    return "\(surah.transliteratedName) • \(surah.englishName) • \(surah.revelationPlace)"
  }

  var playbackSummary: String {
    guard let ayah = selectedAyah else {
      return tvLocalized("No ayah selected")
    }
    return String(
      format: tvLocalized("Playback summary: %@ %d:%d"),
      selectedSurah.transliteratedName,
      selectedSurah.number,
      ayah.ayahNumber
    )
  }

  func selectSurah(_ surah: TVQuranSurah) {
    selectedSurah = surah
    selectedAyahIndex = 0
    stopPlayback()
  }

  func selectAyah(at index: Int) {
    guard index >= 0 && index < selectedAyahs.count else { return }
    selectedAyahIndex = index
    stopPlayback()
  }

  func selectReciter(_ reciter: TVQuranReciter) {
    selectedReciter = reciter
    if isPlaying {
      playSelectedAyah()
    }
  }

  func togglePlayback() {
    guard selectedAyah != nil else { return }
    if isPlaying {
      player.pause()
      isPlaying = false
      return
    }
    playSelectedAyah()
  }

  func playPreviousAyah() {
    playPreviousAyah(autoStart: isPlaying)
  }

  func playNextAyah() {
    playNextAyah(autoStart: isPlaying)
  }

  func playSelectedAyah() {
    guard let ayah = selectedAyah else { return }
    guard let url = TVSeedRepository.audioURL(
      reciter: selectedReciter,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber
    ) else {
      playbackErrorMessage = tvLocalized("Playback unavailable right now.")
      return
    }

    playbackErrorMessage = nil
    let item = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: item)
    player.play()
    isPlaying = true
  }

  private func playPreviousAyah(autoStart: Bool) {
    guard !selectedAyahs.isEmpty else { return }
    selectedAyahIndex = max(selectedAyahIndex - 1, 0)
    if autoStart {
      playSelectedAyah()
    } else {
      stopPlayback()
    }
  }

  private func playNextAyah(autoStart: Bool) {
    guard !selectedAyahs.isEmpty else { return }
    let nextIndex = min(selectedAyahIndex + 1, selectedAyahs.count - 1)
    guard nextIndex != selectedAyahIndex || !autoStart else {
      stopPlayback()
      return
    }
    selectedAyahIndex = nextIndex
    if autoStart {
      playSelectedAyah()
    } else {
      stopPlayback()
    }
  }

  private func stopPlayback() {
    player.pause()
    isPlaying = false
  }
}
