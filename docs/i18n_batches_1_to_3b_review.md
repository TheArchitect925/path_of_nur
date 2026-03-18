# i18n Review: Batches 1A to 3B

## 1. Executive Summary

- Overall status: `needs cleanup`
- Reviewed scope:
  - Batch 1A: Navigation + App Shell
  - Batch 1B: Home screen + dashboard/home widgets
  - Batch 2A: Settings
  - Batch 2B: Profile + Accounts + Sync
  - Batch 3A: Prayer UI
  - Batch 3B: Notifications + location/time/date/number formatting
- Verification status during review:
  - `flutter analyze` on the reviewed file set: passed
  - `flutter gen-l10n`: previously passed in implementation batches
  - `dart format`: passed on touched Dart files in implementation batches

### Remaining findings count

- Total remaining findings in reviewed batches: `14`
- By severity:
  - Critical: `0`
  - High: `6`
  - Medium: `5`
  - Low: `3`

### Top 10 follow-up fixes

1. Remove the remaining hardcoded Home shortcut/action labels and status text in [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart).
2. Localize Home duration/countdown text such as `0m`, `{hours}h {minutes}m`, and `Begins at` in [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart).
3. Localize the Home “Daily learning & quizzes” card and its CTA labels in [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart).
4. Fix notification/live-activity locale resolution to use the app-selected locale, not just the platform locale, in [local_notification_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/local_notification_service.dart) and [prayer_live_activity_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/prayer_live_activity_service.dart).
5. Remove duplicated `settings*` keys from [app_en.arb](/Users/shahabmansoor/Developer/path_of_nur/lib/l10n/app_en.arb) and preserve one canonical wording per key.
6. Resolve placeholder inconsistency for `settingsCurrentProfileSummary` in [app_en.arb](/Users/shahabmansoor/Developer/path_of_nur/lib/l10n/app_en.arb).
7. Move adhan option titles/subtitles away from raw English catalog data or provide localized display mapping for [adhan_option_picker_sheet.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/adhan_option_picker_sheet.dart).
8. Remove remaining English fallback getters in [prayer_name.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/domain/prayer_name.dart) and [prayer_status.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/domain/prayer_status.dart), or mark them internal-only and stop using them in user-facing paths.
9. Replace the English fallback subtitle template for learn-category search results in [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart).
10. Replace the `Reflection Draft` English sentinel comparison in [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) with a non-display identifier.

## 2. Batch-by-Batch Review

### Batch 1A: Navigation + App Shell

#### What was reviewed
- [app_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_scaffold.dart)
- [app_page_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_page_scaffold.dart)
- [profile_whats_new_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/profile_whats_new_page.dart)
- [profile_coming_soon_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/profile_coming_soon_page.dart)

#### What looks good
- Bottom navigation labels are localized and reused consistently.
- Navigation button tooltip and semantics labeling in [app_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_scaffold.dart) are correctly localized.
- Back button tooltip in [app_page_scaffold.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/app_page_scaffold.dart) uses `MaterialLocalizations` correctly.
- `What’s new` and `Coming soon` moved visible content to l10n and compile cleanly.

#### Remaining issues
- `What’s new` subtitle is still assembled manually as `version • dateLabel` instead of using a template key.

#### Regressions found
- None confirmed.

#### Consistency issues
- No significant shell/navigation terminology drift found.

#### Recommended next action
- Safe to leave as-is for now, but fold the `What’s new` subtitle into a localized template in the next cleanup pass.

### Batch 1B: Home screen + dashboard/home widgets

#### What was reviewed
- [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart)

#### What looks good
- Many section headers, summary rows, search labels, and count templates now use `AppLocalizations`.
- Number formatting was added in several places.
- Search tooltips and search field labels are localized.

#### Remaining issues
- Several visible Home labels remain hardcoded.
- Some duration/countdown strings still use English unit assembly.
- One search fallback subtitle is still assembled in English.
- Badge and daily-learning card copy remains English.
- One UI branch depends on comparing a visible English string (`Reflection Draft`).

#### Regressions found
- None confirmed, but Home remains the least complete reviewed batch.

#### Consistency issues
- Home still mixes localized strings and hardcoded English in the same surface.

#### Recommended next action
- Do a targeted `Batch 1B cleanup` before treating Home as complete.

### Batch 2A: Settings

