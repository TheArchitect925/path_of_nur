# Post-final i18n Verification Audit

## Executive Summary

- Overall status: `needs follow-up before multilingual release`
- Total remaining issues: `24`
- Severity counts:
  - Critical: `0`
  - High: `8`
  - Medium: `10`
  - Low: `6`
- Breakdown:
  - Code-side localization debt: `18`
  - Translation coverage debt: `3`
  - QA/manual verification debt: `3`

What this audit confirms:
- The app is compile-clean and localization generation still works.
- Recent batches are wired in and active in the audited surfaces.
- Code-side localization is no longer blocked by the previously identified Creation Explorer / Growth Reflection / Growth Habits / Prayer helper / Fasting helper items.
- The remaining risk is now concentrated in older or untouched feature surfaces plus large non-English translation gaps.

## Remaining Code-Side Issues

| Severity | Feature area | File path | Line(s) | Snippet | Category | Why it matters | Recommended fix | Effort |
|---|---|---|---|---|---|---|---|---|
| High | Celestial | `lib/features/celestial/presentation/celestial_explorer_page.dart` | 175, 188, 205, 250, 265, 270, 292 | `Sunrise ...`, `Reflect`, `Sky reflection saved.` | Hardcoded user-facing strings + locale formatting | Visible core UI still contains raw English and locale-implicit date/time assembly. | Localize page-level CTA/snackbar/hints and route all celestial time strings through l10n-aware formatting. | Medium |
| High | Celestial | `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart` | 111, 158, 165, 178, 188, 208, 354, 358, 473, 481, 558 | `Choose city`, `Enable location`, `Sunrise ...` | Hardcoded user-facing strings + formatting | Important user-facing weather/sky cycle surface still not fully localized. | Localize remaining labels/actions and pass locale explicitly to date/time formatting. | Medium |
| High | Learning / Quran teaching | `lib/features/learn/quran_teaching/presentation/quran_teaching_section_page.dart` | 162, 264, 294, 330, 428, 495, 745-787 | `Open`, `Use Visual Mode`, `Open Listen Only`, mode labels/descriptions | Hardcoded UI + helper-return English | This is a primary learning flow and still exposes English shell strings. | Focused Quran teaching section pass with key reuse where possible. | Medium |
| High | Learning / Quran teaching | `lib/features/learn/quran_teaching/presentation/quran_teaching_review_page.dart` | 43, 83-95, 222-235, 274, 282 | `Review Mistakes`, `Review all`, `Quick 5`, `Start another review` | Hardcoded UI strings | Review flow remains partially English-only. | Localize review mode labels, stats labels, actions, and boolean options. | Medium |
| High | Learning / Salah | `lib/features/learn/salah/presentation/salah_guided_prayer_page.dart` | 69, 94, 160, 166, 190, 204 | `Guided prayer unavailable.`, `Current rakah`, `Repeat Step` | Hardcoded UI strings | Core guided prayer learning surface still contains user-visible English strings. | Localize guided prayer fallback, toggles, and controls. | Medium |
| High | Learning / Hadith | `lib/features/learn/hadith/presentation/hadith_landing_page.dart` | 138, 146, 303, 337, 435, 453, 497-520, 673 | `Start with Essential Hadith`, `Random Review`, `Weekly Knowledge Check` | Hardcoded UI strings | Main hadith landing still contains many hardcoded shell and review labels. | Localize landing actions, search hints, empty states, and review entry points. | Large |
| High | Learning / Baby Names | `lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart` | 156, 186-245, 293-398, 413, 475-520 | `All`, `Boys`, `Girls`, `Favorites`, sort labels, empty states | Hardcoded UI strings | Large browse/filter surface remains English-only. | Localize filters, sort labels, empty states, and action buttons. | Large |
| High | Shared locale correctness | `lib/features/celestial/application/celestial_services.dart` | 259, 283-289, 596-670 | `Dawn is unfolding`, `New moon`, `in X min`, `Unavailable` | Helper-level English + wrong locale source risk | Shared celestial output still returns English and uses locale-implicit formatting. | Add localized adapters and explicit locale input. | Large |
| Medium | Worship / Khusu | `lib/features/worship/presentation/widgets/khusu_section.dart` | 116 | `Enter Khusū` | Hardcoded CTA | Visible CTA remains English. | Localize CTA and review nearby labels in the Khusu surface. | Small |
| Medium | FAQ | `lib/features/faq/pages/faq_detail_page.dart` | 25, 151, 155 | `FAQ item not found.`, `Unable to load FAQ. $error` | Hardcoded fallback/error text | User-visible error/fallback strings remain English. | Localize FAQ load/fallback text and remove raw error interpolation from UI. | Small |
| Medium | FAQ | `lib/features/faq/pages/faq_category_page.dart` | 97, 101, 126-132 | `Unable to load category. $error`, `All`, `Featured`, `Beginner` | Hardcoded error/filter text | Filter labels and load-state text remain English. | Localize filter labels and category load errors. | Small |
| Medium | FAQ | `lib/features/faq/pages/faq_landing_page.dart` | 233, 283 | `No matching questions found.`, `Unable to load FAQ right now. $error` | Hardcoded empty/error text | Visible empty/error states remain English. | Localize empty/error strings and avoid raw error exposure. | Small |
| Medium | Learning / Dua | `lib/features/learn/dua/presentation/dua_hub_page.dart` | 151, 207, 330, 377, 414, 426 | `All categories`, `Open dua`, `View verified duas` | Hardcoded shell text | Dua discovery flow still has English search/filter/action strings. | Focused dua hub UI localization pass. | Medium |
| Medium | Learning / Dua | `lib/features/learn/dua/presentation/dua_detail_page.dart` | 48, 63, 93, 208, 222 | `Dua`, `Dua not found.`, `Mark reflected` | Hardcoded fallback/action text | Detail page still partly English-only. | Localize fallback/action strings. | Small |
| Medium | Learning / World | `lib/features/learn/world/presentation/world_landing_page.dart` and related world pages | multiple | `Explore Creation`, `Creation Challenges`, `Sky Explorer`, `Open lesson` | Hardcoded shell text | World discovery shell still has many English CTA labels. | Dedicated world-shell localization pass. | Large |
| Medium | Learning / Divine Life Lessons | `lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart` and detail/reflection pages | multiple | `Search lessons...`, `Open full lesson`, `Reflection mode`, `Save note` | Hardcoded shell/actions | Core lesson-shell UI still English-heavy. | Focused DLL shell localization pass. | Large |
| Medium | Learning / Life | `lib/features/learn/life/presentation/life_landing_page.dart`, `life_theme_page.dart`, `life_subcategory_page.dart` | multiple | `Any theme`, `Any status`, `No lessons match...` | Hardcoded filters/empty states | Visible browse/filter text remains English. | Localize life-shell filters and empty states. | Medium |
| Medium | Learning / Quran Universe | `lib/features/learn/quran_universe/presentation/quran_universe_page.dart` | 69-80, 204-212, 684-700 | `Journey of Revelation`, `Prophet Quiz`, habit labels | Hardcoded shell/actions/helpers | This discovery surface still mixes English UI and helper labels. | Localize surface actions and move helper labels behind l10n. | Medium |
| Medium | Learning / Quran Reader | `lib/features/learn/quran/presentation/quran_reader_page.dart` | 430, 439, 525, 566, 881, 1256, 2029, 2154, 2195, 2201, 2222 | `Resume`, `Download failed: $error`, `Surah audio downloaded successfully.` | Hardcoded actions/snackbars | Widely used reader still has English snackbar/action text. | Localize reader controls and snackbar content. | Medium |
| Low | Shared helpers | `lib/shared/widgets/quran_quote_block.dart` | 34, 39 | `Qur’an` fallback label | Helper-level fallback English | Low-risk visible fallback remains English-coupled. | Localize reference block fallback output. | Small |
| Low | Shared helpers | `lib/features/worship/domain/dhikr_session.dart` | 19, 21 | `just now`, `X min` | Helper-level English duration output | Could leak into UI if reused outside already-localized paths. | Localize or isolate as internal-only. | Small |
| Low | Shared helpers | `lib/features/creation_explorer/presentation/creation_explorer_page.dart` | 1197-1200 | `Strong`, `Probable`, `Possible`, `Low` | Helper-level confidence labels | Still English in visible camera surface. | Localize confidence-band labels. | Small |
| Low | Shared helpers | `lib/features/journey/presentation/widgets/growth_ui_helpers.dart` | 10-22, 122-133, 203-217 | category labels, recurrence labels, weekday labels | Helper-level English output | Many helper labels still use English directly. | Extend localized helper coverage for categories/recurrence/weekday labels. | Medium |
| Low | Formatting | `lib/features/salah/presentation/salah_page.dart` | 458-472, 1357-1511 | `Starts in ...`, `0m`, `On time`, `Late`, madhhab/method labels | Helper-level English + locale formatting | Some visible timing/status labels remain English in Salah page. | Localize timing, place, method, and madhhab helper labels. | Medium |

