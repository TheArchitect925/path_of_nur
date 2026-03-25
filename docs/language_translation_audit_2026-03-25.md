# Language And Translation Audit

Date: 2026-03-25
Scope: repo-wide localization and translation audit

## Executive Summary

The app's localization infrastructure is present and active:
- generated `AppLocalizations` is in use
- `lib/l10n/app_*.arb` locale resources exist for the current shipped locale set
- locale propagation and RTL behavior were already validated in prior test coverage

The current risk is not missing localization infrastructure. The main risk is content quality and coverage:
- many live screens still contain hardcoded English strings
- many non-English ARB files still rely heavily on English fallback values
- recently added keys often land in `app_en.arb` first and stay English in other locale files

This means the app is structurally localization-ready, but not translation-complete.

## Locale Coverage Snapshot

Detected locale resource files:
- `app_en.arb`
- `app_ar.arb`
- `app_bn.arb`
- `app_de.arb`
- `app_fa.arb`
- `app_fa_AF.arb`
- `app_ha.arb`
- `app_hi.arb`
- `app_id.arb`
- `app_ku.arb`
- `app_ms.arb`
- `app_pa.arb`
- `app_ps.arb`
- `app_tg.arb`
- `app_tr.arb`
- `app_ur.arb`

## Key Audit Findings

### 1. Localization plumbing is healthy

The project already has:
- generated localization outputs under `lib/l10n`
- app-wide `AppLocalizations` usage
- existing locale integration coverage recorded in `LOCALIZATION_INTEGRITY_BACKLOG.md`

This is a cleanup and completion problem, not a missing-system problem.

### 2. English fallback debt is still very large

A same-as-English comparison against `app_en.arb` shows high fallback usage in most locale files.

Snapshot:
- `app_ar.arb`: 1694 keys still identical to English
- `app_bn.arb`: 8919 keys still identical to English
- `app_de.arb`: 1917 keys still identical to English
- `app_fa.arb`: 8869 keys still identical to English
- `app_fa_AF.arb`: 8869 keys still identical to English
- `app_ha.arb`: 8988 keys still identical to English
- `app_hi.arb`: 3937 keys still identical to English
- `app_id.arb`: 8120 keys still identical to English
- `app_ku.arb`: 8959 keys still identical to English
- `app_ms.arb`: 8927 keys still identical to English
- `app_pa.arb`: 8941 keys still identical to English
- `app_ps.arb`: 8933 keys still identical to English
- `app_tg.arb`: 8937 keys still identical to English
- `app_tr.arb`: 8115 keys still identical to English
- `app_ur.arb`: 2123 keys still identical to English

Interpretation:
- Arabic and Urdu are materially ahead of most other locales, but still incomplete
- German and Hindi are better than the largest-fallback locales, but still not release-clean
- Bengali, Persian, Hausa, Indonesian, Kurdish, Malay, Punjabi, Pashto, Tajik, and Turkish remain heavily fallback-driven

### 3. Live hardcoded-string debt still exists

The older backlog remains directionally correct: there are still user-facing literal strings in code, especially on learning and onboarding surfaces.

Current live scan highlights:
- `lib/features/onboarding/presentation/onboarding_page.dart`
- `lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart`
- `lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart`
- `lib/features/learn/world/presentation/world_landing_page.dart`
- `lib/features/learn/presentation/pages/learn_salah_hub_page.dart`
- `lib/features/learn/life/baby_names/presentation/baby_names_favorites_page.dart`
- `lib/features/learn/quran/presentation/quran_reader_page.dart`
- `lib/features/salah/presentation/salah_page.dart`

Examples confirmed in live code:
- `onboarding_page.dart`
  - `Skip`
  - `You can change this anytime in Settings.`

This means there are still screens where changing locale will not fully change the user-facing text.

### 4. High-traffic settings/account surfaces are better localized than older backlog counts suggest

The current top-level settings and accounts/sync pages are using `AppLocalizations` heavily:
- `lib/features/profile/presentation/settings_page.dart`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`

These are no longer the best examples of raw hardcoded-text debt. Their larger remaining risk is:
- recently added keys landing in English fallback in non-English ARBs
- dialog/snackbar and long-tail action copy that still needs multilingual review

### 5. Qur'an localization is in a better state than many surrounding features

Recent passes moved more Qur'an reader/player/settings strings into ARBs. The remaining Qur'an risk is now mostly:
- non-English fallback values for newer keys
- surface polish and consistency review, not foundational localization absence

## Highest-Risk Areas

### Tier 1: translation completeness risk

These locale files need the largest real translation payoff:
- `lib/l10n/app_bn.arb`
- `lib/l10n/app_fa.arb`
- `lib/l10n/app_fa_AF.arb`
- `lib/l10n/app_ha.arb`
- `lib/l10n/app_id.arb`
- `lib/l10n/app_ku.arb`
- `lib/l10n/app_ms.arb`
- `lib/l10n/app_pa.arb`
- `lib/l10n/app_ps.arb`
- `lib/l10n/app_tg.arb`
- `lib/l10n/app_tr.arb`

### Tier 2: live hardcoded UX debt

Highest-value screens to localize next:
- `lib/features/onboarding/presentation/onboarding_page.dart`
- `lib/features/profile/presentation/settings_page.dart`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart`
- `lib/features/salah/presentation/salah_page.dart`
- `lib/features/worship/presentation/widgets/prayer_section.dart`
- `lib/features/worship/presentation/widgets/dhikr_section.dart`
- `lib/features/learn/world/presentation/world_landing_page.dart`
- `lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart`

### Tier 3: long-tail consistency debt

Needs follow-up after Tier 1 and Tier 2:
- snackbars, dialogs, helper labels, and empty states
- recently added section headers and subtitles
- secondary learning surfaces that are route-active but lower traffic

## Information Quality Assessment

### What is good
- localization generation flow is present
- locale files are structured consistently
- major routed surfaces increasingly use `AppLocalizations`
- Qur'an and settings localization direction is improving

### What is weak
- translation coverage across locales is highly uneven
- too many new keys still ship as English fallback outside `app_en.arb`
- several active user flows still contain literal English in widgets

## Recommended Next Sequence

1. Remove hardcoded English from the highest-traffic live surfaces first.
2. Replace English fallback values for the newest live keys in all non-English locale files.
3. Run a dedicated settings/accounts multilingual review pass.
4. Run a focused onboarding localization pass.
5. After the biggest live UX debt is cleaned, start locale-by-locale translation payoff for the most fallback-heavy ARBs.

## Suggested Implementation Order

### Batch A
- onboarding
- settings
- accounts/sync
- prayer/worship entry surfaces

### Batch B
- world/life/learn high-traffic browse pages
- snackbars/dialogs/helper text normalization

### Batch C
- non-English ARB fallback reduction, starting with Arabic/Urdu/German/Hindi cleanup quality, then large fallback locales

## Validation Notes

This audit was based on:
- repo-local localization/backlog state
- generated locale resource inventory
- same-as-English ARB comparison
- live code scan for literal `Text(...)` usage and button/dialog/snackbar hotspots

## Conclusion

The app is localization-capable today, but not language-complete. The next meaningful work is not another architecture pass. It is a disciplined cleanup pass that:
- removes remaining literal English from active screens
- reduces English fallback in non-English ARBs
- prioritizes the highest-traffic user journeys first
