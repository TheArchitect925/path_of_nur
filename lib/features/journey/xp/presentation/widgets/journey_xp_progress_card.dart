import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/journey_xp_providers.dart';

class JourneyXpProgressCard extends ConsumerWidget {
  const JourneyXpProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(journeyXpSummaryProvider);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final levelTitle = _localizedLevelTitle(
      l10n,
      summary.currentLevel,
      summary.currentLevelTitle,
    );
    final nextTitle = summary.nextLevel == null
        ? l10n.xpCardMaxLevel
        : _localizedLevelTitle(
            l10n,
            summary.nextLevel!,
            summary.nextLevelTitle ?? '',
          );

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.xpCardTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.xpCardLevelValue(
              countFormat.format(summary.currentLevel),
              levelTitle,
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.xpCardTotalXpValue(countFormat.format(summary.totalXp)),
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: summary.progressPercent),
          ),
          const SizedBox(height: 8),
          Text(
            summary.isMaxLevel
                ? l10n.xpCardMaxLevelReached
                : l10n.xpCardNextLevelValue(nextTitle),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            summary.isMaxLevel
                ? l10n.xpCardMaxLevel
                : l10n.xpCardRemainingValue(
                    countFormat.format(summary.xpRemainingToNextLevel),
                  ),
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A5A4A)),
          ),
        ],
      ),
    );
  }
}

String localizedXpLevelTitle(
  AppLocalizations l10n,
  int level,
  String fallback,
) {
  return _localizedLevelTitle(l10n, level, fallback);
}

String _localizedLevelTitle(AppLocalizations l10n, int level, String fallback) {
  return switch (level) {
    1 => l10n.xpLevelTitle1,
    2 => l10n.xpLevelTitle2,
    3 => l10n.xpLevelTitle3,
    4 => l10n.xpLevelTitle4,
    5 => l10n.xpLevelTitle5,
    6 => l10n.xpLevelTitle6,
    7 => l10n.xpLevelTitle7,
    8 => l10n.xpLevelTitle8,
    9 => l10n.xpLevelTitle9,
    10 => l10n.xpLevelTitle10,
    11 => l10n.xpLevelTitle11,
    12 => l10n.xpLevelTitle12,
    13 => l10n.xpLevelTitle13,
    14 => l10n.xpLevelTitle14,
    15 => l10n.xpLevelTitle15,
    16 => l10n.xpLevelTitle16,
    17 => l10n.xpLevelTitle17,
    18 => l10n.xpLevelTitle18,
    19 => l10n.xpLevelTitle19,
    20 => l10n.xpLevelTitle20,
    21 => l10n.xpLevelTitle21,
    22 => l10n.xpLevelTitle22,
    23 => l10n.xpLevelTitle23,
    24 => l10n.xpLevelTitle24,
    25 => l10n.xpLevelTitle25,
    26 => l10n.xpLevelTitle26,
    27 => l10n.xpLevelTitle27,
    28 => l10n.xpLevelTitle28,
    29 => l10n.xpLevelTitle29,
    30 => l10n.xpLevelTitle30,
    31 => l10n.xpLevelTitle31,
    32 => l10n.xpLevelTitle32,
    33 => l10n.xpLevelTitle33,
    34 => l10n.xpLevelTitle34,
    35 => l10n.xpLevelTitle35,
    36 => l10n.xpLevelTitle36,
    37 => l10n.xpLevelTitle37,
    38 => l10n.xpLevelTitle38,
    39 => l10n.xpLevelTitle39,
    40 => l10n.xpLevelTitle40,
    41 => l10n.xpLevelTitle41,
    42 => l10n.xpLevelTitle42,
    43 => l10n.xpLevelTitle43,
    44 => l10n.xpLevelTitle44,
    45 => l10n.xpLevelTitle45,
    46 => l10n.xpLevelTitle46,
    47 => l10n.xpLevelTitle47,
    48 => l10n.xpLevelTitle48,
    49 => l10n.xpLevelTitle49,
    50 => l10n.xpLevelTitle50,
    51 => l10n.xpLevelTitle51,
    52 => l10n.xpLevelTitle52,
    53 => l10n.xpLevelTitle53,
    54 => l10n.xpLevelTitle54,
    55 => l10n.xpLevelTitle55,
    56 => l10n.xpLevelTitle56,
    57 => l10n.xpLevelTitle57,
    58 => l10n.xpLevelTitle58,
    59 => l10n.xpLevelTitle59,
    60 => l10n.xpLevelTitle60,
    61 => l10n.xpLevelTitle61,
    62 => l10n.xpLevelTitle62,
    63 => l10n.xpLevelTitle63,
    64 => l10n.xpLevelTitle64,
    65 => l10n.xpLevelTitle65,
    66 => l10n.xpLevelTitle66,
    67 => l10n.xpLevelTitle67,
    68 => l10n.xpLevelTitle68,
    69 => l10n.xpLevelTitle69,
    70 => l10n.xpLevelTitle70,
    71 => l10n.xpLevelTitle71,
    72 => l10n.xpLevelTitle72,
    73 => l10n.xpLevelTitle73,
    74 => l10n.xpLevelTitle74,
    75 => l10n.xpLevelTitle75,
    76 => l10n.xpLevelTitle76,
    77 => l10n.xpLevelTitle77,
    78 => l10n.xpLevelTitle78,
    79 => l10n.xpLevelTitle79,
    80 => l10n.xpLevelTitle80,
    81 => l10n.xpLevelTitle81,
    82 => l10n.xpLevelTitle82,
    83 => l10n.xpLevelTitle83,
    84 => l10n.xpLevelTitle84,
    85 => l10n.xpLevelTitle85,
    86 => l10n.xpLevelTitle86,
    87 => l10n.xpLevelTitle87,
    88 => l10n.xpLevelTitle88,
    89 => l10n.xpLevelTitle89,
    90 => l10n.xpLevelTitle90,
    91 => l10n.xpLevelTitle91,
    92 => l10n.xpLevelTitle92,
    93 => l10n.xpLevelTitle93,
    94 => l10n.xpLevelTitle94,
    95 => l10n.xpLevelTitle95,
    96 => l10n.xpLevelTitle96,
    97 => l10n.xpLevelTitle97,
    98 => l10n.xpLevelTitle98,
    99 => l10n.xpLevelTitle99,
    100 => l10n.xpLevelTitle100,
    _ => fallback,
  };
}
