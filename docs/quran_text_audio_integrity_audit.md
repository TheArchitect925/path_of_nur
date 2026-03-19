# Qur’an Text And Audio Integrity Audit

Date: 2026-03-18

## Scope

This audit reviewed the Flutter app, localization sources, tests, assets, and Apple platform code for:

- Arabic text embedded in code
- Qur’an quote and banner rendering
- Qur’an audio binding
- raw verse transport through routes or widgets
- risky text manipulation or fallback logic

## Canonical Direction

The repo now has one canonical app-side Qur’an content path:

- Text reference model: `QuranVerseRef`, `QuranQuoteRef`
- Audio reference model: `QuranAudioRef`
- Content gateway: `QuranContentRepository`
- Quote rendering: `QuranQuoteBlock` via `quranQuoteContentProvider`

Qur’an quote surfaces should only pass verse references. Arabic, transliteration, translation, and audio source resolution must come from repository-backed providers.

## Confirmed Qur’an Text Locations

These locations contain confirmed Qur’an text or Qur’an-derived content:

| Path | Symbol / Surface | Why It Matters | Recommendation |
| --- | --- | --- | --- |
| `lib/features/learn/quran/data/quran_repository.dart` | `QuranRepository` | Canonical app-side Qur’an Arabic and translation source | Keep as canonical source for Flutter quote/banner rendering |
| `lib/features/learn/quran/data/quran_transliteration_repository.dart` | `QuranTransliterationRepository` | Canonical transliteration fetch/cache path | Keep as transliteration source; continue treating it as repository-owned data only |
| `lib/features/learn/dua/data/dua_seed_data.dart` | dua seed data | Includes Qur’an-based duas and non-Qur’an duas in Arabic | Keep separate from Qur’an quote system; consider a later dua-source audit |
| `lib/features/learn/quran_teaching/data/quran_teacher_master_content.dart` | word and tajwid teaching seeds | Contains Qur’anic words and learning fragments | Manual review later to confirm each fragment is handled intentionally as teaching content, not quote/banner content |
| `ios/PathOfNurTV/Data/TVSeedRepository.swift` | tvOS seed repository | Hardcoded Qur’an Arabic lives outside the Flutter canonical repository path | High-priority manual migration target |

## Suspected Qur’an Text Requiring Manual Review

These are not necessarily wrong, but they bypass the new canonical quote flow or deserve manual verification:

| Path | Symbol / Surface | Risk | Recommendation |
| --- | --- | --- | --- |
| `lib/features/celestial/data/celestial_verse_catalog.dart` | celestial verse catalog | Stores raw Qur’an Arabic in a feature-specific catalog | Migrate to verse references plus canonical repository hydration |
| `lib/features/creation_explorer/data/creation_explorer_catalog.dart` | creation explorer catalog | Feature-level Arabic verse content may drift from canonical source ownership | Migrate to reference-based storage where feasible |
| `lib/features/learn/salah/data/wudu_content.dart` | wudu lesson content | Qur’anic verse fields appear embedded in lesson content | Review whether these should render through reference-based verse widgets |
| `lib/features/onboarding/presentation/onboarding_page.dart` | onboarding Arabic strings | Mix of non-Qur’anic Arabic and possibly Qur’an-derived devotional text in presentation code | Classify line-by-line and move any Qur’an text out of presentation |

## Non-Qur’an Arabic Text Locations

These are Arabic strings, but they are not part of the canonical Qur’an quote system:

| Path | Type | Notes |
| --- | --- | --- |
| `lib/features/learn/dua/data/dua_seed_data.dart` | dua | Preserve separately from Qur’an content ownership |
| `lib/features/worship` dhikr and dua surfaces | dhikr / dua | Separate devotional content; should not be forced into Qur’an repository |
| `assets/data/baby_names.json` | names | Non-Qur’anic Arabic metadata |
| localization files with language labels | UI labels | Expected non-Qur’anic Arabic |

## Audio Sources And Binding Logic