#### What was reviewed
- [settings_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/settings_page.dart)
- [adhan_option_picker_sheet.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/adhan_option_picker_sheet.dart)

#### What looks good
- Main settings screen copy is now largely localized.
- Formatting helpers for counts, signed values, and times are locale-aware.
- Existing settings flow and behavior were preserved.

#### Remaining issues
- Adhan option catalog titles/subtitles are still sourced from raw `option.title` / `option.subtitle`, which are likely English data values.
- ARB hygiene degraded because a second `settings*` block was appended instead of consolidating keys.

#### Regressions found
- None confirmed.

#### Consistency issues
- Duplicate settings keys create wording conflicts such as `Profile and personalization` vs `Profile & Personalization`, and `Prayer notifications` vs `Prayer Notifications`.

#### Recommended next action
- Consolidate settings ARB keys and decide whether adhan option display text should be localized through keys or a mapped presentation layer.

### Batch 2B: Profile + Accounts + Sync

#### What was reviewed
- [accounts_profiles_sync_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart)
- [profile_summary_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/profile_summary_page.dart)

#### What looks good
- Most account/sync UI copy is localized.
- Last-sync/backup formatting uses locale-aware `DateFormat`.
- Profile summary numbers are locale-aware.

#### Remaining issues
- `_transportLabel(...)` still depends on matching persisted English labels like `Local storage` and `iCloud`.
- This is workable, but it leaves English-coupled presentation logic in the UI layer.

#### Regressions found
- None confirmed.

#### Consistency issues
- No major wording drift beyond the ARB duplication problem.

#### Recommended next action
- Keep behavior, but move transport/provider presentation onto stable identifiers rather than persisted English text.

### Batch 3A: Prayer UI

#### What was reviewed
- [prayer_section.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/presentation/widgets/prayer_section.dart)
- [prayer_location_picker_sheet.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/shared/widgets/prayer_location_picker_sheet.dart)
- [prayer_name.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/domain/prayer_name.dart)
- [prayer_status.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/domain/prayer_status.dart)

#### What looks good
- Main prayer hub copy is localized.
- Prayer location picker copy is localized.
- Prayer stats use locale-aware number/date/time formatting.

#### Remaining issues
- `PrayerName.label` and `PrayerStatus.label` still return English literals.
- These appear to be fallback helpers, but they remain a risk if reused in UI later.

#### Regressions found
- None confirmed.

#### Consistency issues
- Localized methods exist, but English fallback getters remain alongside them.

#### Recommended next action
- Either remove those fallback getters from user-facing code paths or document them as internal-only and stop exposing them to UI layers.

### Batch 3B: Notifications + location/time/date/number formatting

#### What was reviewed
- [local_notification_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/local_notification_service.dart)
- [prayer_live_activity_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/prayer_live_activity_service.dart)
- [qibla_finder_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/presentation/qibla_finder_page.dart)

#### What looks good
- Notification titles, bodies, channel labels, and fasting live-activity strings are localized.
- Qibla-facing text and visible numeric formatting are localized.
- Compile/analyze status is clean.

#### Remaining issues
- Notification/live-activity localization uses `platformDispatcher.locale`, not the app-selected locale.
- If the user selects a different language inside the app than the system language, notifications and fasting live activity will likely display in the wrong language.

#### Regressions found
- No scheduling or trigger regressions confirmed.

#### Consistency issues
- Qibla surface is aligned with the rest of prayer UI.
- Notification locale sourcing is inconsistent with widget-based UI localization.

#### Recommended next action
- Add a single locale-resolution path for background/push/local-notification text that respects the app’s persisted language selection.

## 3. Findings Table