## App-Locale Correctness Review

Status: `acceptable for many widget-bound surfaces, but not fully safe everywhere`

Confirmed good patterns:
- Many presentation surfaces use `Localizations.localeOf(context)` or `l10n.localeName` explicitly.
- Notifications and live activities already use app localization lookup rather than raw device strings.

Remaining risks:
- `Intl.getCurrentLocale()` is still used in shared/domain helpers in:
  - `lib/core/prayer/prayer_preferences.dart`
  - `lib/features/worship/application/prayer_tracker_controller.dart`
  - `lib/features/worship/domain/fasting_status.dart`
  - `lib/features/worship/domain/fasting_type.dart`
  - `lib/features/journey/presentation/widgets/growth_ui_helpers.dart`
- These helpers will usually follow the active locale in-app, but they are less explicit and less reliable than passing locale or `AppLocalizations` from the caller.
- Celestial formatting still uses `DateFormat.jm()` and `DateFormat.yMMMMd()` without explicit locale in multiple places, which risks device-locale behavior rather than app-locale behavior.

## Formatting / Template / Pluralization Review

Remaining issues:
- Several untouched features still use direct string interpolation instead of templates, for example:
  - `lib/features/circles/presentation/community_events_page.dart`
  - `lib/features/learn/quran_teaching/presentation/widgets/quran_teaching_review_widgets.dart`
  - `lib/features/learn/salah/presentation/salah_guided_prayer_page.dart`
