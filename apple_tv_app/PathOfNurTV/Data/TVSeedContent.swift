import Foundation

struct TVSeedContent {
    static let prayerSummaries: [TVPrayerSummary] = [
        .init(id: "fajr", name: "Fajr", arabicName: "الفجر", timeLabel: "5:18 AM", state: .completed),
        .init(id: "dhuhr", name: "Dhuhr", arabicName: "الظهر", timeLabel: "1:09 PM", state: .current),
        .init(id: "asr", name: "Asr", arabicName: "العصر", timeLabel: "4:42 PM", state: .upcoming),
        .init(id: "maghrib", name: "Maghrib", arabicName: "المغرب", timeLabel: "7:18 PM", state: .upcoming),
        .init(id: "isha", name: "Isha", arabicName: "العشاء", timeLabel: "8:47 PM", state: .upcoming)
    ]

    static let quickLinks: [TVQuickLink] = [
        .init(id: "prayer", title: "Prayer Today", subtitle: "Current and upcoming salah at a glance", systemImage: "clock.fill", destinationTab: .prayer),
        .init(id: "dhikr", title: "Dhikr Mode", subtitle: "A calm phrase display for the room", systemImage: "sparkles", destinationTab: .dhikr),
        .init(id: "learn", title: "Continue Learning", subtitle: "Prophets, duʿā, and Qur’an reflection", systemImage: "book.fill", destinationTab: .learn),
        .init(id: "library", title: "Listen", subtitle: "Recitation and story playback", systemImage: "headphones", destinationTab: .library)
    ]

    static let featuredShelves: [TVShelfSection] = [
        .init(
            id: "continue_learning",
            title: "Continue Learning",
            subtitle: "Return to gentle, meaningful study.",
            items: [
                .init(id: "prophet_yusuf", title: "Prophet Yusuf", subtitle: "Beauty, patience, and trust", eyebrow: "Prophets", systemImage: "sparkles.tv", detailBody: "A calm retelling of hardship, dignity, restraint, and Allah’s unfolding mercy.", reference: "Qur’an 12"),
                .init(id: "dua_knowledge", title: "Increase Me in Knowledge", subtitle: "A short Qur’anic supplication", eyebrow: "Duʿā", systemImage: "text.book.closed.fill", detailBody: "A concise duʿā for seeking beneficial knowledge with humility.", reference: "Qur’an 20:114"),
                .init(id: "creation_sky", title: "Signs in the Sky", subtitle: "Reflection on the heavens", eyebrow: "World & Creation", systemImage: "moon.stars.fill", detailBody: "A family-friendly reflection shelf on the sky, order, rhythm, and remembrance.", reference: "Qur’an 3:190")
            ]
        ),
        .init(
            id: "prophets",
            title: "Stories of the Prophets",
            subtitle: "Browse story-driven learning for the family.",
            items: [
                .init(id: "adam", title: "Adam عليه السلام", subtitle: "Beginnings and responsibility", eyebrow: "Prophets", systemImage: "person.crop.circle", detailBody: "The story of beginnings, honor, repentance, and the first human trust.", reference: "Qur’an 2, 7, 20"),
                .init(id: "nuh", title: "Nuh عليه السلام", subtitle: "Steadfast calling over time", eyebrow: "Prophets", systemImage: "water.waves", detailBody: "A long call marked by patience, sincerity, and reliance on Allah.", reference: "Qur’an 71"),
                .init(id: "musa", title: "Musa عليه السلام", subtitle: "Courage, revelation, and liberation", eyebrow: "Prophets", systemImage: "flame.fill", detailBody: "Guidance through fear, struggle, law, and return to Allah.", reference: "Qur’an 20, 28")
            ]
        ),
        .init(
            id: "family_learning",
            title: "Family Learning",
            subtitle: "Short, readable content made for shared viewing.",
            items: [
                .init(id: "basics_islam", title: "Foundations of Islam", subtitle: "Core beliefs and practice", eyebrow: "Islamic Basics", systemImage: "star.circle.fill", detailBody: "A tv-friendly learning rail for gradual family study.", reference: nil),
                .init(id: "dua_sleep", title: "Bedtime Duʿā", subtitle: "Night remembrance for the home", eyebrow: "Duʿā", systemImage: "bed.double.fill", detailBody: "A short remembrance page for calm evening family use.", reference: nil),
                .init(id: "quran_fatihah", title: "Sūrah al-Fātiḥah", subtitle: "Meaning and structure", eyebrow: "Qur’an & Reflection", systemImage: "book.pages.fill", detailBody: "A large-screen reading and explanation template for one of the most central passages in Muslim life.", reference: "Qur’an 1")
            ]
        )
    ]

    static let audioItems: [TVAudioItem] = [
        .init(id: "quran_yasin", title: "Sūrah Yā-Sīn", subtitle: "Recitation", detail: "A calm recitation session for listening at home.", durationLabel: "17 min", systemImage: "waveform"),
        .init(id: "dua_morning", title: "Morning Adhkār", subtitle: "Daily remembrance", detail: "A guided listening-friendly collection for the start of the day.", durationLabel: "11 min", systemImage: "sun.max.fill"),
        .init(id: "prophet_yusuf_story", title: "Story of Yusuf", subtitle: "Narrated lesson", detail: "A premium story card for family listening and reflection.", durationLabel: "23 min", systemImage: "play.rectangle.fill")
    ]

    static let progressSummary = TVProgressSummary(
        prayerStreak: 18,
        learningSessions: 42,
        oceanDrops: 164,
        reflectionCount: 27,
        completionRing: 0.72
    )

    static let settings: [TVSettingsOption] = [
        .init(id: "theme", title: "Theme", subtitle: "Visual tone for large-screen viewing", valueLabel: "Path of Nūr"),
        .init(id: "text_scale", title: "Text Scale", subtitle: "Readable from across the room", valueLabel: "Large"),
        .init(id: "audio", title: "Audio Preferences", subtitle: "Recitation and lesson playback behavior", valueLabel: "Calm"),
        .init(id: "prayer", title: "Prayer Display", subtitle: "Show current and next prayer prominently", valueLabel: "Focused"),
        .init(id: "household", title: "Household Mode", subtitle: "Family-friendly ambient presentation", valueLabel: "Enabled")
    ]
}