| Severity | Batch | Category | Feature area | File | Line(s) | Snippet | Why it is a problem | Recommended fix | Effort |
|---|---|---|---|---|---|---|---|---|---|
| High | 1B | Hardcoded UI text | Home shortcuts | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 606, 739, 857, 871, 924, 955, 991 | `'Qibla'`, `'Offered'`, `'$missedCount missed'`, `'Daily dhikr goal reached'`, `'Close'`, `'Shortcuts'`, `'Salah'`, `'Dhikr'` | Visible Home strings remain English and break batch completeness. | Move all of these into ARB keys and reuse existing keys where possible. | Small |
| High | 1B | Formatting/template | Home prayer countdown | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 1831, 2039-2044 | `'Begins at'`, `'0m'`, `'${minutes}m'`, `'${hours}h ${minutes}m'` | Visible durations and labels are still English-specific and not locale-safe. | Replace with localized templates and plural/unit-aware formatting keys. | Small |
| High | 1B | Hardcoded UI text | Home daily learning card | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 3180-3254 | `'Daily learning & quizzes'`, `'Keep daily revelation...'`, `'Prophets Quiz'`, `'Islamic Trivia'`, `'Knowledge Paths'`, `'Review Mistakes'` | High-visibility Home card remains unlocalized. | Add ARB keys and route all CTA labels through l10n. | Small |
| High | 3B | Locale resolution | Notifications/live activity | [local_notification_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/local_notification_service.dart), [prayer_live_activity_service.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/core/reminders/prayer_live_activity_service.dart) | 546; 328-329 | `lookupAppLocalizations(WidgetsBinding.instance.platformDispatcher.locale)` | Uses device locale, not app-selected locale. Incorrect language is likely when in-app language differs from system language. | Resolve locale from persisted app preference and centralize non-widget localization access. | Medium |
| High | 2A | ARB hygiene | Settings localization file | [app_en.arb](/Users/shahabmansoor/Developer/path_of_nur/lib/l10n/app_en.arb) | 3855-3947; 4135-4459 | duplicated `settings*` keys | Duplicate keys create ambiguous source of truth and inconsistent wording. | Remove duplicated block and keep one canonical definition per settings key. | Medium |
| High | 2A | Placeholder inconsistency | Settings templates | [app_en.arb](/Users/shahabmansoor/Developer/path_of_nur/lib/l10n/app_en.arb) | 3866; 4459 | `{name} • {mode}` vs `{name} • {syncMode}` | Same key duplicated with different placeholder contracts is structurally risky. | Keep a single placeholder contract and regenerate l10n. | Small |
| Medium | 2A | Data-backed visible text | Settings / Adhan picker | [adhan_option_picker_sheet.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/adhan_option_picker_sheet.dart) | 71-73 | `Text(option.title)`, `option.subtitle ?? ''` | User-facing adhan option names/descriptions still come from raw data and are likely English-only. | Add localized presentation mapping for option IDs or localize the source catalog. | Medium |
| Medium | 3A | English fallback getters | Prayer domain labels | [prayer_name.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/domain/prayer_name.dart), [prayer_status.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/domain/prayer_status.dart) | 23-34; 17-24 | `String get label => 'Fajr'`, `=> 'Pending'` | Leaves English literals in domain helpers that can leak back into UI. | Remove or deprecate fallback getters for user-facing use. | Small |
| Medium | 1B | English fallback subtitle | Home search | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 1345 | `'Learn category • ${item.sectionType.replaceAll('-', ' ')}'` | Mixed localization in search results; fallback text is English and manually assembled. | Replace with a parameterized template and localized category label mapping. | Small |
| Medium | 1B | English sentinel logic | Home learn summary | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 2602 | `learn.resumeNoteTitle == 'Reflection Draft'` | Business/UI logic is coupled to an English display string. | Compare against a stable note type/id instead of visible text. | Medium |
| Medium | 2B | English-coupled mapping | Accounts sync transport labels | [accounts_profiles_sync_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart) | 1313-1316 | `case 'Local storage'`, `case 'iCloud'` | UI mapping depends on persisted English label values. | Map from stable transport identifiers instead of English text. | Medium |
| Low | 1A | Template consistency | What’s New page | [profile_whats_new_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/profile_whats_new_page.dart) | 65 | `subtitle: Text('${entry.version} • ${entry.dateLabel}')` | Works, but the composed subtitle is not localized as a template. | Add one key for version/date display if you want full consistency. | Small |
| Low | 1B | Badge copy | Home rewards | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 2249, 2259 | `'${badge.earnedCount} earned'`, `'Earned today'` | Visible badge/reward copy remains English. | Add two ARB keys, including a count template. | Small |
| Low | 1B | Accessibility consistency | Home shortcut chips | [home_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart) | 1010-1125 | `_FloatingShortcutChip` has no explicit semantics/tooltip for main chip | Screen readers will still read text, but accessibility treatment is inconsistent with app shell buttons. | Add optional semantics label/tooltip for shortcut chips if desired. | Small |

## 4. Key Review

