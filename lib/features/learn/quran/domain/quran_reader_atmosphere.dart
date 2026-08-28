/// Reader-scoped themes for the Qur'an reading and listening surfaces.
///
/// These are independent of the app-wide theme modes: a reader can sit in the
/// Noor Glass app and still recite on a Midnight screen at night. The three
/// atmospheres ship reader-first; an app-wide theme revamp can adopt them
/// later.
enum QuranReaderAtmosphere {
  noorGlass('noor_glass'),
  midnight('midnight'),
  candlelight('candlelight');

  const QuranReaderAtmosphere(this.wireName);

  final String wireName;

  static QuranReaderAtmosphere parse(String? raw) {
    for (final value in values) {
      if (value.wireName == raw) return value;
    }
    return QuranReaderAtmosphere.noorGlass;
  }
}
