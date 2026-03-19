import Foundation

struct TVPrayerSnapshot {
  let summaryLine: String
  let detailLine: String
  let prayerTimes: [TVPrayerTime]
}

enum TVSeedRepository {
  static let continueReading = TVContinueReadingSummary(
    surahNumber: 1,
    surahName: "Al-Fatihah",
    ayahNumber: 5
  )

  static let dailyVerse = TVQuranDailyVerse(
    surahNumber: 2,
    ayahNumber: 45,
    arabic: "وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ",
    transliteration: "Wastaeenu bis-sabri was-salah",
    translation: "Seek help through patience and prayer.",
    locationLabel: "Al-Baqarah 2:45"
  )

  static let quranSurahs: [TVQuranSurah] = [
    TVQuranSurah(id: 1, number: 1, arabicName: "الفاتحة", transliteratedName: "Al-Fatihah", englishName: "The Opening", verseCount: 7, revelationPlace: "Makkah"),
    TVQuranSurah(id: 94, number: 94, arabicName: "الشرح", transliteratedName: "Ash-Sharh", englishName: "The Expansion", verseCount: 8, revelationPlace: "Makkah"),
    TVQuranSurah(id: 112, number: 112, arabicName: "الإخلاص", transliteratedName: "Al-Ikhlas", englishName: "Sincerity", verseCount: 4, revelationPlace: "Makkah"),
    TVQuranSurah(id: 113, number: 113, arabicName: "الفلق", transliteratedName: "Al-Falaq", englishName: "Daybreak", verseCount: 5, revelationPlace: "Makkah"),
    TVQuranSurah(id: 114, number: 114, arabicName: "الناس", transliteratedName: "An-Nas", englishName: "Mankind", verseCount: 6, revelationPlace: "Makkah"),
  ]