### Keys added
- The reviewed batches added a substantial number of targeted keys for Home, Settings, Accounts/Sync, Prayer, Notifications, and Qibla.
- Batch 3B keys for notifications and Qibla are structurally aligned and include placeholder metadata where needed.

### Keys reused well
- Navigation keys in app shell were reused correctly.
- Existing `settingsPrayerName*` keys were reused across prayer/notification surfaces.
- Existing count/value keys such as `homeFractionValue`, `homeDaysCount`, `homeXpValue` were reused well in several places.

### Duplicate or weak keys
- `settings*` keys are duplicated in [app_en.arb](/Users/shahabmansoor/Developer/path_of_nur/lib/l10n/app_en.arb).
- Duplicates include wording drift and placeholder drift.
- This is the biggest ARB hygiene problem in the reviewed batches.

### Keys that should be consolidated
- `settingsCurrentLocation`
- `settingsProfilePersonalizationTitle`
- `settingsPrayerNotificationsTitle`
- `settingsPrayerNameFajr` and related prayer-name keys
- `settingsCurrentProfileSummary`
- Most of the late appended settings block around lines `4135+`

### Missing placeholders / metadata
- No confirmed missing placeholder metadata in the newly reviewed 3B keys.
- The main template issue is duplicated placeholder shape for `settingsCurrentProfileSummary`, not absent metadata.

## 5. Formatting / Template Review

### Interpolation issues remaining
- Home duration strings are still English-assembled.
- Home shortcut badge and reward strings remain manually interpolated.
- `What’s new` subtitle still uses manual `version • date` assembly.
- Home learn-category search fallback still uses manual English assembly.

### Pluralization issues remaining
- Home `missedCount missed` should become a pluralized template.
- Home badge earned count should be a count template, and possibly pluralized depending on product wording.

### Locale formatting issues remaining
- Home duration formatting still uses `h` / `m` English-style shorthand.
- Notification/live-activity locale source ignores app-selected locale.
- Accounts sync relative time formatting is acceptable in the reviewed file.
- Prayer UI date/time formatting is acceptable in the reviewed file.

## 6. Accessibility Review

### Localized well
- App shell nav buttons have localized tooltip and semantics labels.
- Page scaffold back affordance uses `MaterialLocalizations`.
- Adhan preview tooltips are localized.

### Missing or hardcoded accessibility text
- Home shortcut chips do not expose explicit localized semantics/tooltip labels for the main chip action.
- No confirmed hardcoded accessibility text was found in the shell/navigation files reviewed.

### Recommended cleanup
- Add optional semantics wrappers for Home shortcut chips if these controls are meant to match the shell-level accessibility quality.

## 7. Regression / Risk Notes

- `flutter analyze` on the reviewed file set passed during this review.
- No compile regressions were found in the reviewed batch files.
- No confirmed routing or behavior regressions were found in navigation, settings, prayer UI, or accounts/sync.
- Highest likely runtime correctness issue: notifications/live-activity text may appear in the wrong language when the app language differs from the device language.
- Highest maintainability issue: duplicated `settings*` ARB keys make future localization edits fragile.
- Home remains incomplete enough that manual QA should specifically cover:
  - Home shortcut dock
  - Home prayer card countdown labels
  - Home daily learning card
  - Home reward badges

### Test impact
- No tests were run in this review.
- If widget/golden tests exist for Home, Settings, Prayer, or Accounts Sync, they may need string expectation updates once the remaining cleanup pass is done.

## 8. Recommended Follow-up Prompt Plan

1. `Batch 1–3 cleanup pass: Home residual strings + notification locale source + ARB settings deduplication`
2. `Batch 4: Dhikr + streaks + XP + rings`
3. `Batch 5: Ocean / Community`
4. `Batch 6: Learning + kids/family residual i18n sweep`
5. `Batch 7: dialogs / errors / forms / placeholders`
6. `Batch 8: semantics / accessibility / template normalization`
7. `Final ARB hygiene pass: duplicate-key cleanup, stale-key review, locale consistency`

### Must fix before moving on
- Notification/live-activity locale source
- ARB `settings*` duplication
- Remaining hardcoded Home strings in the reviewed batch scope

### Safe to defer
- `What’s new` subtitle template cleanup
- Home shortcut accessibility enhancement
- Transport-label identifier cleanup if you need to prioritize user-visible fixes first
