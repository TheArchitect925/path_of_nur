# Large Family Localization Audit — 2026-04-13 (quran batch refresh)

Date: 2026-04-13
Scope: non-English `app_*.arb` files, 15 locales, family-prefix scan over `lib/l10n/app_en.arb`

## Family debt snapshot (updated)

| Family | Total keys | Same-as-English occurrences | Keys still English in all 15 locales |
|---|---:|---:|---:|
| `learning` | 2,095 | 22,176 | 24 |
| `quran` | 1,555 | 16,857 | 608 |
| `learn` | 3,149 | 34,387 | 435 |
| `kids` | 988 | 10,711 | 76 |

> Note: this is an audit-only refresh to confirm next execution priorities.

## Quran family now active (next in sequence)

- Worst untranslated burden:
  - `ur`: 828
  - `ar`: 841
  - `de`: 846
- Best localized so far:
  - `ku`: 1,295
  - `bn`: 1,287
  - `ms`: 1,287
- `quran` keys still all-English in all 15 locales: 608

## Immediate "next-step" hotspots (all 15 locales still English)

- `quranUserIntentUnderstandRecommendation`
- `quranUserIntentUnderstandLabel`
- `quranUserIntentTitle`
- `quranUserIntentThemesRecommendation`
- `quranTeachingVisualModeToggle`
- `quranTeachingReviewWords`
- `quranTeachingReviewSessionHeaderTitle`
- `quranTeachingReviewPageCompleteTitle`
- `quranTeachingResumeAction`
- `quranTeachingPathTitle`
- `quranTeachingModuleLessonsTitle`
- `quranTeachingLevelReadSlowlyTitle`
- `quranTeachingLessonNextLesson`
- `quranTeachingLessonNoForwardJoinHint`
- `quranTeachingChooseLevelTitle`
- `quranTeachingContinueTitle`

## Next commands to run when ready

1. `python3 tools/localization_stage_translate.py --source lib/l10n/app_en.arb --target <locale>`
   - run one locale at a time and keep generated files for review.
2. `python3 tools/localization_validate.py --source lib/l10n/app_en.arb --locales ar bn de fa fa_AF ha hi id ku ms pa ps tg tr ur`
3. Repeat only for non-blocked locales until `quran*` debt drops by the desired tranche.
