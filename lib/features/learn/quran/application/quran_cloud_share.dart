import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/quran_audio_repository.dart';
import '../data/quran_translation_registry.dart';
import 'quran_providers.dart';

/// Where the phone and the Apple TV keep the Qur'an they share, in the
/// iCloud key-value store both read (`NSUbiquitousKeyValueStore`, one store
/// for the one bundle id). The Apple TV reads and writes the same key in
/// `TVQuranCloudShare.swift`.
const quranCloudShareKey = 'quran.shared.v1';

/// What this phone last shared, with the time each field changed.
const _localShareKey = 'learn.quran.cloudShare';

/// The Qur'an as it is shared: where the viewer is, the ayahs they
/// bookmarked, the reciter and the translation, each with the moment it was
/// last changed on any device. Two devices are merged field by field, the
/// newer change winning.
@immutable
class QuranSharedState {
  const QuranSharedState({
    this.place,
    this.placeAt,
    this.bookmarks,
    this.bookmarksAt,
    this.reciter,
    this.reciterAt,
    this.translation,
    this.translationAt,
  });

  /// "2:255".
  final String? place;
  final DateTime? placeAt;

  /// "2:255", the newest first.
  final List<String>? bookmarks;
  final DateTime? bookmarksAt;

  /// The phone's reciter ids; the Apple TV has more, which the phone passes
  /// over.
  final String? reciter;
  final DateTime? reciterAt;

  /// The phone's translation codes (`en.sahih`), `fr.hamidullah` for the
  /// French the Apple TV carries, or `none`.
  final String? translation;
  final DateTime? translationAt;

  static QuranSharedState fromJsonString(String? raw) {
    if (raw == null || raw.isEmpty) return const QuranSharedState();
    try {
      final json = jsonDecode(raw);
      return json is Map<String, dynamic>
          ? fromJson(json)
          : const QuranSharedState();
    } on FormatException {
      return const QuranSharedState();
    }
  }

  static QuranSharedState fromJson(Map<String, dynamic> json) {
    DateTime? at(String key) => DateTime.tryParse(json[key]?.toString() ?? '');
    String? text(String key) {
      final value = json[key];
      return value is String && value.isNotEmpty ? value : null;
    }

    final bookmarks = json['bookmarks'];
    return QuranSharedState(
      place: text('place'),
      placeAt: at('placeAt'),
      bookmarks: bookmarks is List
          ? bookmarks.whereType<String>().toList(growable: false)
          : null,
      bookmarksAt: at('bookmarksAt'),
      reciter: text('reciter'),
      reciterAt: at('reciterAt'),
      translation: text('translation'),
      translationAt: at('translationAt'),
    );
  }

  Map<String, dynamic> toJson() => {
    if (place != null) 'place': place,
    if (placeAt != null) 'placeAt': placeAt!.toUtc().toIso8601String(),
    if (bookmarks != null) 'bookmarks': bookmarks,
    if (bookmarksAt != null)
      'bookmarksAt': bookmarksAt!.toUtc().toIso8601String(),
    if (reciter != null) 'reciter': reciter,
    if (reciterAt != null) 'reciterAt': reciterAt!.toUtc().toIso8601String(),
    if (translation != null) 'translation': translation,
    if (translationAt != null)
      'translationAt': translationAt!.toUtc().toIso8601String(),
  };

  String toJsonString() => jsonEncode(toJson());

