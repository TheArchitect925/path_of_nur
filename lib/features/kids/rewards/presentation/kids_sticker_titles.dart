import '../../../../l10n/app_localizations.dart';
import '../../../kids_arabic/domain/kids_arabic_achievement_models.dart';
import '../../../kids_arabic/presentation/kids_arabic_localized_content.dart';
import '../../../kids_dua_learning/presentation/kids_dua_localized_content.dart';
import '../domain/kids_sticker_models.dart';

/// A sticker's name in the child's language. Stories, letters and duʿās
/// carry their own; the special milestones carry a key into the older
/// systems' localized copy.
String kidsStickerTitle(AppLocalizations l10n, KidsSticker sticker) {
  final key = sticker.labelKey;
  if (key == null) return sticker.title;
  const achievementPrefix = 'arabic-achievement:';
  if (key.startsWith(achievementPrefix)) {
    final id = key.substring(achievementPrefix.length);
    for (final definition in kidsArabicAchievementDefinitions) {
      if (definition.id == id) {
        return localizedKidsArabicAchievementTitle(l10n, definition);
      }
    }
    return sticker.title;
  }
  return localizedKidsDuaRewardTitle(l10n, key);
}
