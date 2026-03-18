# Final i18n Audit Report

## 1. Executive Summary

- Overall status: `needs follow-up`
- Total remaining findings after final cleanup: `12`
- Findings by severity:
  - Critical: `0`
  - High: `4`
  - Medium: `5`
  - Low: `3`
- Summary of what was fixed in this final pass:
  - localized remaining safe visible strings in shared Quran reference UI
  - localized remaining safe visible strings in Salah tracking and Qada guidance UI
  - localized remaining daily review and listen-only Quran teaching UI strings
  - converted those final safe strings to ARB-backed templates/placeholders where needed
  - kept `flutter gen-l10n`, `dart format`, and `flutter analyze` clean after the pass
- Summary of what remains deferred:
  - some feature-isolated screens still contain user-visible hardcoded strings
  - some shared/domain helpers still return English fallback strings
  - non-English locale coverage remains incomplete for recently added English keys

## 2. Final Fixes Applied

### Shared Quran reference UI
- Feature area: Shared widgets
- Files changed:
  - `lib/shared/widgets/quran_reference_block.dart`
  - `lib/l10n/app_en.arb`
- Type of issue fixed:
  - hardcoded button/action labels
  - hardcoded fallback/load states
- Explanation:
  - moved the shared Quran reference card's remaining visible strings into the localization layer and reused the existing reader action key where possible.

### Salah tracking and Qada helper UI
- Feature area: Salah / Worship
- Files changed:
  - `lib/features/salah/presentation/salah_page.dart`
  - `lib/l10n/app_en.arb`
- Type of issue fixed:
  - hardcoded section labels
  - hardcoded sheet actions
  - hardcoded note field labels/hints
  - manually assembled tracked-progress text
- Explanation:
  - localized the remaining safe tracker-sheet strings and replaced a visible progress string with a parameterized template.

### Quran teaching daily review UI
- Feature area: Learn / Quran teaching
- Files changed:
  - `lib/features/learn/quran_teaching/presentation/quran_teaching_daily_review_page.dart`
  - `lib/l10n/app_en.arb`
- Type of issue fixed:
  - empty states
  - review actions
  - replay/reveal labels
  - true/false chips
  - final feedback fallback text
- Explanation:
  - moved remaining user-facing review text into ARB-backed strings while preserving review logic and existing quiz content.

### Quran teaching listen-only UI
- Feature area: Learn / Quran teaching
- Files changed:
  - `lib/features/learn/quran_teaching/presentation/quran_teaching_listen_only_page.dart`
  - `lib/l10n/app_en.arb`
- Type of issue fixed:
  - helper/subtitle text
  - form labels
  - playback status/fallback text
  - mode options
  - progress and duration templates
- Explanation:
  - localized the remaining listen-only shell strings and converted dynamic labels into templates without changing playback flow.

## 3. Remaining Findings Table

