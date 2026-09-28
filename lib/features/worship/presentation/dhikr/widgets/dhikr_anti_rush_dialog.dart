import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/quran_presentation_style.dart';

/// The "slow down" reminder shown when taps come faster than a phrase can
/// be said. Shared by the free counter and the routine player.
Future<void> showDhikrAntiRushDialog(
  BuildContext context, {
  required String phraseLabel,
}) async {
  await HapticFeedback.heavyImpact();
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final theme = Theme.of(context);
  final palette = context.palette;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      final dialogStyle = AppSurfaceTheme.resolve(
        dialogContext,
        variant: AppSurfaceVariant.card,
        tintColor: palette.accent,
      );
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          decoration: dialogStyle
              .decoration(radius: 32)
              .copyWith(
                border: Border.all(
                  color: AppSurfaceTheme.adaptiveColor(
                    dialogContext,
                    palette.accent,
                    alpha: 0.26,
                    solidAlphaWhenDisabled: 0.34,
                  ),
                  width: 1.2,
                ),
              ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    phraseLabel,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: palette.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  l10n.dhikrAntiRushTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: palette.onSurface,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 24),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    l10n.dhikrAntiRushVerseArabic,
                    style: QuranPresentationStyle.translucentTextStyle(
                      context,
                      AppTextStyles.quranVerse(
                        size: 28,
                        color: palette.onSurface,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.dhikrAntiRushVerseTransliteration,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: palette.onSurfaceSubtle,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.dhikrAntiRushVerseTranslation,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: palette.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.dhikrAntiRushBody,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: palette.onSurfaceSubtle,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: palette.accent,
                      textStyle: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(l10n.dhikrAntiRushAcknowledgeAction),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