  private static let ayahMap: [Int: [TVQuranAyah]] = [
    1: [
      TVQuranAyah(id: "1:1", surahNumber: 1, ayahNumber: 1, arabic: "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ", transliteration: "Bismillahi ar-Rahmani ar-Rahim", translation: "In the name of Allah, the Entirely Merciful, the Especially Merciful."),
      TVQuranAyah(id: "1:2", surahNumber: 1, ayahNumber: 2, arabic: "الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ", transliteration: "Alhamdu lillahi rabbil alamin", translation: "All praise is due to Allah, Lord of all worlds."),
      TVQuranAyah(id: "1:5", surahNumber: 1, ayahNumber: 5, arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", transliteration: "Iyyaka naabudu wa iyyaka nastaeen", translation: "You alone we worship, and You alone we ask for help."),
    ],
    94: [
      TVQuranAyah(id: "94:5", surahNumber: 94, ayahNumber: 5, arabic: "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا", transliteration: "Fa inna ma al-usri yusra", translation: "Indeed, with hardship comes ease."),
      TVQuranAyah(id: "94:6", surahNumber: 94, ayahNumber: 6, arabic: "إِنَّ مَعَ الْعُسْرِ يُسْرًا", transliteration: "Inna ma al-usri yusra", translation: "Surely, with hardship comes ease."),
    ],
    112: [
      TVQuranAyah(id: "112:1", surahNumber: 112, ayahNumber: 1, arabic: "قُلْ هُوَ اللّٰهُ أَحَدٌ", transliteration: "Qul huwa Allahu ahad", translation: "Say, He is Allah, the One."),
      TVQuranAyah(id: "112:2", surahNumber: 112, ayahNumber: 2, arabic: "اللّٰهُ الصَّمَدُ", transliteration: "Allahu as-samad", translation: "Allah, the Eternal Refuge."),
    ],
    113: [
      TVQuranAyah(id: "113:1", surahNumber: 113, ayahNumber: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", transliteration: "Qul aoodhu birabbil falaq", translation: "Say: I seek refuge in the Lord of daybreak."),
    ],
    114: [
      TVQuranAyah(id: "114:1", surahNumber: 114, ayahNumber: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", transliteration: "Qul aoodhu birabbin nas", translation: "Say: I seek refuge in the Lord of mankind."),
    ],
  ]

  static func homeHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Today's Home"),
      title: "Path of Nūr",
      subtitle: tvLocalized("A calm Apple TV mirror of the current Path of Nūr experience."),
      supportingLine: tvLocalized("Home keeps the prayer-first shape of the mobile app, with the Qur'an close at hand.")
    )
  }

  static func homeVerse() -> TVHomeVerse {
    TVHomeVerse(
      arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
      transliteration: "Iyyaka na'budu wa iyyaka nasta'in",
      translation: "You alone we worship, and You alone we ask for help.",
      locationLabel: "Al-Fatihah 1:5"
    )
  }

  static func homeActions() -> [TVShelfItem] {
    [
      TVShelfItem(
        id: "home_quran",
        title: tvLocalized("Open Qur'an"),
        subtitle: tvLocalized("Open the same Qur'an space from the home surface."),
        systemImage: "book.closed.fill"
      ),
      TVShelfItem(
        id: "home_rhythm",
        title: tvLocalized("Daily prayer rhythm"),
        subtitle: tvLocalized("See the current and next salah first, then scan the full day."),
        systemImage: "clock.fill"
      ),
    ]
  }

  static func ayahs(for surahNumber: Int) -> [TVQuranAyah] {
    ayahMap[surahNumber] ?? []
  }

  static func audioURL(
    reciter: TVQuranReciter,
    surahNumber: Int,
    ayahNumber: Int
  ) -> URL? {
    let code = String(format: "%03d%03d", surahNumber, ayahNumber)
    return URL(string: "\(reciter.baseURL)/\(code).mp3")
  }

  static func homePrayerSnapshot(date: Date) -> TVPrayerSnapshot {
    let calendar = Calendar.current
    let locale = Locale.current
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.setLocalizedDateFormatFromTemplate("jm")

    let prayerSeeds: [(String, String, String, Int, Int)] = [
      ("fajr", "Fajr", "الفجر", 5, 18),
      ("dhuhr", "Dhuhr", "الظهر", 13, 9),
      ("asr", "Asr", "العصر", 16, 42),
      ("maghrib", "Maghrib", "المغرب", 19, 18),
      ("isha", "Isha", "العشاء", 20, 47),
    ]

    let datedSeeds = prayerSeeds.compactMap { seed -> (String, String, String, Date)? in
      var components = calendar.dateComponents([.year, .month, .day], from: date)
      components.hour = seed.3
      components.minute = seed.4
      guard let value = calendar.date(from: components) else { return nil }
      return (seed.0, seed.1, seed.2, value)
    }

    let currentIndex = datedSeeds.lastIndex { $0.3 <= date }
    let nextIndex = datedSeeds.firstIndex { $0.3 > date } ?? 0

    let prayerTimes = datedSeeds.enumerated().map { index, item in
      let isCurrent = currentIndex == index
      let isNext = currentIndex == nil ? index == 0 : nextIndex == index

      let statusLine: String
      if isCurrent {
        let nextDate = datedSeeds[min(index + 1, datedSeeds.count - 1)].3
        statusLine = String(
          format: tvLocalized("Ends in %@"),
          relativeDuration(from: date, to: nextDate)
        )
      } else if isNext {
        statusLine = String(
          format: tvLocalized("Begins at %@"),
          formatter.string(from: item.3)
        )
      } else if index < (currentIndex ?? 0) {
        statusLine = tvLocalized("Completed earlier today")
      } else {
        statusLine = tvLocalized("Upcoming later today")
      }

      return TVPrayerTime(
        id: item.0,
        title: item.1,
        arabicTitle: item.2,
        timeLabel: formatter.string(from: item.3),
        statusLine: statusLine,
        isCurrent: isCurrent,
        isNext: isNext
      )
    }

    let summaryLine: String
    let detailLine: String
    if let currentIndex {
      let currentPrayer = datedSeeds[currentIndex]
      summaryLine = String(format: tvLocalized("Current prayer: %@"), currentPrayer.1)
      let nextPrayer = datedSeeds[min(currentIndex + 1, datedSeeds.count - 1)]
      detailLine = String(
        format: tvLocalized("Next prayer: %@"),
        formatter.string(from: nextPrayer.3)
      )
    } else {
      let nextPrayer = datedSeeds[nextIndex]
      summaryLine = String(format: tvLocalized("Next prayer: %@"), nextPrayer.1)
      detailLine = String(
        format: tvLocalized("Begins at %@"),
        formatter.string(from: nextPrayer.3)
      )
    }

    return TVPrayerSnapshot(
      summaryLine: summaryLine,
      detailLine: detailLine,
      prayerTimes: prayerTimes
    )
  }

  private static func relativeDuration(from start: Date, to end: Date) -> String {
    let interval = max(Int(end.timeIntervalSince(start)), 0)
    let hours = interval / 3600
    let minutes = (interval % 3600) / 60
    if hours > 0 {
      return "\(hours)h \(minutes)m"
    }
    return "\(minutes)m"
  }
}
