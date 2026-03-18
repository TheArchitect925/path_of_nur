import 'package:flutter/foundation.dart';
import '../../l10n/app_localizations.dart';

/// Tiny internal registry for bundled Adhan assets.
///
/// Add new bundled clips here, then place matching files in:
/// - assets/audio/adhan/regular/
/// - assets/audio/adhan/fajr/
/// - android/app/src/main/res/raw/
/// - ios/Runner/
///
/// Fajr routing is intentionally separate from the regular daily Adhan.
/// Until curated Pixabay replacements are bundled, the current Fajr entries use
/// the temporary fallback clips prepared in the repo.
enum AdhanOptionCategory { regular, fajr, both }

@immutable
class AdhanOption {
  const AdhanOption({
    required this.id,
    required this.title,
    required this.category,
    required this.assetPath,
    required this.androidRawResourceName,
    required this.iosSoundFileName,
    required this.isDefault,
    required this.sortOrder,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
  final AdhanOptionCategory category;
  final String assetPath;
  final String androidRawResourceName;
  final String iosSoundFileName;
  final bool isDefault;
  final int sortOrder;

  String localizedTitle(AppLocalizations l10n) {
    switch (id) {
      case 'makkah_default':
        return l10n.adhanOptionMakkahDefaultTitle;
      case 'madinah_soft':
        return l10n.adhanOptionMadinahSoftTitle;
      case 'clear_masjid':
        return l10n.adhanOptionClearMasjidTitle;
      case 'fajr_default':
        return l10n.adhanOptionFajrDefaultTitle;
      case 'fajr_soft':
        return l10n.adhanOptionFajrSoftTitle;
    }
    return title;
  }

  String? localizedSubtitle(AppLocalizations l10n) {
    switch (id) {
      case 'makkah_default':
        return l10n.adhanOptionMakkahDefaultSubtitle;
      case 'madinah_soft':
        return l10n.adhanOptionMadinahSoftSubtitle;
      case 'clear_masjid':
        return l10n.adhanOptionClearMasjidSubtitle;
      case 'fajr_default':
        return l10n.adhanOptionFajrDefaultSubtitle;
      case 'fajr_soft':
        return l10n.adhanOptionFajrSoftSubtitle;
    }
    return subtitle;
  }

  bool supportsCategory(AdhanOptionCategory target) {
    if (category == AdhanOptionCategory.both) return true;
    return category == target;
  }
}

@immutable
class AdhanSettings {
  const AdhanSettings({
    required this.enabled,
    required this.selectedRegularAdhanId,
    required this.selectedFajrAdhanId,
    required this.volume,
    required this.useAppVolume,
  });

  static const double defaultVolume = 0.85;

  static const AdhanSettings defaults = AdhanSettings(
    enabled: true,
    selectedRegularAdhanId: AdhanRegistry.defaultRegularId,
    selectedFajrAdhanId: AdhanRegistry.defaultFajrId,
    volume: defaultVolume,
    useAppVolume: true,
  );

  final bool enabled;
  final String selectedRegularAdhanId;
  final String selectedFajrAdhanId;
  final double volume;
  final bool useAppVolume;

  AdhanSettings copyWith({
    bool? enabled,
    String? selectedRegularAdhanId,
    String? selectedFajrAdhanId,
    double? volume,
    bool? useAppVolume,
  }) {
    return AdhanSettings(
      enabled: enabled ?? this.enabled,
      selectedRegularAdhanId:
          selectedRegularAdhanId ?? this.selectedRegularAdhanId,
      selectedFajrAdhanId: selectedFajrAdhanId ?? this.selectedFajrAdhanId,
      volume: volume ?? this.volume,
      useAppVolume: useAppVolume ?? this.useAppVolume,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'enabled': enabled,
    'selectedRegularAdhanId': selectedRegularAdhanId,
    'selectedFajrAdhanId': selectedFajrAdhanId,
    'volume': volume,
    'useAppVolume': useAppVolume,
  };

  static AdhanSettings fromJson(dynamic raw) {
    if (raw is! Map) return defaults;
    final volumeRaw = raw['volume'];
    final parsedVolume = volumeRaw is num
        ? volumeRaw.toDouble()
        : defaultVolume;
    return AdhanSettings(
      enabled: raw['enabled'] is bool
          ? raw['enabled'] as bool
          : defaults.enabled,
      selectedRegularAdhanId:
          raw['selectedRegularAdhanId']?.toString() ??
          defaults.selectedRegularAdhanId,
      selectedFajrAdhanId:
          raw['selectedFajrAdhanId']?.toString() ??
          defaults.selectedFajrAdhanId,
      volume: parsedVolume.clamp(0.0, 1.0),
      useAppVolume: raw['useAppVolume'] is bool
          ? raw['useAppVolume'] as bool
          : defaults.useAppVolume,
    );
  }
}

class AdhanRegistry {
  const AdhanRegistry._();

  static const String defaultRegularId = 'makkah_default';
  static const String defaultFajrId = 'fajr_default';

  static const List<AdhanOption> options = <AdhanOption>[
    AdhanOption(
      id: 'makkah_default',
      title: 'Makkah Default',
      subtitle: 'Clear, balanced, and suitable for the daily prayers.',
      category: AdhanOptionCategory.regular,
      assetPath: 'assets/audio/adhan/regular/makkah_default.oga',
      androidRawResourceName: 'adhan_regular_makkah_default',
      iosSoundFileName: 'adhan_regular_makkah_default.caf',
      isDefault: true,
      sortOrder: 0,
    ),
    AdhanOption(
      id: 'madinah_soft',
      title: 'Madinah Soft',
      subtitle: 'A softer bundled option for a calmer reminder tone.',
      category: AdhanOptionCategory.regular,
      assetPath: 'assets/audio/adhan/regular/madinah_soft.oga',
      androidRawResourceName: 'adhan_regular_madinah_soft',
      iosSoundFileName: 'adhan_regular_madinah_soft.caf',
      isDefault: false,
      sortOrder: 1,
    ),
    AdhanOption(
      id: 'clear_masjid',
      title: 'Clear Masjid',
      subtitle: 'Focused and direct for prayer-time playback.',
      category: AdhanOptionCategory.regular,
      assetPath: 'assets/audio/adhan/regular/clear_masjid.oga',
      androidRawResourceName: 'adhan_regular_clear_masjid',
      iosSoundFileName: 'adhan_regular_clear_masjid.caf',
      isDefault: false,
      sortOrder: 2,
    ),
    // TODO(shahab): Replace these temporary fallback Fajr clips with curated
    // Pixabay Fajr-specific recordings once direct downloadable assets are
    // available without the current Cloudflare challenge.
    AdhanOption(
      id: 'fajr_default',
      title: 'Fajr Default',
      subtitle: 'Temporary bundled fallback for Fajr-specific routing.',
      category: AdhanOptionCategory.fajr,
      assetPath: 'assets/audio/adhan/fajr/fajr_default.oga',
      androidRawResourceName: 'adhan_fajr_default',
      iosSoundFileName: 'adhan_fajr_default.caf',
      isDefault: true,
      sortOrder: 10,
    ),
    AdhanOption(
      id: 'fajr_soft',
      title: 'Fajr Soft',
      subtitle: 'Temporary bundled fallback with a gentler Fajr label.',
      category: AdhanOptionCategory.fajr,
      assetPath: 'assets/audio/adhan/fajr/fajr_soft.oga',
      androidRawResourceName: 'adhan_fajr_soft',
      iosSoundFileName: 'adhan_fajr_soft.caf',
      isDefault: false,
      sortOrder: 11,
    ),
  ];

  static List<AdhanOption> optionsFor(AdhanOptionCategory category) {
    final matches = options
        .where((option) => option.supportsCategory(category))
        .toList();
    matches.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return matches;
  }

  static AdhanOption? byId(String id) {
    for (final option in options) {
      if (option.id == id) return option;
    }
    return null;
  }

  static AdhanOption defaultFor(AdhanOptionCategory category) {
    return optionsFor(category).firstWhere((option) => option.isDefault);
  }
}
