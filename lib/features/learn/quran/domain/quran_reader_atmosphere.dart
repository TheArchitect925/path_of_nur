/// Reader-scoped themes for the Qur'an reading and listening surfaces.
///
/// These are independent of the app-wide theme modes: a reader can sit in the
/// Noor Glass app and still recite on a Midnight screen at night. The three
/// atmospheres ship reader-first; an app-wide theme revamp can adopt them
/// later.
enum QuranReaderAtmosphere {
  /// Resolve from the app-wide theme: night app themes read on their own
  /// atmosphere, light themes on Noor Glass. The default since app-wide
  /// themes shipped.
  followApp('follow_app'),
  noorGlass('noor_glass'),
  midnight('midnight'),
  candlelight('candlelight'),
  jummah('jummah'),
  ramadan('ramadan');

  const QuranReaderAtmosphere(this.wireName);

  final String wireName;

  static QuranReaderAtmosphere parse(String? raw) {
    for (final value in values) {
      if (value.wireName == raw) return value;
    }
    return QuranReaderAtmosphere.followApp;
  }
}