| Severity | Category | Feature area | File path | Line(s) | Snippet | Why it remains | Recommended next step | Effort |
|---|---|---|---|---|---|---|---|---|
| High | Hardcoded user-facing strings | Creation Explorer | `lib/features/creation_explorer/presentation/creation_explorer_page.dart` | 374, 390, 549, 554, 568, 576, 897, 1064-1080 | `Close`, `Save observation`, `Allow camera`, `Open settings`, `Camera unavailable`, `Retry`, `Open camera explore`, `Edit reflection` | Confirmed remaining visible strings in dialogs, CTA buttons, and permission-style UI. Safe, but outside the narrow final-fix subset applied here. | Localize the remaining creation-explorer actions, dialog labels, and permission helper text in one focused follow-up. | Medium |
| High | Hardcoded user-facing strings | Growth / Reflection | `lib/features/journey/presentation/growth_reflection_page.dart` | 58-61, 85-88, 117-138, 207-323, 336-407 | `Recent Changes`, `Seasonal prompts`, `Daily reflection prompt`, `Save Reflection`, `End-of-day summary` | Entire reflection surface still mixes adult-facing hardcoded labels, hints, and summaries. | Run a focused Growth Reflection localization pass. | Medium |
| High | Helper-level English output | Prayer shared logic | `lib/core/prayer/prayer_preferences.dart` | 370-380, 681, 1558, 1571, 1592, 1602 | `It becomes qada at sunrise...`, `Unknown prayer adjustment.`, `Enter all five daily salah times...` | Shared helper/validation strings can still surface in UI and are not localization-safe. | Move these strings behind `AppLocalizations`-backed adapters or pass localized text from consuming UI. | Large |
| High | Helper-level English output | Prayer tracker shared logic | `lib/features/worship/application/prayer_tracker_controller.dart` | 275-282 | `Queue clear...`, `Light cadence...`, `Steady cadence...`, `Focused cadence...` | User-visible cadence summaries still originate from controller English literals. | Convert cadence summaries to stable IDs or localized mappings at presentation boundary. | Medium |
| Medium | Hardcoded user-facing strings | Growth / Habits | `lib/features/journey/presentation/growth_habits_page.dart` | 99-100, 170, 178, 226, 417-430, 560 | `still in progress`, `Light added today`, `Qur’an completion plan`, `Pause for today`, `Save` | Visible progress labels and action text remain unlocalized. | Localize the habits page summaries and action sheet labels. | Medium |
| Medium | Hardcoded user-facing strings | Fasting UI | `lib/features/worship/presentation/widgets/fasting_section.dart` | 184 | `Gentle reminder` | Confirmed remaining visible section label in fasting UI. | Localize the fasting section header and complete a small fasting wording sweep. | Small |
| Medium | Helper-level English output | Growth shared helpers | `lib/features/journey/presentation/widgets/growth_ui_helpers.dart` | 28 | `return 'Steady';` | Shared display helper still returns English directly, which leaks into UI. | Replace with localized mapping or ID-based adapter. | Small |
| Medium | Helper-level English output | Fasting shared enums | `lib/features/worship/domain/fasting_status.dart` | 12-18 | `Not fasting`, `Intending to fast`, `Completed` | Domain enum labels remain English-only. | Add localized label methods and migrate consumers. | Small |
| Medium | Helper-level English output | Fasting shared enums | `lib/features/worship/domain/fasting_type.dart` | 13-21 | `Ramadan fast`, `Sunnah fast`, `Make-up fast (Qada)` | Domain enum display text remains English-only. | Add localized label methods and migrate consumers. | Small |
| Low | Hardcoded user-facing strings | Circles / Community Events | `lib/features/circles/presentation/community_events_page.dart` | 258, 566 | `Text('\${_dateLabel(event.date)} • \${event.location}')`, `label: '\$capacity'` | Remaining visible formatting and labels are still partly raw. | Localize card summary formatting and any supporting labels. | Small |
| Low | Resource completeness | ARB / locales | `lib/l10n/*.arb` | n/a | untranslated counts from `flutter gen-l10n` | Structure is healthy, but non-English locales still fall back to English for many newer keys. | Translate missing keys in supported locales before release. | Large |
| Low | Accessibility coverage gaps | Several untouched screens | Multiple | n/a | missing meaningful semantics on some non-icon tappables | Not a structural break, but some screens still lack accessibility-localization coverage. | Do a final targeted accessibility audit on untouched feature surfaces. | Medium |

## 4. Localization Resource Health

- Duplicate key status: `acceptable`
  - The obvious duplicate keys addressed in earlier cleanup passes remain resolved.
  - No new duplicate keys were introduced in this final pass.
- Stale key status: `acceptable`
  - Conservative dead-key cleanup was already applied in Batch 12.
  - No new dead keys were identified in the narrow final-fix subset.
- Placeholder consistency status: `strong`
  - Newly added Batch 13 templates use explicit placeholders where needed.
  - `flutter gen-l10n` succeeded after the final pass, indicating no ARB shape errors.
- Cross-locale shape consistency status: `acceptable`
  - Generated localization still builds cleanly.
  - Translation completeness remains incomplete in non-English ARBs, but shape consistency is intact.
- Terminology consistency notes:
  - The reviewed and fixed surfaces now use stable terms for `Qada`, `Salah`, `review`, and `listen only`.
  - Remaining terminology drift exists mostly in untouched Growth and Creation Explorer surfaces.

## 5. Locale / Formatting Health

- App-locale usage status: `acceptable`
  - Notification/live activity locale handling had already been corrected in earlier cleanup.
  - The Batch 13 fixes did not introduce any device-locale-only regressions.
- Date/time/number/duration formatting status: `acceptable`
  - Batch 13 added no non-localized numeric formatting regressions.
  - Listen-only progress and duration strings are now template-backed and localization-safe.
- Remaining formatting risks:
  - Some untouched features still build summary strings directly in widgets instead of through locale-aware helpers.
  - Some legacy shared helpers in prayer/growth domains still produce English summary output.

## 6. Accessibility Localization Health

- Semantics/tooltips status: `acceptable`
  - Earlier accessibility batch work remains intact.
  - The final pass did not add new hardcoded tooltip/semantic text.
- Missing coverage if any:
  - Some untouched feature screens still need better semantics on tappable cards and progress summaries.
- Remaining accessibility-localization concerns:
  - Creation Explorer and some Growth surfaces still mix visible CTA text and accessibility-adjacent controls without full localization cleanup.

## 7. Release Readiness Recommendation

- Safe for continued feature development from an i18n perspective: `Yes`
- Safe for QA from an i18n perspective: `Yes, with known deferred areas tracked`
- Safe for beta/release from an i18n perspective: `Not fully yet`

Final must-fix items before a localization-sensitive beta/release:
- localize remaining hardcoded user-facing strings in Creation Explorer and Growth Reflection/Habits
- move remaining shared prayer and fasting helper/domain English output behind localization-safe mappings
- close the remaining high-severity helper-level English output in shared prayer logic
- complete non-English translation coverage for required release locales
