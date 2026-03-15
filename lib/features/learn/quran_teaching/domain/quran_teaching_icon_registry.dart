import 'package:flutter/material.dart';

/// Persist Qur'an teaching icons using stable tokens rather than reconstructing
/// runtime [IconData] from raw code points. That keeps release icon tree
/// shaking working while still supporting older saved payloads that stored
/// `iconCodePoint`.
abstract final class QuranTeachingIconRegistry {
  static const Map<String, IconData> _iconsById = <String, IconData>{
    'text_fields_rounded': Icons.text_fields_rounded,
    'merge_type_rounded': Icons.merge_type_rounded,
    'rule_rounded': Icons.rule_rounded,
    'graphic_eq_rounded': Icons.graphic_eq_rounded,
    'auto_awesome_mosaic_rounded': Icons.auto_awesome_mosaic_rounded,
    'short_text_rounded': Icons.short_text_rounded,
    'menu_book_rounded': Icons.menu_book_rounded,
    'image_rounded': Icons.image_rounded,
    'auto_fix_high_rounded': Icons.auto_fix_high_rounded,
    'wb_twilight_rounded': Icons.wb_twilight_rounded,
  };

  static final Map<int, IconData> _legacyIconsByCodePoint = <int, IconData>{
    for (final icon in _iconsById.values) icon.codePoint: icon,
  };

  static final Map<int, String> _legacyIdsByCodePoint = <int, String>{
    for (final entry in _iconsById.entries) entry.value.codePoint: entry.key,
  };

  static IconData? iconFromJson(Map<dynamic, dynamic> json) {
    final iconId = json['iconId']?.toString();
    if (iconId != null) {
      final icon = _iconsById[iconId];
      if (icon != null) {
        return icon;
      }
    }

    final legacyCodePoint =
        int.tryParse(json['iconCodePoint']?.toString() ?? '');
    if (legacyCodePoint == null) {
      return null;
    }
    return _legacyIconsByCodePoint[legacyCodePoint];
  }

  static Map<String, dynamic> iconToJson(IconData? icon) {
    if (icon == null) {
      return const <String, dynamic>{};
    }

    final iconId = _legacyIdsByCodePoint[icon.codePoint];
    return <String, dynamic>{
      'iconId': iconId,
      'iconCodePoint': icon.codePoint,
    };
  }
}