  /// Each field from whichever of the two changed it last.
  QuranSharedState merge(QuranSharedState other) {
    bool takesOther(DateTime? mine, DateTime? theirs) =>
        theirs != null && (mine == null || theirs.isAfter(mine));
    final place = takesOther(placeAt, other.placeAt);
    final bookmarks = takesOther(bookmarksAt, other.bookmarksAt);
    final reciter = takesOther(reciterAt, other.reciterAt);
    final translation = takesOther(translationAt, other.translationAt);
    return QuranSharedState(
      place: place ? other.place : this.place,
      placeAt: place ? other.placeAt : placeAt,
      bookmarks: bookmarks ? other.bookmarks : this.bookmarks,
      bookmarksAt: bookmarks ? other.bookmarksAt : bookmarksAt,
      reciter: reciter ? other.reciter : this.reciter,
      reciterAt: reciter ? other.reciterAt : reciterAt,
      translation: translation ? other.translation : this.translation,
      translationAt: translation ? other.translationAt : translationAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is QuranSharedState && other.toJsonString() == toJsonString();

  @override
  int get hashCode => toJsonString().hashCode;
}

/// "2:255" as a surah and an ayah, if it is one.
({int surahNumber, int ayahNumber})? parseQuranPlace(String? key) {
  final parts = (key ?? '').split(':');
  if (parts.length != 2) return null;
  final surah = int.tryParse(parts[0]);
  final ayah = int.tryParse(parts[1]);
  if (surah == null || ayah == null || surah < 1 || surah > 114 || ayah < 1) {
    return null;
  }
  return (surahNumber: surah, ayahNumber: ayah);
}

/// Keeps the phone's reading place, bookmarks, reciter and translation in
/// the shared document, and takes up what the Apple TV changed.
class QuranCloudShare {
  QuranCloudShare({
    required this.ref,
    required this.store,
    required this.readRemote,
    required this.writeRemote,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Ref ref;
  final LocalStore store;
  final Future<String?> Function() readRemote;
  final Future<bool> Function(String value) writeRemote;
  final DateTime Function() _now;

  /// Set while taking up the other device's changes, so that they are not
  /// shared back as this phone's own.
  bool _applying = false;
  Timer? _writeTimer;

  QuranSharedState get local =>
      QuranSharedState.fromJsonString(store.getString(_localShareKey));

  set local(QuranSharedState state) {
    store.setString(_localShareKey, state.toJsonString());
  }

  /// A change made on this phone.
  void recordLocal({
    String? place,
    List<String>? bookmarks,
    String? reciter,
    String? translation,
  }) {
    if (_applying) return;
    final current = local;
    final now = _now().toUtc();
    local = QuranSharedState(
      place: place ?? current.place,
      placeAt: place != null && place != current.place ? now : current.placeAt,
      bookmarks: bookmarks ?? current.bookmarks,
      bookmarksAt:
          bookmarks != null && !listEquals(bookmarks, current.bookmarks)
          ? now
          : current.bookmarksAt,
      reciter: reciter ?? current.reciter,
      reciterAt: reciter != null && reciter != current.reciter
          ? now
          : current.reciterAt,
      translation: translation ?? current.translation,
      translationAt: translation != null && translation != current.translation
          ? now
          : current.translationAt,
    );
    _scheduleWrite();
  }

  /// The first time, what this phone already has is shared as of when it
  /// was last changed, so that a newer choice on the Apple TV still wins.
  void seed({
    required String place,
    required DateTime placeAt,
    required List<String> bookmarks,
    required DateTime? bookmarksAt,
    required String reciter,
    required String translation,
  }) {
    final current = local;
    final long = DateTime.utc(2000);
    local = QuranSharedState(
      place: current.place ?? place,
      placeAt: current.placeAt ?? placeAt.toUtc(),
      bookmarks: current.bookmarks ?? bookmarks,
      bookmarksAt: current.bookmarksAt ?? (bookmarksAt?.toUtc() ?? long),
      reciter: current.reciter ?? reciter,
      reciterAt: current.reciterAt ?? long,
      translation: current.translation ?? translation,
      translationAt: current.translationAt ?? long,
    );
  }

  /// Merges the shared document with this phone's, takes up what is newer
  /// there, and writes back what is newer here.
  Future<void> sync() async {
    final remote = QuranSharedState.fromJsonString(await readRemote());
    final mine = local;
    final merged = mine.merge(remote);
    _apply(mine, merged);
    local = merged;
    if (merged != remote) {
      await writeRemote(merged.toJsonString());
    }
  }

  void _scheduleWrite() {
    _writeTimer?.cancel();
    // A reader moving ayah by ayah writes once it rests.
    _writeTimer = Timer(const Duration(seconds: 3), () {
      unawaited(sync().catchError((Object _) {}));
    });
  }

  void dispose() => _writeTimer?.cancel();

  void _apply(QuranSharedState before, QuranSharedState after) {
    _applying = true;
    try {
      if (after.placeAt != before.placeAt) {
        final place = parseQuranPlace(after.place);
        if (place != null) {
          ref
              .read(quranReadingProgressProvider.notifier)
              .touchLocation(
                surahNumber: place.surahNumber,
                ayahNumber: place.ayahNumber,
              );
        }
      }
      if (after.bookmarksAt != before.bookmarksAt && after.bookmarks != null) {
        ref.read(quranBookmarksProvider.notifier).replacePlaces([
          for (final key in after.bookmarks!) ?parseQuranPlace(key),
        ]);
      }
      if (after.reciterAt != before.reciterAt && after.reciter != null) {
        final reciter = after.reciter!;
        if (QuranAudioRepository.reciters.any((item) => item.id == reciter)) {
          ref.read(quranAudioSettingsProvider.notifier).setReciterId(reciter);
        }
      }
      if (after.translationAt != before.translationAt &&
          after.translation != null &&
          quranTranslationCodes.contains(after.translation)) {
        ref
            .read(quranReaderSettingsProvider.notifier)
            .setTranslationCode(after.translation!);
      }
    } finally {
      _applying = false;
    }
  }
}

const MethodChannel _iCloudChannel = MethodChannel('path_of_nur/icloud_sync');

/// Watched from the app's root: shares the Qur'an with the Apple TV while
/// the app runs, and takes up its changes on launch and whenever the app
/// comes back to the front. iOS only; elsewhere it does nothing.
final quranCloudShareBootstrapProvider = Provider<void>((ref) {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
  final share = QuranCloudShare(
    ref: ref,
    store: ref.watch(localStoreProvider),
    readRemote: () => _iCloudChannel.invokeMethod<String>('readValue', {
      'key': quranCloudShareKey,
    }),
    writeRemote: (value) async =>
        await _iCloudChannel.invokeMethod<bool>('writeValue', {
          'key': quranCloudShareKey,
          'value': value,
        }) ??
        false,
  );

  Future<void> syncQuietly() async {
    try {
      final available =
          await _iCloudChannel.invokeMethod<bool>('isAvailable') ?? false;
      if (available) await share.sync();
    } on Object {
      // iCloud is off, or not there: the phone keeps its own.
    }
  }

  ref.listen(quranReadingProgressProvider, (_, progress) {
    share.recordLocal(place: '${progress.surahNumber}:${progress.ayahNumber}');
  });
  ref.listen(quranBookmarksProvider, (_, bookmarks) {
    share.recordLocal(
      bookmarks: [
        for (final bookmark in bookmarks)
          '${bookmark.surahNumber}:${bookmark.ayahNumber}',
      ],
    );
  });
  ref.listen(
    quranAudioSettingsProvider.select((settings) => settings.reciterId),
    (_, reciter) => share.recordLocal(reciter: reciter),
  );
  ref.listen(
    quranReaderSettingsProvider.select((settings) => settings.translationCode),
    (_, translation) => share.recordLocal(translation: translation),
  );

  final progress = ref.read(quranReadingProgressProvider);
  final bookmarks = ref.read(quranBookmarksProvider);
  share.seed(
    place: '${progress.surahNumber}:${progress.ayahNumber}',
    placeAt: DateTime.tryParse(progress.updatedAtIso) ?? DateTime.utc(2000),
    bookmarks: [
      for (final bookmark in bookmarks)
        '${bookmark.surahNumber}:${bookmark.ayahNumber}',
    ],
    bookmarksAt: bookmarks.isEmpty
        ? null
        : DateTime.tryParse(bookmarks.first.createdAtIso),
    reciter: ref.read(quranAudioSettingsProvider).reciterId,
    translation: ref.read(quranReaderSettingsProvider).translationCode,
  );

  final observer = _ResumeObserver(syncQuietly);
  WidgetsBinding.instance.addObserver(observer);
  unawaited(syncQuietly());
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(observer);
    share.dispose();
  });
});

class _ResumeObserver extends WidgetsBindingObserver {
  _ResumeObserver(this.onResume);

  final Future<void> Function() onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(onResume());
    }
  }
}
