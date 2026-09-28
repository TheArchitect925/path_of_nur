import Foundation

/// The ninety-nine names, transcoded from the phone's
/// `lib/features/learn/quran/data/names_of_allah_data.dart` so the wrist and
/// the phone can never drift apart. Regenerate rather than hand-edit.
struct WatchNameOfAllah: Identifiable, Hashable {
  let index: Int
  let arabic: String
  let transliteration: String
  let meaning: String

  var id: Int { index }
}

enum WatchNamesOfAllahData {
  /// A stable name per calendar day: it does not change as the day wears on,
  /// so the complication and the screen always agree on today's name.
  static func nameOfTheDay(
    for date: Date,
    calendar: Calendar = .current
  ) -> WatchNameOfAllah {
    let startOfDay = calendar.startOfDay(for: date)
    let day = Int(startOfDay.timeIntervalSince1970 / 86_400)
    let slot = ((day % all.count) + all.count) % all.count
    return all[slot]
  }

  static let all: [WatchNameOfAllah] = [
    WatchNameOfAllah(
      index: 1,
      arabic: "الرَّحْمَٰنُ",
      transliteration: "Ar-Rahman",
      meaning: "The Entirely Merciful"
    ),
    WatchNameOfAllah(
      index: 2,
      arabic: "الرَّحِيمُ",
      transliteration: "Ar-Rahim",
      meaning: "The Especially Merciful"
    ),
    WatchNameOfAllah(
      index: 3,
      arabic: "الْمَلِكُ",
      transliteration: "Al-Malik",
      meaning: "The King and Owner of Dominion"
    ),
    WatchNameOfAllah(
      index: 4,
      arabic: "الْقُدُّوسُ",
      transliteration: "Al-Quddus",
      meaning: "The Absolutely Pure"
    ),
    WatchNameOfAllah(
      index: 5,
      arabic: "السَّلَامُ",
      transliteration: "As-Salam",
      meaning: "The Source of Peace"
    ),
    WatchNameOfAllah(
      index: 6,
      arabic: "الْمُؤْمِنُ",
      transliteration: "Al-Mu’min",
      meaning: "The Granter of Security"
    ),
    WatchNameOfAllah(
      index: 7,
      arabic: "الْمُهَيْمِنُ",
      transliteration: "Al-Muhaymin",
      meaning: "The Guardian"
    ),
    WatchNameOfAllah(
      index: 8,
      arabic: "الْعَزِيزُ",
      transliteration: "Al-‘Aziz",
      meaning: "The Almighty"
    ),
    WatchNameOfAllah(
      index: 9,
      arabic: "الْجَبَّارُ",
      transliteration: "Al-Jabbar",
      meaning: "The Compeller"
    ),
    WatchNameOfAllah(
      index: 10,
      arabic: "الْمُتَكَبِّرُ",
      transliteration: "Al-Mutakabbir",
      meaning: "The Supreme in Greatness"
    ),
    WatchNameOfAllah(
      index: 11,
      arabic: "الْخَالِقُ",
      transliteration: "Al-Khaliq",
      meaning: "The Creator"
    ),
    WatchNameOfAllah(
      index: 12,
      arabic: "الْبَارِئُ",
      transliteration: "Al-Bari’",
      meaning: "The Originator"
    ),
    WatchNameOfAllah(
      index: 13,
      arabic: "الْمُصَوِّرُ",
      transliteration: "Al-Musawwir",
      meaning: "The Fashioner"
    ),
    WatchNameOfAllah(
      index: 14,
      arabic: "الْغَفَّارُ",
      transliteration: "Al-Ghaffar",
      meaning: "The Constant Forgiver"
    ),
    WatchNameOfAllah(
      index: 15,
      arabic: "الْقَهَّارُ",
      transliteration: "Al-Qahhar",
      meaning: "The All-Subduer"
    ),
    WatchNameOfAllah(
      index: 16,
      arabic: "الْوَهَّابُ",
      transliteration: "Al-Wahhab",
      meaning: "The Supreme Bestower"
    ),
    WatchNameOfAllah(
      index: 17,
      arabic: "الرَّزَّاقُ",
      transliteration: "Ar-Razzaq",
      meaning: "The Provider"
    ),
    WatchNameOfAllah(
      index: 18,
      arabic: "الْفَتَّاحُ",
      transliteration: "Al-Fattah",
      meaning: "The Opener"
    ),
    WatchNameOfAllah(
      index: 19,
      arabic: "اَلْعَلِيْمُ",
      transliteration: "Al-‘Alim",
      meaning: "The All-Knowing"
    ),
    WatchNameOfAllah(
      index: 20,
      arabic: "الْقَابِضُ",
      transliteration: "Al-Qabid",
      meaning: "The Withholder"
    ),
    WatchNameOfAllah(
      index: 21,
      arabic: "الْبَاسِطُ",
      transliteration: "Al-Basit",
      meaning: "The Extender"
    ),
    WatchNameOfAllah(
      index: 22,
      arabic: "الْخَافِضُ",
      transliteration: "Al-Khafid",
      meaning: "The Abaser"
    ),
    WatchNameOfAllah(
      index: 23,
      arabic: "الرَّافِعُ",
      transliteration: "Ar-Rafi‘",
      meaning: "The Exalter"
    ),
    WatchNameOfAllah(
      index: 24,
      arabic: "الْمُعِزُّ",
      transliteration: "Al-Mu‘izz",
      meaning: "The Honorer"
    ),
    WatchNameOfAllah(
      index: 25,
      arabic: "ٱلْمُذِلُّ",
      transliteration: "Al-Mudhill",
      meaning: "The Humiliator"
    ),
    WatchNameOfAllah(
      index: 26,
      arabic: "السَّمِيعُ",
      transliteration: "As-Sami‘",
      meaning: "The All-Hearing"
    ),
    WatchNameOfAllah(
      index: 27,
      arabic: "الْبَصِيرُ",
      transliteration: "Al-Basir",
      meaning: "The All-Seeing"
    ),
    WatchNameOfAllah(
      index: 28,
      arabic: "الْحَكَمُ",
      transliteration: "Al-Hakam",
      meaning: "The Judge"
    ),
    WatchNameOfAllah(
      index: 29,
      arabic: "الْعَدْلُ",
      transliteration: "Al-‘Adl",
      meaning: "The Utterly Just"
    ),
    WatchNameOfAllah(
      index: 30,
      arabic: "اللَّطِيفُ",
      transliteration: "Al-Latif",
      meaning: "The Subtle and Gentle"
    ),
    WatchNameOfAllah(
      index: 31,
      arabic: "الْخَبِيرُ",
      transliteration: "Al-Khabir",
      meaning: "The All-Aware"
    ),
    WatchNameOfAllah(
      index: 32,
      arabic: "الْحَلِيمُ",
      transliteration: "Al-Halim",
      meaning: "The Forbearing"
    ),
    WatchNameOfAllah(
      index: 33,
      arabic: "الْعَظِيمُ",
      transliteration: "Al-‘Azim",
      meaning: "The Magnificent"
    ),
    WatchNameOfAllah(
      index: 34,
      arabic: "الْغَفُورُ",
      transliteration: "Al-Ghafur",
      meaning: "The Great Forgiver"
    ),
    WatchNameOfAllah(
      index: 35,
      arabic: "الشَّكُورُ",
      transliteration: "Ash-Shakur",
      meaning: "The Most Appreciative"
    ),
    WatchNameOfAllah(
      index: 36,
      arabic: "الْعَلِيُّ",
      transliteration: "Al-‘Aliyy",
      meaning: "The Most High"
    ),
    WatchNameOfAllah(
      index: 37,
      arabic: "الْكَبِيرُ",
      transliteration: "Al-Kabir",
      meaning: "The Most Great"
    ),
    WatchNameOfAllah(
      index: 38,
      arabic: "الْحَفِيظُ",
      transliteration: "Al-Hafiz",
      meaning: "The Preserver"
    ),
    WatchNameOfAllah(
      index: 39,
      arabic: "المُقيِت",
      transliteration: "Al-Muqit",
      meaning: "The Sustainer"
    ),
    WatchNameOfAllah(
      index: 40,
      arabic: "الْحسِيبُ",
      transliteration: "Al-Hasib",
      meaning: "The Reckoner"
    ),
    WatchNameOfAllah(
      index: 41,
      arabic: "الْجَلِيلُ",
      transliteration: "Al-Jalil",
      meaning: "The Majestic"
    ),
    WatchNameOfAllah(
      index: 42,
      arabic: "الْكَرِيمُ",
      transliteration: "Al-Karim",
      meaning: "The Most Generous"
    ),
    WatchNameOfAllah(
      index: 43,
      arabic: "الرَّقِيبُ",
      transliteration: "Ar-Raqib",
      meaning: "The Watchful"
    ),
    WatchNameOfAllah(
      index: 44,
      arabic: "الْمُجِيبُ",
      transliteration: "Al-Mujib",
      meaning: "The Responsive"
    ),
    WatchNameOfAllah(
      index: 45,
      arabic: "الْوَاسِعُ",
      transliteration: "Al-Wasi‘",
      meaning: "The All-Encompassing"
    ),
    WatchNameOfAllah(
      index: 46,
      arabic: "الْحَكِيمُ",
      transliteration: "Al-Hakim",
      meaning: "The All-Wise"
    ),
    WatchNameOfAllah(
      index: 47,
      arabic: "الْوَدُودُ",
      transliteration: "Al-Wadud",
      meaning: "The Most Loving"
    ),
    WatchNameOfAllah(
      index: 48,
      arabic: "الْمَجِيدُ",
      transliteration: "Al-Majid",
      meaning: "The Most Glorious"
    ),
    WatchNameOfAllah(
      index: 49,
      arabic: "الْبَاعِثُ",
      transliteration: "Al-Ba‘ith",
      meaning: "The Resurrector"
    ),
    WatchNameOfAllah(
      index: 50,
      arabic: "الشَّهِيدُ",
      transliteration: "Ash-Shahid",
      meaning: "The Witness"
    ),
    WatchNameOfAllah(
      index: 51,
      arabic: "الْحَقُّ",
      transliteration: "Al-Haqq",
      meaning: "The Truth"
    ),
    WatchNameOfAllah(
      index: 52,
      arabic: "الْوَكِيلُ",
      transliteration: "Al-Wakil",
      meaning: "The Trustee"
    ),
    WatchNameOfAllah(
      index: 53,
      arabic: "الْقَوِيُّ",
      transliteration: "Al-Qawiyy",
      meaning: "The Most Strong"
    ),
    WatchNameOfAllah(
      index: 54,
      arabic: "الْمَتِينُ",
      transliteration: "Al-Matin",
      meaning: "The Firm"
    ),
    WatchNameOfAllah(
      index: 55,
      arabic: "الْوَلِيُّ",
      transliteration: "Al-Waliyy",
      meaning: "The Protecting Friend"
    ),
    WatchNameOfAllah(
      index: 56,
      arabic: "الْحَمِيدُ",
      transliteration: "Al-Hamid",
      meaning: "The Praiseworthy"
    ),
    WatchNameOfAllah(
      index: 57,
      arabic: "الْمُحْصِي",
      transliteration: "Al-Muhsi",
      meaning: "The Accounter"
    ),
    WatchNameOfAllah(
      index: 58,
      arabic: "الْمُبْدِئُ",
      transliteration: "Al-Mubdi’",
      meaning: "The Originator"
    ),
    WatchNameOfAllah(
      index: 59,
      arabic: "الْمُعِيدُ",
      transliteration: "Al-Mu‘id",
      meaning: "The Restorer"
    ),
    WatchNameOfAllah(
      index: 60,
      arabic: "الْمُحْيِي",
      transliteration: "Al-Muhyi",
      meaning: "The Giver of Life"
    ),
    WatchNameOfAllah(
      index: 61,
      arabic: "اَلْمُمِيتُ",
      transliteration: "Al-Mumit",
      meaning: "The Creator of Death"
    ),
    WatchNameOfAllah(
      index: 62,
      arabic: "الْحَيُّ",
      transliteration: "Al-Hayy",
      meaning: "The Ever-Living"
    ),
    WatchNameOfAllah(
      index: 63,
      arabic: "الْقَيُّومُ",
      transliteration: "Al-Qayyum",
      meaning: "The Self-Subsisting"
    ),
    WatchNameOfAllah(
      index: 64,
      arabic: "الْوَاجِدُ",
      transliteration: "Al-Wajid",
      meaning: "The Finder"
    ),
    WatchNameOfAllah(
      index: 65,
      arabic: "الْمَاجِدُ",
      transliteration: "Al-Majid",
      meaning: "The Illustrious"
    ),
    WatchNameOfAllah(
      index: 66,
      arabic: "الْواحِدُ",
      transliteration: "Al-Wahid",
      meaning: "The One"
    ),
    WatchNameOfAllah(
      index: 67,
      arabic: "اَلاَحَدُ",
      transliteration: "Al-Ahad",
      meaning: "The Unique"
    ),
    WatchNameOfAllah(
      index: 68,
      arabic: "الصَّمَدُ",
      transliteration: "As-Samad",
      meaning: "The Eternal Refuge"
    ),
    WatchNameOfAllah(
      index: 69,
      arabic: "الْقَادِرُ",
      transliteration: "Al-Qadir",
      meaning: "The All-Powerful"
    ),
    WatchNameOfAllah(
      index: 70,
      arabic: "الْمُقْتَدِرُ",
      transliteration: "Al-Muqtadir",
      meaning: "The Creator of All Power"
    ),
    WatchNameOfAllah(
      index: 71,
      arabic: "الْمُقَدِّمُ",
      transliteration: "Al-Muqaddim",
      meaning: "The Expediter"
    ),
    WatchNameOfAllah(
      index: 72,
      arabic: "الْمُؤَخِّرُ",
      transliteration: "Al-Mu’akhkhir",
      meaning: "The Delayer"
    ),
    WatchNameOfAllah(
      index: 73,
      arabic: "الأوَّلُ",
      transliteration: "Al-Awwal",
      meaning: "The First"
    ),
    WatchNameOfAllah(
      index: 74,
      arabic: "الآخِرُ",
      transliteration: "Al-Akhir",
      meaning: "The Last"
    ),
    WatchNameOfAllah(
      index: 75,
      arabic: "الظَّاهِرُ",
      transliteration: "Az-Zahir",
      meaning: "The Manifest"
    ),
    WatchNameOfAllah(
      index: 76,
      arabic: "الْبَاطِنُ",
      transliteration: "Al-Batin",
      meaning: "The Hidden"
    ),
    WatchNameOfAllah(
      index: 77,
      arabic: "الْوَالِي",
      transliteration: "Al-Wali",
      meaning: "The Sole Governor"
    ),
    WatchNameOfAllah(
      index: 78,
      arabic: "الْمُتَعَالِي",
      transliteration: "Al-Muta‘ali",
      meaning: "The Most Exalted"
    ),
    WatchNameOfAllah(
      index: 79,
      arabic: "الْبَرُّ",
      transliteration: "Al-Barr",
      meaning: "The Source of Goodness"
    ),
    WatchNameOfAllah(
      index: 80,
      arabic: "التَّوَابُ",
      transliteration: "At-Tawwab",
      meaning: "The Accepter of Repentance"
    ),
    WatchNameOfAllah(
      index: 81,
      arabic: "الْمُنْتَقِمُ",
      transliteration: "Al-Muntaqim",
      meaning: "The Avenger"
    ),
    WatchNameOfAllah(
      index: 82,
      arabic: "العَفُوُّ",
      transliteration: "Al-‘Afuww",
      meaning: "The Pardoner"
    ),
    WatchNameOfAllah(
      index: 83,
      arabic: "الرَّؤُوفُ",
      transliteration: "Ar-Ra’uf",
      meaning: "The Most Kind"
    ),
    WatchNameOfAllah(
      index: 84,
      arabic: "مَالِكُ ٱلْمُلْكُ",
      transliteration: "Malik-ul-Mulk",
      meaning: "Owner of the Kingdom"
    ),
    WatchNameOfAllah(
      index: 85,
      arabic: "ذُوالْجَلاَلِ وَالإكْرَامِ",
      transliteration: "Dhul-Jalali wal-Ikram",
      meaning: "Lord of Majesty and Honor"
    ),
    WatchNameOfAllah(
      index: 86,
      arabic: "الْمُقْسِطُ",
      transliteration: "Al-Muqsit",
      meaning: "The Equitable"
    ),
    WatchNameOfAllah(
      index: 87,
      arabic: "الْجَامِعُ",
      transliteration: "Al-Jami‘",
      meaning: "The Gatherer"
    ),
    WatchNameOfAllah(
      index: 88,
      arabic: "ٱلْغَنيُّ",
      transliteration: "Al-Ghaniyy",
      meaning: "The Self-Sufficient"
    ),
    WatchNameOfAllah(
      index: 89,
      arabic: "ٱلْمُغْنِيُّ",
      transliteration: "Al-Mughni",
      meaning: "The Enricher"
    ),
    WatchNameOfAllah(
      index: 90,
      arabic: "اَلْمَانِعُ",
      transliteration: "Al-Mani‘",
      meaning: "The Preventer"
    ),
    WatchNameOfAllah(
      index: 91,
      arabic: "الضَّارَّ",
      transliteration: "Ad-Darr",
      meaning: "The Creator of Harm"
    ),
    WatchNameOfAllah(
      index: 92,
      arabic: "النَّافِعُ",
      transliteration: "An-Nafi‘",
      meaning: "The Creator of Good"
    ),
    WatchNameOfAllah(
      index: 93,
      arabic: "النُّورُ",
      transliteration: "An-Nur",
      meaning: "The Light"
    ),
    WatchNameOfAllah(
      index: 94,
      arabic: "الْهَادِي",
      transliteration: "Al-Hadi",
      meaning: "The Guide"
    ),
    WatchNameOfAllah(
      index: 95,
      arabic: "الْبَدِيعُ",
      transliteration: "Al-Badi‘",
      meaning: "The Incomparable Originator"
    ),
    WatchNameOfAllah(
      index: 96,
      arabic: "اَلْبَاقِي",
      transliteration: "Al-Baqi",
      meaning: "The Everlasting"
    ),
    WatchNameOfAllah(
      index: 97,
      arabic: "الْوَارِثُ",
      transliteration: "Al-Warith",
      meaning: "The Inheritor"
    ),
    WatchNameOfAllah(
      index: 98,
      arabic: "الرَّشِيدُ",
      transliteration: "Ar-Rashid",
      meaning: "The Guide to the Right Path"
    ),
    WatchNameOfAllah(
      index: 99,
      arabic: "الصَّبُورُ",
      transliteration: "As-Sabur",
      meaning: "The Most Patient"
    ),
  ]
}