- Some fallback/error text still includes raw `$error` interpolation directly in UI:
  - FAQ pages
  - some reader/snackbar surfaces
- Some durations and time labels remain English-specific in helper layers:
  - `dhikr_session.dart`
  - `salah_page.dart`
  - `celestial_services.dart`
- Some count labels still lack plural-aware templates in untouched features.

## Accessibility Localization Review

Status: `improved but incomplete`

Remaining concerns:
- Untouched older screens still have many visible icon/button labels without a corresponding final accessibility wording pass.
- Remaining hardcoded visible actions in learning/celestial screens imply likely hardcoded semantics or tooltip drift nearby.
- No new critical accessibility-localization blocker was found in the most recently fixed surfaces.

## Release Readiness

- Safe for ongoing development: `Yes`
- Safe for QA: `Yes, with tracked known gaps`
- Safe for English-only release: `Mostly yes, but several visible English-only surfaces still need cleanup if English polish matters`
- Safe for multilingual beta/release: `No`

Top must-fix items before multilingual release:
1. Resolve remaining code-side English in Celestial, Quran Teaching review/section, Learning Salah, Hadith landing, Baby Names browse, and World/Divine Life shell pages.
2. Resolve helper-level English output in shared celestial, growth, salah, and dhikr helpers.
3. Fix explicit placeholder mismatches in non-English ARB files.
4. Translate missing keys for supported release locales.

## Recommended Next Action

Recommended: `one final code micro-pass needed, then translation pass`

Reason:
- The remaining code-side issues are no longer widespread across the whole app, but there are still too many user-visible English surfaces for a clean multilingual release.
- After one more focused code cleanup pass, the dominant remaining work becomes translation coverage and multilingual QA rather than code architecture.