| Path | Symbol | Status | Recommendation |
| --- | --- | --- | --- |
| `lib/features/learn/quran/data/quran_audio_repository.dart` | `QuranAudioRepository` | Good | Keeps verse audio tied to `surahNumber`, `ayahNumber`, and `reciterId` |
| `lib/features/learn/quran/data/quran_content_repository.dart` | `resolveAudioSource(QuranAudioRef)` | Good | Use this as the canonical higher-level audio binding entry where possible |
| `lib/features/watch_companion/application/watch_quran_audio_contract.dart` | watch audio contract | Good | Already carries verse metadata and reciter identity |
| `lib/features/learn/quran/presentation/quran_reader_page.dart` | direct `resolveAyahSource(...)` calls | Acceptable but lower-level | Future cleanup can route these calls through `QuranContentRepository` for stricter ownership consistency |

## Risky Display / Manipulation Logic Found

### Fixed in this pass

| Path | Symbol / Surface | Risk | Remediation |
| --- | --- | --- | --- |
| `lib/shared/widgets/quran_quote_block.dart` | `QuranQuoteBlock` and quote pools | Hardcoded Qur’an Arabic/transliteration/translation in presentation layer | Replaced with `QuranQuoteRef`-only pools and repository-backed content loading |
| `lib/shared/content/learning_quote.dart` | `buildLearningCompactQuote` | Qur’an text came from localization strings | Replaced with canonical reference-only quote |
| `lib/shared/widgets/quran_navigation.dart` | `openQuranQuoteLocation` | Raw verse text could be passed through route query params | Now routes by verse metadata only |
| `lib/features/quran/presentation/quran_verse_page.dart` | `QuranVersePage` | Accepted raw Arabic/transliteration/translation directly | Now accepts only verse metadata |
| `lib/app/routes/core_support_routes.dart` | `/quran-verse` | Parsed raw verse text from query params | Now accepts `surah`, `ayah`, optional `ayahEnd` only |
| `lib/features/worship/presentation/worship_page.dart` | page quote | Hardcoded Qur’an Arabic in page widget | Replaced with reference |
| `lib/features/worship/presentation/worship_section_pages.dart` | section quotes | Hardcoded Qur’an Arabic in page widget | Replaced with references |
| `lib/features/salah/presentation/salah_page.dart` | `_dailySalahQuote` | Hardcoded Qur’an quote pool | Replaced with reference-only pool, including ayah range metadata |
| `lib/features/learn/prophets/presentation/prophet_detail_page.dart` | prophet header quote | Hardcoded Qur’an Arabic in presentation | Replaced with reference |
| `lib/features/learn/presentation/pages/quran_app_hub_page.dart` | daily verse open action | Rebuilt a `QuranQuote` from raw verse strings | Now passes a reference only |

### Still requiring follow-up

| Path | Symbol / Surface | Risk | Recommendation |
| --- | --- | --- | --- |
| `ios/PathOfNurTV/Data/TVSeedRepository.swift` | tvOS seed content | Raw Qur’an Arabic remains in platform seed data | Migrate to a shared canonical source or a validated reference dataset |
| `lib/features/celestial/data/celestial_verse_catalog.dart` | feature-specific quote data | Feature-owned Arabic increases drift risk | Convert to verse refs and hydrate through repository |
| `lib/features/creation_explorer/data/creation_explorer_catalog.dart` | feature-specific verse data | Same drift risk | Convert to verse refs and hydrate through repository |

## Remediation Implemented

- Added `QuranVerseRef`, `QuranQuoteRef`, `QuranAudioRef`
- Added `QuranContentRepository`
- Added `quranContentRepositoryProvider`
- Added `quranQuoteContentProvider`
- Converted shared quote surfaces to repository-backed reference rendering
- Removed raw Qur’an transport from the shared navigation and `/quran-verse` route
- Removed the localized compact learning verse text keys from source ARB
- Added integrity regression tests for presentation-layer hardcoded Arabic and raw route transport

## Unresolved Manual Review Items

1. `ios/PathOfNurTV/Data/TVSeedRepository.swift`
2. `lib/features/celestial/data/celestial_verse_catalog.dart`
3. `lib/features/creation_explorer/data/creation_explorer_catalog.dart`
4. `lib/features/onboarding/presentation/onboarding_page.dart`
5. `lib/features/learn/salah/data/wudu_content.dart`
6. `lib/features/learn/quran_teaching/data/quran_teacher_master_content.dart`

These items need content-owner review before a full “single canonical source” claim can extend beyond the migrated quote/banner system.
