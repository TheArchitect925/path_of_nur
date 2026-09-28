import Foundation

enum TVSeedRepository {
  // The Qur'an text is generated from the phone's sources: the list of
  // surahs in TVQuranData, the verses in the resources TVQuranLibrary reads.
  // Nothing of it is typed here: a verse is looked up, never written out.

  static let quranSurahs: [TVQuranSurah] = TVQuranData.surahs

  /// The verse of the day, which is the phone's
  /// (`TVQuranVerseOfTheDay`).
  static func dailyVerse(
    on date: Date,
    translation: TVQuranTranslation? = TVQuranTranslationChoice.load()
  ) -> TVQuranDailyVerse {
    let place = TVQuranVerseOfTheDay.place(on: date)
    let verse = ayahs(for: place.surahNumber, translation: translation)
      .first { $0.ayahNumber == place.ayahNumber }
    return TVQuranDailyVerse(
      surahNumber: place.surahNumber,
      ayahNumber: place.ayahNumber,
      arabic: verse?.arabic ?? "",
      transliteration: verse?.transliteration ?? "",
      translation: verse?.translation ?? "",
      locationLabel: String(
        format: tvLocalized("%@ %d:%d"),
        surahName(place.surahNumber),
        place.surahNumber,
        place.ayahNumber
      )
    )
  }

  static func surah(_ number: Int) -> TVQuranSurah? {
    quranSurahs.first { $0.number == number }
  }

  static func surahName(_ number: Int) -> String {
    surah(number)?.transliteratedName ?? ""
  }

  static func ayah(surah: Int, number: Int) -> TVQuranAyah? {
    ayahs(for: surah).first { $0.ayahNumber == number }
  }

  /// The ayahs of one surah, read when they are asked for, with the
  /// translation the viewer chose. A viewer reading in Arabic is not shown
  /// the reading in Latin letters.
  static func ayahs(
    for surahNumber: Int,
    translation: TVQuranTranslation? = TVQuranTranslationChoice.load()
  ) -> [TVQuranAyah] {
    TVQuranLibrary.shared.ayahs(
      inSurah: surahNumber,
      translation: translation,
      showsTransliteration: (Locale.current.languageCode ?? "en") != "ar"
    )
  }

  static func homeHero(today: String) -> TVHeroContent {
    TVHeroContent(
      eyebrow: today,
      title: "Path of Nūr",
      subtitle: tvLocalized("Assalamu alaikum"),
      supportingLine: ""
    )
  }

  static func prayerHero(today: String, place: String, method: String) -> TVHeroContent {
    TVHeroContent(
      eyebrow: today,
      title: tvLocalized("Prayer"),
      subtitle: place,
      supportingLine: method
    )
  }

  static func dhikrHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: "",
      title: tvLocalized("Dhikr"),
      subtitle: tvLocalized("Remembrance, phrase by phrase"),
      supportingLine: ""
    )
  }

  static func kidsHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Kids"),
      title: tvLocalized("Kids"),
      subtitle: tvLocalized("A family-safe tvOS route for stories, beginner Qur'an, Arabic letters, and calm shared learning."),
      supportingLine: tvLocalized("Kids on tvOS stays aligned with the broader mobile kids direction, but is curated for shared television use, lighter navigation, and simple focus movement.")
    )
  }

  static func arabicHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Arabic"),
      title: tvLocalized("Arabic"),
      subtitle: tvLocalized("A calm tvOS Arabic route for letters, sounds, first words, and beginner Qur'anic recognition."),
      supportingLine: tvLocalized("Arabic on tvOS stays aligned with the shared Qur'anic Arabic direction, but rebuilds the interaction around seeing, hearing, and choosing from the sofa.")
    )
  }

  static func gamesHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Games"),
      title: tvLocalized("Games"),
      subtitle: tvLocalized("A calm tvOS games route for guided trivia, matching, and short family-room knowledge challenges."),
      supportingLine: tvLocalized("Games on tvOS stays aligned with the mobile learning direction, but reduces input friction and favors remote-friendly rounds.")
    )
  }

  static func favoritesHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Saved"),
      title: tvLocalized("Saved"),
      subtitle: tvLocalized("A calm tvOS saved route for Qur'an bookmarks, listening playlists, reflections, and watch-later return."),
      supportingLine: tvLocalized("Saved on tvOS stays aligned with the mobile bookmarks and resume direction, but turns it into a large-screen continuity surface instead of a dense manager.")
    )
  }

  static func settingsHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: "",
      title: tvLocalized("Settings"),
      subtitle: "",
      supportingLine: ""
    )
  }

  static func profilesHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Profiles"),
      title: tvLocalized("Profiles"),
      subtitle: tvLocalized("A calm tvOS household route for profile switching, family-room continuity, and shared-device safety."),
      supportingLine: tvLocalized("Profiles on tvOS stays aligned with the mobile shared-device direction, but keeps the Apple TV flow focused on quick switching rather than dense account management.")
    )
  }

  static func householdProfiles() -> [TVHouseholdProfile] {
    [
      TVHouseholdProfile(
        id: "family_room",
        avatar: "🌙",
        title: tvLocalized("Family room"),
        subtitle: tvLocalized("Shared Qur'an, prayer, and learning continuity for the main room."),
        supportingLine: tvLocalized("Best when the room needs one calm default profile with broad access and quick return into the core tvOS surfaces."),
        systemImage: "person.3.fill",
        audienceLabel: tvLocalized("Shared"),
        syncLabel: tvLocalized("Companion backup"),
        preferredRoute: .home
      ),
      TVHouseholdProfile(
        id: "parents",
        avatar: "📖",
        title: tvLocalized("Parents"),
        subtitle: tvLocalized("Adult-focused reading, listening, and reflection continuity for the household."),
        supportingLine: tvLocalized("Best for Qur'an listening, saved reflections, and routes that may later hand off to iPhone or iPad for deeper management."),
        systemImage: "book.closed.fill",
        audienceLabel: tvLocalized("Protected"),
        syncLabel: tvLocalized("Manual or remote backup"),
        preferredRoute: .quran
      ),
      TVHouseholdProfile(
        id: "kids_time",
        avatar: "⭐️",
        title: tvLocalized("Kids time"),
        subtitle: tvLocalized("Family-safe learning, stories, and gentle practice continuity for children."),
        supportingLine: tvLocalized("Best for guided kids use where route choices stay simpler and the room needs calm transitions into learning or short recitation."),
        systemImage: "figure.child.circle.fill",
        audienceLabel: tvLocalized("Guardian managed"),
        syncLabel: tvLocalized("Phone handoff"),
        preferredRoute: .kids
      ),
    ]
  }

  static func sessionContinuityCards(
    profiles: [TVHouseholdProfile],
    activeProfileId: String,
    lastRouteByProfileId: [String: TVRoute],
    lastOpenedAtByProfileId: [String: Date]
  ) -> [TVSessionContinuityCard] {
    profiles.map { profile in
      let route = lastRouteByProfileId[profile.id] ?? profile.preferredRoute
      let isActive = profile.id == activeProfileId
      return TVSessionContinuityCard(
        id: profile.id,
        eyebrow: isActive ? tvLocalized("Active now") : tvLocalized("Ready to resume"),
        title: profile.title,
        subtitle: tvLocalized("Continue with %@", tvLocalized(route.titleKey)),
        supportingLine: sessionTimeLabel(
          lastOpenedAtByProfileId[profile.id],
          route: route
        ),
        detailLine: tvLocalized("Best next return: %@", tvLocalized(route.titleKey)),
        systemImage: route.systemImage,
        route: route,
        chips: [
          profile.audienceLabel,
          profile.syncLabel,
          tvLocalized(route.titleKey),
        ]
      )
    }
  }

  private static func sessionTimeLabel(_ date: Date?, route: TVRoute) -> String {
    guard let date else {
      return tvLocalized("Prepared to reopen %@", tvLocalized(route.titleKey))
    }

    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    let relative = formatter.localizedString(for: date, relativeTo: Date())
    return tvLocalized("Last opened %@ %@", tvLocalized(route.titleKey), relative)
  }

  static func favoritesPrimaryItems() -> [TVLearnHubItem] {
    [
      TVLearnHubItem(
        id: "bookmarked_ayahs",
        eyebrow: tvLocalized("Qur'an return"),
        title: tvLocalized("Bookmarked ayahs"),
        subtitle: tvLocalized("Keep the ayahs and short surahs the household returns to most close to the first shelf."),
        supportingLine: tvLocalized("Best for resuming reading or reflection without searching from the sofa."),
        systemImage: "bookmark.fill"
      ),
      TVLearnHubItem(
        id: "listening_playlists",
        eyebrow: tvLocalized("Audio-first"),
        title: tvLocalized("Listening playlists"),
        subtitle: tvLocalized("Return to recitation sequences, repeat-ready passages, and calm listening queues with one remote-friendly entry."),
        supportingLine: tvLocalized("Best for family-room recitation, revision, and background listening with intention."),
        systemImage: "music.note.list"
      ),
      TVLearnHubItem(
        id: "watch_later_reflection",
        eyebrow: tvLocalized("Later return"),
        title: tvLocalized("Watch later and reflection"),
        subtitle: tvLocalized("Hold visual learning picks, prophet-story revisits, and saved reflection cards for a calmer later session."),
        supportingLine: tvLocalized("Best for signs, stories, and learning paths the household wants to reopen together."),
        systemImage: "clock.arrow.circlepath"
      ),
    ]
  }

  static func favoritesSavedItems() -> [TVSavedItemCard] {
    [
      TVSavedItemCard(
        id: "saved_fatihah_help",
        eyebrow: tvLocalized("Bookmarked ayah"),
        title: tvLocalized("Al-Fatihah 1:5"),
        subtitle: tvLocalized("You alone we worship, and You alone we ask for help."),
        supportingLine: tvLocalized("A familiar household return point for recitation, dua, and focused reflection."),
        detailLine: tvLocalized("Resume in the Qur'an reader from the bookmarked ayah and continue into the same short passage."),
        systemImage: "book.closed.fill",
        tags: [
          tvLocalized("Qur'an"),
          tvLocalized("Resume reading"),
          tvLocalized("Family recitation"),
        ]
      ),
      TVSavedItemCard(
        id: "saved_sharh_ease",
        eyebrow: tvLocalized("Saved reflection"),
        title: tvLocalized("Ash-Sharh 94:5-6"),
        subtitle: tvLocalized("Indeed, with hardship comes ease."),
        supportingLine: tvLocalized("A saved reflection return for evenings when the room needs comfort, sabr, and perspective."),
        detailLine: tvLocalized("Reopen the reflection path and the same verse pair without rebuilding the reading context."),
        systemImage: "sparkles",
        tags: [
          tvLocalized("Reflection"),
          tvLocalized("Watch later"),
          tvLocalized("Comfort"),
        ]
      ),
      TVSavedItemCard(
        id: "saved_ikhlas_queue",
        eyebrow: tvLocalized("Listening queue"),
        title: tvLocalized("Al-Ikhlas family recitation"),
        subtitle: tvLocalized("A short-surah listening playlist ready for repeat recitation and memorization support."),
        supportingLine: tvLocalized("Keeps a familiar short-surah queue close for family-room listening mode."),
        detailLine: tvLocalized("Resume listening mode with the saved reciter flow and short-surah sequence already prepared."),
        systemImage: "speaker.wave.2.fill",
        tags: [
          tvLocalized("Playlist"),
          tvLocalized("Listening mode"),
          tvLocalized("Short surahs"),
        ]
      ),
    ]
  }

  /// What Home offers to go on with. The first two open the Qur'an where
  /// the viewer left it, to read and to listen.
  static func homeContinueJourneyItems(quran: TVQuranViewModel) -> [TVContinueJourneyItem] {
    [
      TVContinueJourneyItem(
        id: "continue_reading",
        eyebrow: tvLocalized("Qur’an"),
        title: quran.continueReadingSummaryTitle,
        subtitle: quran.continueReadingLine,
        supportingLine: "",
        systemImage: "book.closed.fill"
      ),
      TVContinueJourneyItem(
        id: "resume_listening",
        eyebrow: tvLocalized("Qur’an"),
        title: tvLocalized("Listen"),
        subtitle: quran.place == nil
          ? tvLocalized("Recitation, ayah by ayah")
          : quran.continueReadingLine,
        supportingLine: "",
        systemImage: "headphones"
      ),
      TVContinueJourneyItem(
        id: "dhikr_routines",
        eyebrow: tvLocalized("Dhikr"),
        title: tvLocalized("Dhikr routines"),
        subtitle: tvLocalized("Routines to follow together"),
        supportingLine: "",
        systemImage: "sparkles"
      ),
    ]
  }

  /// "Al Ikhlas, Al Falaq and An Nas", joined the way the language joins.
  static func surahNames(_ numbers: [Int]) -> String {
    ListFormatter.localizedString(byJoining: numbers.map(surahName))
  }

  static func surahs(for numbers: [Int]) -> [TVQuranSurah] {
    quranSurahs.filter { numbers.contains($0.number) }
  }

  /// Groups of surahs the list can be opened at. Where the viewer left off
  /// and the verse of the day stand beside them on the screen and open at
  /// their ayah, so they are not groups here.
  static func quranBrowseCollections() -> [TVQuranBrowseCollection] {
    [
      TVQuranBrowseCollection(
        id: "short_surahs",
        eyebrow: "",
        title: tvLocalized("Short surahs"),
        subtitle: surahNames([112, 113, 114]),
        supportingLine: "",
        systemImage: "sparkles",
        surahNumbers: [112, 113, 114]
      ),
      TVQuranBrowseCollection(
        id: "opening_and_relief",
        eyebrow: "",
        title: tvLocalized("Opening and relief"),
        subtitle: surahNames([1, 94]),
        supportingLine: "",
        systemImage: "sun.max.fill",
        surahNumbers: [1, 94]
      ),
    ]
  }

  static func learnHero() -> TVHeroContent {
    TVHeroContent(
      eyebrow: tvLocalized("Learn"),
      title: "Path of Nūr",
      subtitle: tvLocalized("A curated large-screen Learn hub shaped for calm browsing, family-room study, and simple next steps."),
      supportingLine: tvLocalized("Learn on tvOS starts with guided paths and broad knowledge shelves instead of a dense mobile-style dashboard.")
    )
  }

  static func learnPrimaryItems() -> [TVLearnHubItem] {
    [
      TVLearnHubItem(
        id: "journey",
        eyebrow: tvLocalized("Start here"),
        title: tvLocalized("Learning Journey"),
        subtitle: tvLocalized("Open the journey-first path for guided study, structured growth, and a clear next lesson."),
        supportingLine: tvLocalized("Best for steady weekly learning with one strong path instead of scattered browsing."),
        systemImage: "point.topleft.down.curvedto.point.bottomright.up.fill"
      ),
      TVLearnHubItem(
        id: "explore",
        eyebrow: tvLocalized("Browse all"),
        title: tvLocalized("Explore all knowledge"),
        subtitle: tvLocalized("Move across the main Learn domains without leaving one calm master layout."),
        supportingLine: tvLocalized("Best for evening browsing, family discovery, and choosing a topic together."),
        systemImage: "safari.fill"
      ),
      TVLearnHubItem(
        id: "family",
        eyebrow: tvLocalized("Family room"),
        title: tvLocalized("Family-safe learning"),
        subtitle: tvLocalized("Surface stories, reflection, and calm educational shelves that fit shared viewing."),
        supportingLine: tvLocalized("Best for mixed-age household use where simple choices matter more than deep controls."),
        systemImage: "person.3.fill"
      ),
    ]
  }

  static func kidsPrimaryItems() -> [TVLearnHubItem] {
    [
      TVLearnHubItem(
        id: "stories",
        eyebrow: tvLocalized("Stories"),
        title: tvLocalized("Prophet stories for the room"),
        subtitle: tvLocalized("Open short, trusted story sessions built for mixed ages, simple focus movement, and family discussion."),
        supportingLine: tvLocalized("Best for shared evening learning where one calm story is stronger than a dense library."),
        systemImage: "book.pages.fill"
      ),
      TVLearnHubItem(
        id: "quran",
        eyebrow: tvLocalized("Qur'an"),
        title: tvLocalized("Short surahs and listening"),
        subtitle: tvLocalized("Keep beginner-friendly recitation, short surahs, and repeatable listening close to the biggest screen in the home."),
        supportingLine: tvLocalized("Best for family recitation, memorization support, and gentle return to familiar passages."),
        systemImage: "book.closed.fill"
      ),
      TVLearnHubItem(
        id: "arabic",
        eyebrow: tvLocalized("Beginner"),
        title: tvLocalized("Arabic letters and sounds"),
        subtitle: tvLocalized("Use large visuals and simple selection to introduce letters, sounds, and first recognition on TV."),
        supportingLine: tvLocalized("Best for early learners who benefit from repetition, shape recognition, and shared guidance from a parent."),
        systemImage: "character.book.closed.fill"
      ),
      TVLearnHubItem(
        id: "bedtime",
        eyebrow: tvLocalized("Night"),
        title: tvLocalized("Bedtime return"),
        subtitle: tvLocalized("End the evening with one quiet story, short remembrance, or a gentle Qur'an return before leaving the screen."),
        supportingLine: tvLocalized("Best for calmer household transitions when the television should support routine rather than prolong it."),
        systemImage: "moon.stars.fill"
      ),
    ]
  }

  static func kidsFeaturedStories() -> [TVLearnStoryEntry] {
    [
      TVLearnStoryEntry(
        id: "nuh",
        eyebrow: tvLocalized("Prophet story"),
        title: tvLocalized("Prophet Nuh and steady trust"),
        subtitle: tvLocalized("A short family-safe retelling about patience, obedience, and trusting Allah over a long effort."),
        supportingLine: tvLocalized("Works well on TV because the lesson is clear, discussion-friendly, and safe for mixed ages."),
        systemImage: "water.waves",
        takeawayPoints: [
          tvLocalized("Steady effort can continue even when results do not come quickly."),
          tvLocalized("Prophets stayed obedient to Allah through difficulty and long waiting."),
          tvLocalized("Families can talk about patience in a way children can understand."),
        ],
        reflectionPrompt: tvLocalized("Ask the room: what does patience look like when something good takes time?")
      ),
      TVLearnStoryEntry(
        id: "ibrahim",
        eyebrow: tvLocalized("Prophet story"),
        title: tvLocalized("Prophet Ibrahim and courage"),
        subtitle: tvLocalized("A simple story path about standing for truth with trust in Allah and calm courage."),
        supportingLine: tvLocalized("Strong for family viewing because the moral lesson is memorable without needing long explanations."),
        systemImage: "flame.fill",
        takeawayPoints: [
          tvLocalized("Courage grows from trusting Allah, not from showing off."),
          tvLocalized("Children can learn that standing for truth sometimes feels lonely."),
          tvLocalized("Parents can connect courage to everyday honesty and worship."),
        ],
        reflectionPrompt: tvLocalized("Ask the room: where can we be brave and truthful this week?")
      ),
      TVLearnStoryEntry(
        id: "yunus",
        eyebrow: tvLocalized("Mercy"),
        title: tvLocalized("Prophet Yunus and returning to Allah"),
        subtitle: tvLocalized("A gentle reminder that mistakes do not close the door to dua, repentance, and Allah's mercy."),
        supportingLine: tvLocalized("Useful for children because it teaches hopeful return without heavy detail or fear-led framing."),
        systemImage: "fish.fill",
        takeawayPoints: [
          tvLocalized("A child can always return to Allah after a mistake."),
          tvLocalized("Dua is part of turning back with humility and hope."),
          tvLocalized("Mercy and repentance should stay stronger than shame in kids teaching."),
        ],
        reflectionPrompt: tvLocalized("Ask the room: what can we say or do when we want to turn back to Allah?")
      ),
    ]
  }

  static func arabicPrimaryItems() -> [TVLearnHubItem] {
    [
      TVLearnHubItem(
        id: "letters",
        eyebrow: tvLocalized("Start here"),
        title: tvLocalized("Letter families"),
        subtitle: tvLocalized("Learn the alphabet in calm grouped sets so the room can recognize shapes and sounds without overload."),
        supportingLine: tvLocalized("Best for first exposure, review after a gap, and mixed-age family guidance."),
        systemImage: "square.grid.3x3.fill"
      ),
      TVLearnHubItem(
        id: "listen",
        eyebrow: tvLocalized("Audio-first"),
        title: tvLocalized("Listen and repeat"),
        subtitle: tvLocalized("Use short sound-led practice so learners can hear a letter family, then repeat together in the room."),
        supportingLine: tvLocalized("Best for beginners who need confidence before reading from denser pages."),
        systemImage: "waveform"
      ),
      TVLearnHubItem(
        id: "words",
        eyebrow: tvLocalized("First reading"),
        title: tvLocalized("First words"),
        subtitle: tvLocalized("Move from single letters into simple joined forms and early Qur'anic vocabulary with large readable examples."),
        supportingLine: tvLocalized("Best for learners ready to connect shapes, sounds, and familiar short words."),
        systemImage: "character.textbox.ar"
      ),
      TVLearnHubItem(
        id: "readiness",
        eyebrow: tvLocalized("Qur'an bridge"),
        title: tvLocalized("Qur'an readiness"),
        subtitle: tvLocalized("Hand off into the shared readiness path once letters and first words feel familiar enough for short ayah snippets."),
        supportingLine: tvLocalized("Best for learners who are ready to connect Arabic practice back to the Qur'an without leaving beginner mode."),
        systemImage: "book.closed.circle.fill"
      ),
    ]
  }

  static func gamesPrimaryItems() -> [TVLearnHubItem] {
    [
      TVLearnHubItem(
        id: "trivia",
        eyebrow: tvLocalized("Quick play"),
        title: tvLocalized("Trivia rounds"),
        subtitle: tvLocalized("Use short multiple-choice rounds that work well from the sofa and still reinforce real learning goals."),
        supportingLine: tvLocalized("Best for steady knowledge recall without turning the TV into a rapid-fire arcade surface."),
        systemImage: "bolt.fill"
      ),
      TVLearnHubItem(
        id: "matching",
        eyebrow: tvLocalized("Recognition"),
        title: tvLocalized("Matching review"),
        subtitle: tvLocalized("Practice simple concept pairing with visually clear options instead of drag-and-drop interactions that do not fit tvOS."),
        supportingLine: tvLocalized("Best for worship terms, prophets, and beginner review where recognition matters more than speed."),
        systemImage: "square.grid.2x2.fill"
      ),
      TVLearnHubItem(
        id: "family",
        eyebrow: tvLocalized("Together"),
        title: tvLocalized("Family challenge night"),
        subtitle: tvLocalized("Choose discussion-friendly rounds that let the room answer together, reflect briefly, and move on without pressure."),
        supportingLine: tvLocalized("Best for mixed ages where one shared answer rhythm is stronger than private turn-taking loops."),
        systemImage: "person.3.fill"
      ),
      TVLearnHubItem(
        id: "review",
        eyebrow: tvLocalized("Follow-up"),
        title: tvLocalized("Review mistakes gently"),
        subtitle: tvLocalized("Use short repeatable challenges to revisit weak spots without scoreboard pressure or noisy rewards."),
        supportingLine: tvLocalized("Best for learning continuity after trivia or matching sessions on other devices."),
        systemImage: "arrow.uturn.backward.circle.fill"
      ),
    ]
  }

  static func gamesChallengeCards() -> [TVGamesChallengeCard] {
    [
      TVGamesChallengeCard(
        id: "trivia_opening",
        eyebrow: tvLocalized("Trivia"),
        title: tvLocalized("Opening-surah basics"),
        subtitle: tvLocalized("A short recall prompt that keeps Qur'an learning remote-friendly and low pressure."),
        supportingLine: tvLocalized("Strong for quick room-wide participation because one answer can be chosen together."),
        systemImage: "questionmark.circle.fill",
        prompt: tvLocalized("Which surah is known as The Opening?"),
        promptSupport: tvLocalized("Choose the answer that best matches a foundational Qur'an title many learners hear early."),
        options: [
          TVGamesChallengeOption(
            id: "fatihah",
            title: tvLocalized("Al-Fatihah"),
            supportingLine: tvLocalized("The opening surah recited in every rak'ah."),
            isCorrect: true,
            feedbackTitle: tvLocalized("Correct answer"),
            feedbackBody: tvLocalized("Al-Fatihah means The Opening and remains one of the strongest early-recognition anchors for family learning.")
          ),
          TVGamesChallengeOption(
            id: "ikhlas",
            title: tvLocalized("Al-Ikhlas"),
            supportingLine: tvLocalized("A short surah about Allah's oneness."),
            isCorrect: false,
            feedbackTitle: tvLocalized("Almost"),
            feedbackBody: tvLocalized("Al-Ikhlas is a strong short-surah review choice, but The Opening refers to Al-Fatihah.")
          ),
          TVGamesChallengeOption(
            id: "nas",
            title: tvLocalized("An-Nas"),
            supportingLine: tvLocalized("A short surah seeking refuge with the Lord of mankind."),
            isCorrect: false,
            feedbackTitle: tvLocalized("Try again"),
            feedbackBody: tvLocalized("An-Nas is often learned early too, but the title The Opening belongs to Al-Fatihah.")
          ),
        ]
      ),
      TVGamesChallengeCard(
        id: "matching_prayer",
        eyebrow: tvLocalized("Matching"),
        title: tvLocalized("Prayer-time pairing"),
        subtitle: tvLocalized("A recognition-first matching prompt adapted for simple left-right remote movement."),
        supportingLine: tvLocalized("This keeps matching educational on TV without drag-and-drop or typing."),
        systemImage: "link.circle.fill",
        prompt: tvLocalized("Which pair matches correctly?"),
        promptSupport: tvLocalized("Pick the prayer and time-of-day pairing that stays accurate."),
        options: [
          TVGamesChallengeOption(
            id: "fajr_dawn",
            title: tvLocalized("Fajr and dawn"),
            supportingLine: tvLocalized("The first daily prayer belongs to the start of the day."),
            isCorrect: true,
            feedbackTitle: tvLocalized("Correct answer"),
            feedbackBody: tvLocalized("Fajr is the dawn prayer, which makes it a clean and natural matching prompt for family review.")
          ),
          TVGamesChallengeOption(
            id: "isha_noon",
            title: tvLocalized("Isha and noon"),
            supportingLine: tvLocalized("A late prayer paired with the middle of the day."),
            isCorrect: false,
            feedbackTitle: tvLocalized("Not this one"),
            feedbackBody: tvLocalized("Isha belongs to the night. Noon is connected with Dhuhr instead.")
          ),
          TVGamesChallengeOption(
            id: "asr_sunrise",
            title: tvLocalized("Asr and sunrise"),
            supportingLine: tvLocalized("An afternoon prayer paired with the start of the morning."),
            isCorrect: false,
            feedbackTitle: tvLocalized("Not quite"),
            feedbackBody: tvLocalized("Asr belongs to the afternoon, so sunrise is not the correct match.")
          ),
        ]
      ),
      TVGamesChallengeCard(
        id: "prophets_review",
        eyebrow: tvLocalized("Story review"),
        title: tvLocalized("Returning to Allah"),
        subtitle: tvLocalized("A calm prophets-and-lessons challenge built for discussion after the answer is chosen."),
        supportingLine: tvLocalized("Best for family-room reflection because the explanation matters as much as the score."),
        systemImage: "sparkles.rectangle.stack.fill",
        prompt: tvLocalized("Which prophet is strongly associated with turning back to Allah after hardship in the sea?"),
        promptSupport: tvLocalized("Choose the prophet whose story helps children and adults remember repentance and mercy."),
        options: [
          TVGamesChallengeOption(
            id: "yunus",
            title: tvLocalized("Prophet Yunus"),
            supportingLine: tvLocalized("A story often used to teach hopeful return to Allah."),
            isCorrect: true,
            feedbackTitle: tvLocalized("Correct answer"),
            feedbackBody: tvLocalized("The story of Prophet Yunus is a strong family teaching point about repentance, dua, and Allah's mercy.")
          ),
          TVGamesChallengeOption(
            id: "musa",
            title: tvLocalized("Prophet Musa"),
            supportingLine: tvLocalized("A prophet of courage, guidance, and major signs."),
            isCorrect: false,
            feedbackTitle: tvLocalized("Good effort"),
            feedbackBody: tvLocalized("Prophet Musa has many lessons, but this challenge points to Prophet Yunus and the theme of returning to Allah.")
          ),
          TVGamesChallengeOption(
            id: "nuh",
            title: tvLocalized("Prophet Nuh"),
            supportingLine: tvLocalized("A prophet strongly tied to patience and long trust in Allah."),
            isCorrect: false,
            feedbackTitle: tvLocalized("Close, but not this one"),
            feedbackBody: tvLocalized("Prophet Nuh is a strong lesson in patience, while this prompt points more directly to Prophet Yunus.")
          ),
        ]
      ),
    ]
  }

  static func arabicLetterGroups() -> [TVArabicLetterGroup] {
    [
      TVArabicLetterGroup(
        id: "opening_letters",
        eyebrow: tvLocalized("Group 1"),
        title: tvLocalized("Opening sounds"),
        subtitle: tvLocalized("Begin with familiar early letters that are visually distinct and easy to repeat together."),
        supportingLine: tvLocalized("A strong first group for shape recognition and steady sound practice."),
        letters: ["ا", "ب", "ت", "ث"],
        exampleSound: tvLocalized("Say together: alif, ba, ta, tha"),
        focusPoints: [
          tvLocalized("Notice how the dots change while the base shape stays related."),
          tvLocalized("Keep the pace slow enough for the whole room to repeat."),
          tvLocalized("Use this group before moving into joined beginner words."),
        ]
      ),
      TVArabicLetterGroup(
        id: "breath_letters",
        eyebrow: tvLocalized("Group 2"),
        title: tvLocalized("Breath and throat letters"),
        subtitle: tvLocalized("Introduce letters that need a little more listening attention before they feel natural."),
        supportingLine: tvLocalized("Best for hearing differences gently instead of trying to perfect them immediately."),
        letters: ["ج", "ح", "خ"],
        exampleSound: tvLocalized("Say together: jeem, ha, kha"),
        focusPoints: [
          tvLocalized("These sounds are easier when heard clearly first and repeated without pressure."),
          tvLocalized("Large visuals help learners keep the letter identity steady while the sound changes."),
          tvLocalized("Do not turn this into correction-heavy practice on TV."),
        ]
      ),
      TVArabicLetterGroup(
        id: "flow_letters",
        eyebrow: tvLocalized("Group 3"),
        title: tvLocalized("Light flowing letters"),
        subtitle: tvLocalized("Use smooth letters that often appear in familiar short words and recitation phrases."),
        supportingLine: tvLocalized("A good bridge from isolated letters into reading rhythm."),
        letters: ["د", "ذ", "ر", "ز"],
        exampleSound: tvLocalized("Say together: dal, dhal, ra, zay"),
        focusPoints: [
          tvLocalized("This group helps the room notice how small marks can change sound quickly."),
          tvLocalized("These letters work well for early word building because they are short and repeatable."),
          tvLocalized("Use them to prepare for simple joined-form examples."),
        ]
      ),
      TVArabicLetterGroup(
        id: "strong_letters",
        eyebrow: tvLocalized("Group 4"),
        title: tvLocalized("Strong familiar letters"),
        subtitle: tvLocalized("Bring in letters often heard in Qur'an and dhikr so Arabic study connects back to worship."),
        supportingLine: tvLocalized("A good family-room group because the sounds may already feel familiar from recitation."),
        letters: ["س", "ص", "ل", "م"],
        exampleSound: tvLocalized("Say together: seen, sad, lam, meem"),
        focusPoints: [
          tvLocalized("Connect these letters to familiar recitation without turning the route into a tajweed lesson."),
          tvLocalized("Recognition and confidence matter more than technical detail at this stage."),
          tvLocalized("This group creates a natural bridge into short Qur'an snippets and known words."),
        ]
      ),
    ]
  }

  static func learnSections() -> [TVLearnHubSection] {
    [
      TVLearnHubSection(
        id: "stories_reflection",
        title: tvLocalized("Stories and reflection"),
        subtitle: tvLocalized("The strongest TV-friendly Learn families: story, meaning, and short reflective return."),
        items: [
          TVLearnHubItem(
            id: "prophets",
            eyebrow: tvLocalized("Stories"),
            title: tvLocalized("Prophets"),
            subtitle: tvLocalized("Revisit prophetic lives through a simple story-first entry point built for shared viewing."),
            supportingLine: tvLocalized("A natural TV fit because narrative content works better than dense reading lists."),
            systemImage: "book.pages.fill"
          ),
          TVLearnHubItem(
            id: "seerah",
            eyebrow: tvLocalized("Companion"),
            title: tvLocalized("Seerah"),
            subtitle: tvLocalized("Keep the Prophetic biography close through guided viewing paths and calm reflection."),
            supportingLine: tvLocalized("Useful for family-room learning because it supports listening, discussion, and repeat visits."),
            systemImage: "sparkles"
          ),
          TVLearnHubItem(
            id: "daily_wisdom",
            eyebrow: tvLocalized("Short return"),
            title: tvLocalized("Daily Wisdom"),
            subtitle: tvLocalized("Use short reflective prompts for a brief shared learning moment on the main TV."),
            supportingLine: tvLocalized("Best for quiet evening use when the room wants one meaningful reminder, not a long lesson."),
            systemImage: "sun.max.fill"
          ),
        ]
      ),
      TVLearnHubSection(
        id: "knowledge_domains",
        title: tvLocalized("Knowledge domains"),
        subtitle: tvLocalized("Broad content shelves that can expand later without changing the master layout."),
        items: [
          TVLearnHubItem(
            id: "hadith",
            eyebrow: tvLocalized("Knowledge"),
            title: tvLocalized("Hadith"),
            subtitle: tvLocalized("Open short thematic hadith learning through calmer browse-first entry points."),
            supportingLine: tvLocalized("A strong fit for TV when presented as themed selections instead of dense study controls."),
            systemImage: "text.book.closed.fill"
          ),
          TVLearnHubItem(
            id: "world_creation",
            eyebrow: tvLocalized("Signs"),
            title: tvLocalized("World and Creation"),
            subtitle: tvLocalized("Bring visual learning and signs in creation into a format that suits the largest screen in the home."),
            supportingLine: tvLocalized("Especially strong for future TV because creation content benefits from scale and shared viewing."),
            systemImage: "globe.europe.africa.fill"
          ),
          TVLearnHubItem(
            id: "life_lessons",
            eyebrow: tvLocalized("Practice"),
            title: tvLocalized("Life lessons"),
            subtitle: tvLocalized("Use practical Islamic guidance shelves for daily questions, adab, and thoughtful living."),
            supportingLine: tvLocalized("Works best on TV as curated themes, not long searchable forms or dense text controls."),
            systemImage: "leaf.fill"
          ),
        ]
      ),
    ]
  }

  static func learnStoryCollection(for itemID: String) -> TVLearnStoryCollection {
    switch itemID {
    case "prophets":
      return prophetsStoryCollection()
    case "seerah":
      return seerahStoryCollection()
    case "daily_wisdom":
      return dailyWisdomCollection()
    default:
      return learnStoryPreviewCollection()
    }
  }

  static func learnVisualCollection(for itemID: String) -> TVLearnVisualCollection {
    switch itemID {
    case "world_creation":
      return creationVisualCollection()
    default:
      return learnVisualPreviewCollection()
    }
  }

  static func learnStoryPreviewCollection() -> TVLearnStoryCollection {
    TVLearnStoryCollection(
      id: "learn_preview",
      title: tvLocalized("Featured stories and reflection"),
      subtitle: tvLocalized("Choose one story or reflection return, then keep the room in one calm shared learning flow."),
      supportingLine: tvLocalized("The Learn route now gives story and reflection content a stable television home without fragmenting the shell."),
      entries: [
        TVLearnStoryEntry(
          id: "preview_prophets",
          eyebrow: tvLocalized("Prophetic path"),
          title: tvLocalized("Prophets for shared viewing"),
          subtitle: tvLocalized("Begin with familiar prophetic stories that carry clear lessons for the whole room."),
          supportingLine: tvLocalized("Story-first learning remains the easiest and strongest large-screen Learn entry."),
          systemImage: "book.pages.fill",
          takeawayPoints: [
            tvLocalized("Prophetic stories help the room gather around patience, trust, and worship."),
            tvLocalized("A good TV story card should stay simple enough to discuss without turning into a lecture."),
          ],
          reflectionPrompt: tvLocalized("Which prophetic quality does the household need most this week?")
        ),
        TVLearnStoryEntry(
          id: "preview_seerah",
          eyebrow: tvLocalized("Companion path"),
          title: tvLocalized("Seerah turning points"),
          subtitle: tvLocalized("Keep a few major moments from the Prophet's life close for calm return visits."),
          supportingLine: tvLocalized("Seerah works well on TV when it stays focused on meaning, mercy, and steady remembrance."),
          systemImage: "sparkles",
          takeawayPoints: [
            tvLocalized("Large-screen Seerah should prioritize memorable moments and practical lessons."),
            tvLocalized("The strongest next step is often one clear moment, not an entire timeline at once."),
          ],
          reflectionPrompt: tvLocalized("What Prophetic quality should shape the atmosphere of the home tonight?")
        ),
        TVLearnStoryEntry(
          id: "preview_wisdom",
          eyebrow: tvLocalized("Quiet return"),
          title: tvLocalized("Daily Wisdom"),
          subtitle: tvLocalized("End the Learn route with one gentle reminder that invites action without heavy input."),
          supportingLine: tvLocalized("Reflection content is strongest on TV when it opens discussion and then gets out of the way."),
          systemImage: "sun.max.fill",
          takeawayPoints: [
            tvLocalized("Short reminders help Learn stay re-openable on the main television."),
            tvLocalized("Reflection should guide the room back into worship, patience, and gratitude."),
          ],
          reflectionPrompt: tvLocalized("What is one small action the room can carry from this reminder into tonight?")
        ),
      ]
    )
  }

  static func prophetsStoryCollection() -> TVLearnStoryCollection {
    TVLearnStoryCollection(
      id: "prophets",
      title: tvLocalized("Prophetic stories for shared viewing"),
      subtitle: tvLocalized("Start with well-known prophetic moments that carry clear lessons without dense study controls."),
      supportingLine: tvLocalized("Narrative-first learning is the strongest fit for the first tvOS stories phase."),
      entries: [
        TVLearnStoryEntry(
          id: "prophet_nuh",
          eyebrow: tvLocalized("Steadfastness"),
          title: tvLocalized("Nuh"),
          subtitle: tvLocalized("A long call to truth, patience, and trust in Allah even when response is slow."),
          supportingLine: tvLocalized("Good for family discussion about perseverance, obedience, and sincerity."),
          systemImage: "water.waves",
          takeawayPoints: [
            tvLocalized("Truth may require patience over a long stretch before results appear."),
            tvLocalized("Steadfast work still matters when the room feels unseen or discouraged."),
            tvLocalized("A believer keeps calling to what is right with mercy and endurance."),
          ],
          reflectionPrompt: tvLocalized("Where does the household need patience and steadiness right now?")
        ),
        TVLearnStoryEntry(
          id: "prophet_ibrahim",
          eyebrow: tvLocalized("Tawhid"),
          title: tvLocalized("Ibrahim"),
          subtitle: tvLocalized("A story of certainty, trust, and surrender when obeying Allah required courage."),
          supportingLine: tvLocalized("A strong return for conversations about worship, trust, and leaving false attachments."),
          systemImage: "flame.fill",
          takeawayPoints: [
            tvLocalized("Faith becomes visible when truth matters more than comfort."),
            tvLocalized("Trust in Allah can remain firm even when a path feels uncertain."),
            tvLocalized("Ibrahim's life keeps returning the heart to pure worship."),
          ],
          reflectionPrompt: tvLocalized("What distraction or attachment should the room loosen for Allah's sake?")
        ),
        TVLearnStoryEntry(
          id: "prophet_musa",
          eyebrow: tvLocalized("Courage"),
          title: tvLocalized("Musa"),
          subtitle: tvLocalized("A reminder that Allah opens a way forward even when fear and pressure feel overwhelming."),
          supportingLine: tvLocalized("Useful when the room needs courage, honesty, and reliance on Allah."),
          systemImage: "figure.walk.motion",
          takeawayPoints: [
            tvLocalized("Allah can open relief where no easy path seems visible."),
            tvLocalized("Speaking truth takes courage, but fear does not cancel duty."),
            tvLocalized("Musa's story teaches reliance without passivity."),
          ],
          reflectionPrompt: tvLocalized("What current worry should be met with courage and tawakkul instead of panic?")
        ),
        TVLearnStoryEntry(
          id: "prophet_yusuf",
          eyebrow: tvLocalized("Patience"),
          title: tvLocalized("Yusuf"),
          subtitle: tvLocalized("A story of purity, sabr, and forgiveness through hardship, separation, and reunion."),
          supportingLine: tvLocalized("Helpful for reflection on family strain, dignity, and mercy."),
          systemImage: "leaf.fill",
          takeawayPoints: [
            tvLocalized("Purity and dignity matter even in private pressure."),
            tvLocalized("Hardship does not erase Allah's plan or mercy."),
            tvLocalized("Forgiveness can become a mark of real strength."),
          ],
          reflectionPrompt: tvLocalized("Where can the household choose dignity, patience, or forgiveness today?")
        ),
      ]
    )
  }

  static func seerahStoryCollection() -> TVLearnStoryCollection {
    TVLearnStoryCollection(
      id: "seerah",
      title: tvLocalized("Seerah turning points"),
      subtitle: tvLocalized("Keep a few major moments from the Prophet's life close for calm family-room reflection."),
      supportingLine: tvLocalized("Seerah on TV should stay focused on mercy, endurance, and a lived example worth revisiting."),
      entries: [
        TVLearnStoryEntry(
          id: "seerah_makkah",
          eyebrow: tvLocalized("Beginnings"),
          title: tvLocalized("Makkah endurance"),
          subtitle: tvLocalized("The earliest years teach steady worship, patience under pressure, and trust in Allah's promise."),
          supportingLine: tvLocalized("A strong starting point when the room needs quiet resilience."),
          systemImage: "moon.stars.fill",
          takeawayPoints: [
            tvLocalized("Early Seerah returns the heart to patience before outward victory."),
            tvLocalized("Steady worship and truthfulness were foundational from the beginning."),
            tvLocalized("Small faithful acts can anchor the whole home."),
          ],
          reflectionPrompt: tvLocalized("What faithful habit should the home protect even when life feels pressured?")
        ),
        TVLearnStoryEntry(
          id: "seerah_hijrah",
          eyebrow: tvLocalized("Trust"),
          title: tvLocalized("The Hijrah"),
          subtitle: tvLocalized("Leaving Makkah reminds the room that sacrifice for Allah opens new doors and new responsibility."),
          supportingLine: tvLocalized("Useful when the household needs perspective on change, trust, and courage."),
          systemImage: "paperplane.fill",
          takeawayPoints: [
            tvLocalized("Sacrifice for Allah is not loss when it protects faith."),
            tvLocalized("The Hijrah joins courage with planning and trust."),
            tvLocalized("Big transitions can still be carried with serenity."),
          ],
          reflectionPrompt: tvLocalized("What change in the household needs more trust in Allah and wiser preparation?")
        ),
        TVLearnStoryEntry(
          id: "seerah_madinah",
          eyebrow: tvLocalized("Community"),
          title: tvLocalized("Madinah brotherhood"),
          subtitle: tvLocalized("Building community in Madinah shows that faith should shape how people care for one another."),
          supportingLine: tvLocalized("Helpful for discussing hospitality, service, and living Islam together."),
          systemImage: "person.2.fill",
          takeawayPoints: [
            tvLocalized("Real learning should increase care, generosity, and mercy between people."),
            tvLocalized("The Prophet's example built community through service, not image."),
            tvLocalized("A faithful home is strengthened by mutual support."),
          ],
          reflectionPrompt: tvLocalized("How can the room strengthen care for one another before the week ends?")
        ),
        TVLearnStoryEntry(
          id: "seerah_mercy",
          eyebrow: tvLocalized("Mercy"),
          title: tvLocalized("A mercy-led return"),
          subtitle: tvLocalized("The Prophet's life keeps returning the room to mercy, restraint, and concern for hearts."),
          supportingLine: tvLocalized("A calmer closing card for shared discussion about character and emotional tone."),
          systemImage: "heart.fill",
          takeawayPoints: [
            tvLocalized("Mercy is not weakness; it is a sign of guided strength."),
            tvLocalized("Character shapes how knowledge is felt inside the home."),
            tvLocalized("The Seerah should soften the room, not only inform it."),
          ],
          reflectionPrompt: tvLocalized("What would a more merciful response look like in the next family difficulty?")
        ),
      ]
    )
  }

  static func dailyWisdomCollection() -> TVLearnStoryCollection {
    TVLearnStoryCollection(
      id: "daily_wisdom",
      title: tvLocalized("Short reflective returns"),
      subtitle: tvLocalized("These smaller returns work when the room needs one meaningful reminder and then quiet."),
      supportingLine: tvLocalized("Daily wisdom should stay simple enough to reopen often without feeling like a lesson backlog."),
      entries: [
        TVLearnStoryEntry(
          id: "wisdom_intention",
          eyebrow: tvLocalized("Renewal"),
          title: tvLocalized("Start with intention"),
          subtitle: tvLocalized("A small renewal of intention can turn ordinary effort back toward worship and sincerity."),
          supportingLine: tvLocalized("Good for reopening Learn when attention is low but the room still wants a meaningful start."),
          systemImage: "sparkle",
          takeawayPoints: [
            tvLocalized("A sincere intention can quietly reshape the whole mood of an evening."),
            tvLocalized("Renewal is often more useful than waiting for perfect momentum."),
            tvLocalized("Simple beginnings are part of a stable learning rhythm."),
          ],
          reflectionPrompt: tvLocalized("What intention should guide the room before the next task begins?")
        ),
        TVLearnStoryEntry(
          id: "wisdom_salah",
          eyebrow: tvLocalized("Return"),
          title: tvLocalized("Return to salah"),
          subtitle: tvLocalized("Prayer remains the clearest reset when the day feels crowded, rushed, or spiritually thin."),
          supportingLine: tvLocalized("A strong transition card from Learn back toward worship."),
          systemImage: "clock.fill",
          takeawayPoints: [
            tvLocalized("Salah restores order when attention feels scattered."),
            tvLocalized("A calm reminder can return the room to worship without pressure."),
            tvLocalized("The best next step after reflection is often a faithful act."),
          ],
          reflectionPrompt: tvLocalized("What would help the room honor the next prayer with more presence?")
        ),
        TVLearnStoryEntry(
          id: "wisdom_tongue",
          eyebrow: tvLocalized("Guarding"),
          title: tvLocalized("Protect the tongue"),
          subtitle: tvLocalized("A quiet home is shaped by truthful, restrained, and merciful speech."),
          supportingLine: tvLocalized("Helpful after tense days or when the room needs gentler conversation."),
          systemImage: "quote.bubble.fill",
          takeawayPoints: [
            tvLocalized("Speech can either calm the room or make hearts heavier."),
            tvLocalized("Restraint is often the wiser response than quick reaction."),
            tvLocalized("Good manners make knowledge feel believable."),
          ],
          reflectionPrompt: tvLocalized("What kind of speech would bring more calm into the home tonight?")
        ),
        TVLearnStoryEntry(
          id: "wisdom_gratitude",
          eyebrow: tvLocalized("Shukr"),
          title: tvLocalized("Quiet gratitude"),
          subtitle: tvLocalized("Notice one mercy, name it, and let gratitude reset the emotional tone of the room."),
          supportingLine: tvLocalized("A good closing reflection when the room needs softness instead of more information."),
          systemImage: "hands.sparkles.fill",
          takeawayPoints: [
            tvLocalized("Gratitude can make the ordinary feel seen again."),
            tvLocalized("A thankful home often becomes a calmer home."),
            tvLocalized("Small mercies are worth naming together."),
          ],
          reflectionPrompt: tvLocalized("What mercy from Allah can the household name together before leaving this screen?")
        ),
      ]
    )
  }

  static func learnVisualPreviewCollection() -> TVLearnVisualCollection {
    TVLearnVisualCollection(
      id: "visual_preview",
      title: tvLocalized("Signs and visual learning"),
      subtitle: tvLocalized("Creation-focused learning works best on TV when the room can observe one strong sign at a time."),
      supportingLine: tvLocalized("Large-screen visual learning should guide wonder, humility, and conversation without becoming a technical documentary."),
      entries: [
        TVLearnVisualEntry(
          id: "visual_preview_sky",
          eyebrow: tvLocalized("Sky"),
          title: tvLocalized("Sky and order"),
          subtitle: tvLocalized("Look at scale, rhythm, and repeated order in creation with a calm viewing-first approach."),
          supportingLine: tvLocalized("A good family-room entry because everyone can observe together before reading more."),
          systemImage: "sparkles",
          accentLabel: tvLocalized("Observe and reflect"),
          takeawayPoints: [
            tvLocalized("Visual Learn cards should begin with awe, then move into gratitude and humility."),
            tvLocalized("The room needs one strong sign, not a crowded lesson list."),
          ],
          observationPrompt: tvLocalized("What part of creation most quickly brings the room back to wonder in Allah's signs?")
        ),
        TVLearnVisualEntry(
          id: "visual_preview_life",
          eyebrow: tvLocalized("Life"),
          title: tvLocalized("Life, water, and mercy"),
          subtitle: tvLocalized("Keep the connection between provision, living systems, and gratitude close to the main Learn route."),
          supportingLine: tvLocalized("Strong for television because it supports observation and discussion without heavy controls."),
          systemImage: "drop.fill",
          accentLabel: tvLocalized("Mercy in creation"),
          takeawayPoints: [
            tvLocalized("Creation lessons should lead back to thankfulness and stewardship."),
            tvLocalized("A calm visual prompt can open better family discussion than a dense facts page."),
          ],
          observationPrompt: tvLocalized("Which everyday mercy in creation is easiest for the household to overlook?")
        ),
      ]
    )
  }

  static func creationVisualCollection() -> TVLearnVisualCollection {
    TVLearnVisualCollection(
      id: "world_creation",
      title: tvLocalized("Signs in creation"),
      subtitle: tvLocalized("Bring observation-first creation learning to the television with large visuals, simple comparisons, and calm prompts."),
      supportingLine: tvLocalized("This stage adapts the mobile World and Creation direction into a family-room learning surface."),
      entries: [
        TVLearnVisualEntry(
          id: "creation_celestial",
          eyebrow: tvLocalized("Celestial"),
          title: tvLocalized("Sun, moon, and measured rhythm"),
          subtitle: tvLocalized("A large-screen reminder that movement, cycles, and timing in creation point toward order rather than randomness."),
          supportingLine: tvLocalized("Strong for shared viewing because the whole room can immediately picture the sign."),
          systemImage: "moon.stars.fill",
          accentLabel: tvLocalized("Rhythm and order"),
          takeawayPoints: [
            tvLocalized("The sky teaches measured order and repeated return, not chaos."),
            tvLocalized("Visual learning here should lead the heart toward humility and trust in divine wisdom."),
            tvLocalized("A calm TV surface can keep the sign memorable without over-explaining it."),
          ],
          observationPrompt: tvLocalized("How does repeated order in the sky change the way the room thinks about time and trust?")
        ),
        TVLearnVisualEntry(
          id: "creation_oceans",
          eyebrow: tvLocalized("Depth"),
          title: tvLocalized("Oceans and hidden worlds"),
          subtitle: tvLocalized("Use layered water, distance, and unseen depth as a way to reflect on humility before Allah's creation."),
          supportingLine: tvLocalized("Works especially well on a large screen because scale and depth are part of the lesson itself."),
          systemImage: "water.waves",
          accentLabel: tvLocalized("Depth and humility"),
          takeawayPoints: [
            tvLocalized("Not every reality is immediately visible, yet it still surrounds us."),
            tvLocalized("Creation can make the room feel smaller in a healthy way that softens pride."),
            tvLocalized("Visual learning should invite humility before curiosity turns into mere spectacle."),
          ],
          observationPrompt: tvLocalized("What unseen reality in life should the room remember with more humility?")
        ),
        TVLearnVisualEntry(
          id: "creation_living_world",
          eyebrow: tvLocalized("Living signs"),
          title: tvLocalized("Animals, growth, and provision"),
          subtitle: tvLocalized("Observe how provision, care, and balance in living creation can return the room to gratitude and responsibility."),
          supportingLine: tvLocalized("A good household entry because it connects visible life to mercy, care, and stewardship."),
          systemImage: "leaf.fill",
          accentLabel: tvLocalized("Mercy and stewardship"),
          takeawayPoints: [
            tvLocalized("Visible life around us can become a daily reminder of mercy rather than background noise."),
            tvLocalized("Creation learning should strengthen care for animals, resources, and daily blessings."),
            tvLocalized("The best takeaway is often gratitude expressed through gentler action."),
          ],
          observationPrompt: tvLocalized("What part of living creation should make the household more grateful or more careful this week?")
        ),
        TVLearnVisualEntry(
          id: "creation_horizon",
          eyebrow: tvLocalized("Travel"),
          title: tvLocalized("Horizons, weather, and changing states"),
          subtitle: tvLocalized("Use movement across landscapes, weather, and changing conditions to encourage reflection instead of distraction."),
          supportingLine: tvLocalized("Useful for family-room conversation because everyone has seen changing skies, seasons, and travel scenes."),
          systemImage: "wind",
          accentLabel: tvLocalized("Movement and reflection"),
          takeawayPoints: [
            tvLocalized("Changing conditions can train the heart to reflect rather than drift past familiar signs."),
            tvLocalized("Travel and weather become meaningful when they awaken attention, not just excitement."),
            tvLocalized("Television can help hold one changing image long enough for reflection to begin."),
          ],
          observationPrompt: tvLocalized("Which changing scene in nature most often slows the household down enough to reflect?")
        ),
      ]
    )
  }

  static func audioURL(
    reciter: TVQuranReciter,
    surahNumber: Int,
    ayahNumber: Int
  ) -> URL? {
    let code = String(format: "%03d%03d", surahNumber, ayahNumber)
    return URL(string: "\(reciter.baseURL)/\(code).mp3")
  }
}
