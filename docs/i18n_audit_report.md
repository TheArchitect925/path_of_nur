# Path of Nūr i18n / Localization Audit

Generated from a repository-wide scan of `lib/` plus targeted manual review of the highest-risk surfaces. Counts below are filtered to actionable, likely user-visible issues rather than raw regex matches.

## 1. Executive Summary

- Total findings count: **5059** actionable localization findings in `lib/`.
- Severity counts: **critical 129 / high 3610 / medium 1320 / low 0**.
- Current l10n approach: ARB files in `lib/l10n/` with generated `AppLocalizations`. The infrastructure is sound, but feature adoption is uneven.
- Highest-priority areas: **Accounts / Sync**, **Onboarding**, **Notifications**, **Settings / Profile**, **Home**, **Learning**, and **Ocean / Community**.
- Main structural risks: literal UI copy embedded in widgets, English helper-return strings, interpolation that should use templates/plurals, and large non-English translation gaps.

### Count by Severity

- critical: **129**
- high: **3610**
- medium: **1320**
- low: **0**

### Count by Category

- Direct hardcoded UI text: **3650**
- Interpolation/template risk: **1126**
- Hardcoded text in logic/config/helpers: **283**

### Top 10 Priority Fixes

1. Accounts / Sync screens and dialogs
2. Onboarding flow copy and prompts
3. Notification titles, bodies, and channel labels
4. Settings / Profile labels, helper text, and summary copy
5. Home screen CTA labels and interpolated stat strings
6. Ocean / Community copy and source labels
7. Learn hub and legacy Learn surfaces
8. Prayer helper returns, validation strings, and manual-mode explanations
9. Locale-aware plural/relative-time/date/number formatting
10. Reusable widgets that still assume raw strings

### Locale Resource Gap

- `ar`: 1376 untranslated messages reported by `flutter gen-l10n`
- `bn`: 1376 untranslated messages reported by `flutter gen-l10n`
- `de`: 2939 untranslated messages reported by `flutter gen-l10n`
- `fa`: 1376 untranslated messages reported by `flutter gen-l10n`
- `fa_AF`: 1377 untranslated messages reported by `flutter gen-l10n`
- `ha`: 1376 untranslated messages reported by `flutter gen-l10n`
- `hi`: 1376 untranslated messages reported by `flutter gen-l10n`
- `id`: 1377 untranslated messages reported by `flutter gen-l10n`
- `ku`: 1377 untranslated messages reported by `flutter gen-l10n`
- `ms`: 1377 untranslated messages reported by `flutter gen-l10n`
- `pa`: 1377 untranslated messages reported by `flutter gen-l10n`
- `ps`: 1377 untranslated messages reported by `flutter gen-l10n`
- `tg`: 1377 untranslated messages reported by `flutter gen-l10n`
- `tr`: 1377 untranslated messages reported by `flutter gen-l10n`
- `ur`: 1377 untranslated messages reported by `flutter gen-l10n`

### Strengths

- Many newer screens already resolve strings through `AppLocalizations.of(context)`.
- The project already has locale files for multiple languages.
- The localization pipeline is centralized and generated, which is the right foundation for cleanup.

### Inconsistencies / Gaps

- Some screens mix localized parent titles with hardcoded child labels and actions.
- Reusable widgets still accept or render raw strings in a few shared flows.
- Notifications and helper methods still compose English directly in code.
- Interpolated and plural-like strings are not consistently routed through ARB templates.

### Obvious Duplicate-Meaning ARB Keys

- `babyNamesReflectionTitle, journeyRingReflection, modeGentleActionReflect, journalBodyField, journalTypeReflection, learningPathPhaseAdvancedReflectionTitle` share the same English value: `Reflection`
- `learningJourneyStageReadingBasicsCheckpointSection2Title, learningJourneySalahCompletionSection2Title, learningJourneyWuduCompletionSection2Title, learningJourneyFatihahCompletionSection2Title, learningJourneyReciteCompletionSection2Title, learningJourneyIslamCompletionSection2Title` share the same English value: `What to do next`
- `learningJourneyHomeContinueBadge, learningJourneyHomeContinueAction, learningJourneyCardActionContinue, learningJourneyIslandActionContinue, learningJourneyDetailActionContinue` share the same English value: `Continue`
- `learningJourneyTriviaReviewSection2Title, learningJourneyAlphabetCompletionSection2Title, learningJourneyReadingCompletionSection2Title, learningJourneyFaithCompletionSection2Title, learningJourneyStoriesCompletionSection2Title` share the same English value: `Where to go next`
- `homeFastingCompleted, learningJourneyLessonActionCompleted, learningJourneyHomeCompletedBadge, learningJourneyPlaceholderActionCompleted` share the same English value: `Completed`
- `learningJourneyReadingKasrahSection2Title, learningJourneyReadingDammahSection2Title, learningJourneyReadingSukunSection2Title, learningJourneyReadingShaddahSection2Title` share the same English value: `Practice suggestion`
- `quranTitle, learnTabQuran, journeyRingQuran, modeRamadanActionQuran` share the same English value: `Quran`
- `quranCancel, learningPathSwitchCancel, familyLearningCancelAction` share the same English value: `Cancel`
- `learnLifeCharacter, learnTrackCharacter, learningPathPhasePracticingCharacterTitle` share the same English value: `Character`
- `learnContentContinueTitle, lifeContinueLearningTitle, worldContinueLearningTitle` share the same English value: `Continue learning`
- `learnQuranDailyVerseTitle, learningJourneyTodayLightBadgeVerse, learningJourneyTodayLightVerseTitleFallback` share the same English value: `Daily Verse`
- `learnLifeGratitude, journalTypeGratitude, learningJourneyCharacterShukrStageTitle` share the same English value: `Gratitude`

## 2. Findings by Feature Area

### Learning

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:16`
  - Code snippet: `subtitle: 'Compassion, trust, and shared purpose.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:40`
  - Code snippet: `subtitle: 'Respect, gratitude, and service.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:53`
  - Code snippet: `subtitle: 'Trust, teaching, and gentle guidance.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:70`
  - Code snippet: `subtitle: 'Provision with responsibility.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:86`
  - Code snippet: `subtitle: 'Steadiness through ease and trial.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:103`
  - Code snippet: `subtitle: 'Fairness with integrity.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:117`
  - Code snippet: `subtitle: 'Adab, sincerity, and restraint.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:134`
  - Code snippet: `subtitle: 'Seeing blessings with awareness.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:146`
  - Code snippet: `title: 'Companion App Disclaimer',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:147`
  - Code snippet: `subtitle: 'A helpful guide, not a replacement for mosque and scholars.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:159`
  - Code snippet: `RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:160`
  - Code snippet: `RelatedTopic(topicId: 'revert-support-growth', title: 'Revert Support'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:167`
  - Code snippet: `title: 'New Muslim Path',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:168`
  - Code snippet: `subtitle: 'Foundational steps for someone entering Islam.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:182`
  - Code snippet: `title: 'Salah Learning Track',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:184`
  - Code snippet: `RelatedTopic(topicId: 'revert-support-growth', title: 'Revert Support'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:191`
  - Code snippet: `title: 'Revert Muslim Support',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:192`
  - Code snippet: `subtitle: 'Gentle growth, forgiveness, and supportive routines.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:204`
  - Code snippet: `RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning
  - File path: `lib/features/learn/content/data/learn_content_data.dart:207`
  - Code snippet: `title: 'Salah Learning Track',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **3183**

### Features

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:287`
  - Code snippet: `return 'Dawn is unfolding';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:289`
  - Code snippet: `return 'Dusk is settling';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:596`
  - Code snippet: `if (age < 1.5) return 'New moon';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:597`
  - Code snippet: `if (age < 6.5) return 'Waxing crescent';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:598`
  - Code snippet: `if (age < 8.5) return 'First quarter';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:599`
  - Code snippet: `if (age < 13.5) return 'Waxing gibbous';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:600`
  - Code snippet: `if (age < 16.5) return 'Full moon';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:601`
  - Code snippet: `if (age < 21.5) return 'Waning gibbous';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:602`
  - Code snippet: `if (age < 23.5) return 'Last quarter';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:603`
  - Code snippet: `if (age < 28.5) return 'Waning crescent';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Features
  - File path: `lib/features/celestial/application/celestial_services.dart:604`
  - Code snippet: `return 'New moon';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/celestial_explorer_page.dart:265`
  - Code snippet: `const SnackBar(content: Text('Sky reflection saved.')),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/celestial_explorer_page.dart:270`
  - Code snippet: `label: const Text('Save reflection'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/celestial_explorer_page.dart:292`
  - Code snippet: `hintText: 'What did the sky make you notice today?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:199`
  - Code snippet: `label: 'Moon phase',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:207`
  - Code snippet: `label: 'Next event',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:354`
  - Code snippet: `child: const Text('Choose city'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:358`
  - Code snippet: `child: const Text('Enable location'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:558`
  - Code snippet: `label: const Text('Choose location'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Features
  - File path: `lib/features/circles/application/circles_provider.dart:386`
  - Code snippet: `title: 'Hiking Circle',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **716**

### Learning Journey

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:101`
  - Code snippet: `title: 'Early Life of the Prophet ﷺ',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:106`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:111`
  - Code snippet: `title: 'Why this stage matters',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:129`
  - Code snippet: `title: 'First Revelation',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:134`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:139`
  - Code snippet: `title: 'What changed',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:157`
  - Code snippet: `title: 'Makkah Period',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:162`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:167`
  - Code snippet: `title: 'What was being built',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:189`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:194`
  - Code snippet: `title: 'A lesson in tawakkul',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:211`
  - Code snippet: `title: 'Madinah Society',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:216`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:221`
  - Code snippet: `title: 'What was established',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:238`
  - Code snippet: `title: 'Leadership & Character',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:243`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:248`
  - Code snippet: `title: 'What makes this leadership prophetic',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:265`
  - Code snippet: `title: 'Final Sermon',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:270`
  - Code snippet: `title: 'Short narrative',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Learning Journey
  - File path: `lib/features/learn/journey/data/learning_journey_lesson_content.dart:275`
  - Code snippet: `title: 'A closing frame for the journey',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **449**

### Worship

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/application/prayer_tracker_controller.dart:275`
  - Code snippet: `if (total <= 0) return 'Queue clear. Maintain on-time prayers.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/application/prayer_tracker_controller.dart:277`
  - Code snippet: `return 'Light cadence: 1 extra qada after Fajr or Isha.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/application/prayer_tracker_controller.dart:280`
  - Code snippet: `return 'Steady cadence: 2 qada daily (one after Fajr, one after Isha).';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/application/prayer_tracker_controller.dart:282`
  - Code snippet: `return 'Focused cadence: 3 qada daily in small blocks with consistency.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/application/worship_tab_provider.dart:20`
  - Code snippet: `return 'Khusū';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Worship
  - File path: `lib/features/worship/domain/dhikr_preset.dart:33`
  - Code snippet: `label: 'Allahu Akbar',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Worship
  - File path: `lib/features/worship/domain/dhikr_preset.dart:47`
  - Code snippet: `label: 'La ilaha illAllah',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/dhikr_session.dart:19`
  - Code snippet: `return 'just now';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_status.dart:12`
  - Code snippet: `return 'Not fasting';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_status.dart:14`
  - Code snippet: `return 'Intending to fast';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_status.dart:18`
  - Code snippet: `return 'Missed / Broken';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_type.dart:13`
  - Code snippet: `return 'Ramadan fast';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_type.dart:15`
  - Code snippet: `return 'Sunnah fast';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_type.dart:17`
  - Code snippet: `return 'Make-up fast (Qada)';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_type.dart:19`
  - Code snippet: `return 'Voluntary fast';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/fasting_type.dart:21`
  - Code snippet: `return 'Other / custom';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/prayer_name.dart:31`
  - Code snippet: `return 'الفجر';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/prayer_name.dart:33`
  - Code snippet: `return 'الظهر';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/prayer_name.dart:35`
  - Code snippet: `return 'العصر';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Worship
  - File path: `lib/features/worship/domain/prayer_name.dart:37`
  - Code snippet: `return 'المغرب';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **144**

### Accounts / Sync

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:20`
  - Code snippet: `title: 'Accounts, Profiles & Sync',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:25`
  - Code snippet: `title: 'Current Profile',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:26`
  - Code snippet: `subtitle: 'See who is active right now and how this profile is protected.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:46`
  - Code snippet: `title: 'Switch Profile',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:47`
  - Code snippet: `subtitle: 'Move between profiles without leaking progress.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:52`
  - Code snippet: `title: 'Profiles in This Account',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:63`
  - Code snippet: `title: 'Accounts on This Device',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:64`
  - Code snippet: `subtitle: 'Keep multiple signed-in identities separate on one phone or tablet.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:70`
  - Code snippet: `title: 'Signed-In Accounts on This Device',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:79`
  - Code snippet: `title: 'Sync Status',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:80`
  - Code snippet: `subtitle: 'Understand what is stored locally, what is synced, and what needs attention.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:85`
  - Code snippet: `title: 'Connected Devices',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:86`
  - Code snippet: `subtitle: 'See which phones, tablets, watches, and TVs are linked to this journey.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:90`
  - Code snippet: `title: 'Connected Devices',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:97`
  - Code snippet: `title: 'Backup & Restore',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:106`
  - Code snippet: `title: 'Backup & Restore',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:117`
  - Code snippet: `title: 'Shared Device Safety',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:118`
  - Code snippet: `subtitle: 'Require profile picking on launch and keep child or adult profiles protected.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:124`
  - Code snippet: `title: 'Shared Device Safety',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Accounts / Sync
  - File path: `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:133`
  - Code snippet: `title: const Text('Shared Device Mode'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **114**

### Ocean / Community

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:231`
  - Code snippet: `title: 'Great Lake',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:238`
  - Code snippet: `title: 'Inland Sea',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:245`
  - Code snippet: `title: 'Great Waters',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:252`
  - Code snippet: `title: 'Ocean of Creation',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:298`
  - Code snippet: `title: 'Quiet Lake',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:304`
  - Code snippet: `title: 'Flowing Water',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:530`
  - Code snippet: `if (percentage <= 0) return '0%';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:531`
  - Code snippet: `return '<1%';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/application/community_ocean.dart:538`
  - Code snippet: `if (total <= BigInt.zero || contribution <= BigInt.zero) return '0%';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:33`
  - Code snippet: `title: 'Community Ocean',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:160`
  - Code snippet: `label: 'Community stage',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:165`
  - Code snippet: `label: 'Your water path',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:170`
  - Code snippet: `label: 'Drops today',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:175`
  - Code snippet: `label: 'Community total',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:281`
  - Code snippet: `label: 'Current stage',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:287`
  - Code snippet: `label: 'Total community drops',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:292`
  - Code snippet: `label: 'Next stage',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:382`
  - Code snippet: `_StatCard(label: 'Of community', value: contributionPercent),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:383`
  - Code snippet: `_StatCard(label: 'Toward next stage', value: towardNext),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Ocean / Community
  - File path: `lib/features/ocean/presentation/ocean_drops_page.dart:519`
  - Code snippet: `label: 'Your drops',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **58**

### Home

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Home
  - File path: `lib/features/home/data/home_verses.dart:25`
  - Code snippet: `return 'Qur’an home collection';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:240`
  - Code snippet: `label: const Text('Start Welcome Carousel'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1182`
  - Code snippet: `title: 'Qibla Finder',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1183`
  - Code snippet: `subtitle: 'Compass guidance toward the Kaaba',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1226`
  - Code snippet: `title: 'Quran Top Words',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1227`
  - Code snippet: `subtitle: 'Learn frequent Quran words from your source document.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1237`
  - Code snippet: `title: '99 Names of الله',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1238`
  - Code snippet: `subtitle: 'Arabic names, transliteration, and concise meanings.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1249`
  - Code snippet: `title: 'Islamic Guidance Hub',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1250`
  - Code snippet: `subtitle: 'Hajj, Umrah, New/Revert Muslim support and practice guides.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1263`
  - Code snippet: `title: 'Quran 50 Lessons Mapping',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1264`
  - Code snippet: `subtitle: 'Source-to-category mapping from the lessons PDF.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1292`
  - Code snippet: `title: '50 Important Ahadith',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:1293`
  - Code snippet: `subtitle: 'Core hadith collection from your uploaded learning source.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:2067`
  - Code snippet: `label: 'Prayer not allowed now • Sunrise',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:2081`
  - Code snippet: `label: 'Prayer not allowed now • Zenith',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:2095`
  - Code snippet: `label: 'Prayer not allowed now • Sunset',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:3213`
  - Code snippet: `label: 'Prophets Quiz',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:3222`
  - Code snippet: `label: 'Islamic Trivia',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Home
  - File path: `lib/features/home/presentation/home_page.dart:3227`
  - Code snippet: `label: 'Knowledge Paths',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **54**

### Notifications

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:221`
  - Code snippet: `subtitle: 'Path of Nur',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:311`
  - Code snippet: `subtitle: 'Path of Nur',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:332`
  - Code snippet: `return 'Dhikr reminder';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:336`
  - Code snippet: `return 'Daily reflection';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:338`
  - Code snippet: `return 'Fasting reminder';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:340`
  - Code snippet: `return 'Cycle check-in';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:351`
  - Code snippet: `return 'Take a calm moment for dhikr.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:355`
  - Code snippet: `return 'Capture a brief reflection before your day ends.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:357`
  - Code snippet: `return 'Prepare your intention for fasting today.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:359`
  - Code snippet: `return 'Review your status and resume prayer reminders when ready.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/local_notification_service.dart:428`
  - Code snippet: `subtitle: 'Path of Nur',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:130`
  - Code snippet: `title: 'Makkah Default',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:131`
  - Code snippet: `subtitle: 'Clear, balanced, and suitable for the daily prayers.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:141`
  - Code snippet: `title: 'Madinah Soft',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:142`
  - Code snippet: `subtitle: 'A softer bundled option for a calmer reminder tone.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:152`
  - Code snippet: `title: 'Clear Masjid',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:153`
  - Code snippet: `subtitle: 'Focused and direct for prayer-time playback.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:166`
  - Code snippet: `title: 'Fajr Default',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:167`
  - Code snippet: `subtitle: 'Temporary bundled fallback for Fajr-specific routing.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Notifications
  - File path: `lib/core/reminders/adhan_options.dart:177`
  - Code snippet: `title: 'Fajr Soft',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **32**

### Onboarding

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:412`
  - Code snippet: `title: 'Choose your language',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:413`
  - Code snippet: `subtitle: 'Select the language you would like to use in the app.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:444`
  - Code snippet: `title: 'Which age range are you in?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:462`
  - Code snippet: `title: 'Which description fits your journey with Islam best?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:497`
  - Code snippet: `title: 'How consistent is your Salah currently?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:498`
  - Code snippet: `subtitle: 'Choose the option that best reflects where you are right now.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:513`
  - Code snippet: `title: 'Prayer time calculation method',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:534`
  - Code snippet: `title: 'Which Madhab do you follow?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:550`
  - Code snippet: `title: 'What would you like to grow in?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:580`
  - Code snippet: `title: 'How would you like to read Arabic?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:581`
  - Code snippet: `subtitle: 'Choose the reading style that feels most comfortable for you.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:667`
  - Code snippet: `title: 'How would you like to be reminded?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:681`
  - Code snippet: `tooltip: 'Reminder help',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:725`
  - Code snippet: `title: const Text('Daily lesson reminder'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:735`
  - Code snippet: `title: 'What would you like to track?',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:760`
  - Code snippet: `title: 'Grow together with family',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:767`
  - Code snippet: `title: 'Family profiles',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:774`
  - Code snippet: `title: 'Private journeys for each member',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:775`
  - Code snippet: `subtitle: 'Each profile can keep separate progress and reminders.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **critical**
  - Category: Direct hardcoded UI text
  - Feature area: Onboarding
  - File path: `lib/features/onboarding/presentation/onboarding_page.dart:780`
  - Code snippet: `title: 'Age-appropriate learning',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **25**

### Settings / Profile

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:15`
  - Code snippet: `title: 'Coming soon',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:16`
  - Code snippet: `subtitle: 'A calm look at the next improvements planned for Path of Nūr.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:19`
  - Code snippet: `title: 'On the roadmap',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:20`
  - Code snippet: `subtitle: 'These are the next areas being shaped for future updates.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:24`
  - Code snippet: `title: 'Deeper Qur’anic Arabic guidance',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:31`
  - Code snippet: `title: 'Broader trivia journeys',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:38`
  - Code snippet: `title: 'Refined prayer widgets',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_coming_soon_page.dart:45`
  - Code snippet: `title: 'Gentler personalization',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_whats_new_page.dart:19`
  - Code snippet: `title: 'What’s new',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_whats_new_page.dart:20`
  - Code snippet: `subtitle: 'Recent changes to Path of Nūr, with the latest updates first.',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_whats_new_page.dart:127`
  - Code snippet: `title: 'Refined onboarding, motion, and prayer widgets',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_whats_new_page.dart:141`
  - Code snippet: `title: 'Trusted-source Qur’anic Arabic improvements',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_whats_new_page.dart:153`
  - Code snippet: `title: 'Islamic Trivia and Knowledge Paths',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/profile_whats_new_page.dart:165`
  - Code snippet: `title: 'Smarter Qur’anic Arabic practice',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Interpolation/template risk
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/settings_page.dart:75`
  - Code snippet: `'${_addressFromSex(userProfile.sex, l10n)} ${userProfile.name}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Interpolation/template risk
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/settings_page.dart:78`
  - Code snippet: `'${l10n.levelLabel} ${profileSummary.level} • ${profileSummary.currentStreakDays} ${l10n.homeDaysLabel}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Interpolation/template risk
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/settings_page.dart:453`
  - Code snippet: `: '${(prayerState.adhanSettings.volume * 100).round()}%',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Interpolation/template risk
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/settings_page.dart:1823`
  - Code snippet: `: '${adjustmentMinutes > 0 ? '+' : ''}$adjustmentMinutes min';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Interpolation/template risk
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/settings_page.dart:1823`
  - Code snippet: `: '${adjustmentMinutes > 0 ? '+' : ''}$adjustmentMinutes min';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Interpolation/template risk
  - Feature area: Settings / Profile
  - File path: `lib/features/profile/presentation/settings_page.dart:1961`
  - Code snippet: `'${_prayerDisplayName(prayerId, l10n)}: ${_formatAdjustmentLabel(currentAdjustments.offsetForPrayer(prayerId), l10n)} → ${_formatAdjustmentLabel(suggestedAdjustments.offsetForPrayer(prayerId), l10n)}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **23**

### Prayer Core

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:370`
  - Code snippet: `return 'It becomes qada at sunrise. If you missed it, avoid the sunrise-forbidden period and make it up shortly after.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:372`
  - Code snippet: `return 'If missed, it becomes qada when Asr begins. Make it up as soon as reasonably possible.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:374`
  - Code snippet: `return 'If missed, it becomes qada at Maghrib. Avoid praying during the sunset-forbidden period itself.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:376`
  - Code snippet: `return 'If missed, it becomes qada when Isha begins. Make it up as soon as reasonably possible.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:378`
  - Code snippet: `return 'If missed, this app marks it qada at Fajr. Many scholars also treat delaying it deep into the night as blameworthy, so offer it earlier when you can.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:380`
  - Code snippet: `return 'Make up missed obligatory prayers as soon as possible, while avoiding prohibited times.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:451`
  - Code snippet: `label: 'Toronto, Canada',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:456`
  - Code snippet: `label: 'Dubai, UAE',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:461`
  - Code snippet: `label: 'London, UK',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:466`
  - Code snippet: `label: 'Istanbul, Turkey',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:471`
  - Code snippet: `label: 'Riyadh, Saudi Arabia',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:681`
  - Code snippet: `return 'Unknown prayer adjustment.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:1571`
  - Code snippet: `return 'Enter all five daily salah times to use manual mode.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_preferences.dart:1602`
  - Code snippet: `return 'Fajr must remain before sunrise.';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_location_search_service.dart:102`
  - Code snippet: `'lat': '$latitude',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_location_search_service.dart:103`
  - Code snippet: `'lon': '$longitude',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_location_search_service.dart:131`
  - Code snippet: `final lat = double.tryParse('${item['lat'] ?? ''}');`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_location_search_service.dart:132`
  - Code snippet: `final lon = double.tryParse('${item['lon'] ?? ''}');`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_location_search_service.dart:153`
  - Code snippet: `'Location search failed with ${response.statusCode}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Prayer Core
  - File path: `lib/core/prayer/prayer_location_search_service.dart:175`
  - Code snippet: `'Reverse geocoding failed with ${response.statusCode}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Additional findings in this feature area not expanded inline: **5**

### Watch Companion

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_quran_audio_contract.dart:111`
  - Code snippet: `: (surahMap[surahId]?.transliteratedName ?? 'Surah $surahId');`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_quran_audio_contract.dart:116`
  - Code snippet: `: 'quran:${session.surahNumber}:${audioSettings.reciterId}:${session.updatedAtIso}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_quran_audio_contract.dart:171`
  - Code snippet: `recentPlayableItems: downloaded.map((id) => 'Surah $id').toList(),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_contract.dart:522`
  - Code snippet: `snapshotId: 'watch_snapshot_${todayKey}_${now.microsecondsSinceEpoch}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_contract.dart:586`
  - Code snippet: `sessionId: 'phone-active-${LocalStore.todayKey(now)}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_contract.dart:711`
  - Code snippet: `metadata: <String, dynamic>{'timestamp': '${logicalDate}T12:00:00'},`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_contract.dart:820`
  - Code snippet: `if (DateTime.tryParse('${action.logicalDate}T00:00:00') == null) {`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_contract.dart:824`
  - Code snippet: `final targetKey = '${action.logicalDate}|$prayerId';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_contract.dart:1248`
  - Code snippet: `snapshotId: 'watch_snapshot_fallback_${now.microsecondsSinceEpoch}',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_diagnostics.dart:7`
  - Code snippet: `.map((entry) => '${entry.key}=${entry.value}')`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_validation.dart:47`
  - Code snippet: `WatchValidationIssue('Unknown prayerId ${prayer.prayerId}'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_validation.dart:52`
  - Code snippet: `WatchValidationIssue('Duplicate prayerId ${prayer.prayerId}'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_validation.dart:57`
  - Code snippet: `WatchValidationIssue('displayName missing for ${prayer.prayerId}'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_validation.dart:62`
  - Code snippet: `WatchValidationIssue('Invalid prayer status for ${prayer.prayerId}'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Watch Companion
  - File path: `lib/features/watch_companion/application/watch_sync_validation.dart:97`
  - Code snippet: `if (DateTime.tryParse('${action.logicalDate}T00:00:00') == null) {`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

### Shared Widgets

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/prayer_location_picker_sheet.dart:176`
  - Code snippet: `hintText: 'Search for a city or place',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_quote_block.dart:39`
  - Code snippet: `return 'Qur’an';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **high**
  - Category: Direct hardcoded UI text
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:142`
  - Code snippet: `label: const Text('Open in Quran reader'),`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: replace the literal with an `AppLocalizations` key and pass localized strings through child widgets.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_quote_block.dart:34`
  - Code snippet: `return '$surahName $safeSurah:$verse';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_quote_block.dart:34`
  - Code snippet: `return '$surahName $safeSurah:$verse';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:73`
  - Code snippet: `? '$safeSurah:$boundedStart'`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:74`
  - Code snippet: `: '$safeSurah:$boundedStart-$boundedEnd';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:81`
  - Code snippet: `title ?? 'Quran $refLabel',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:126`
  - Code snippet: `'${surahName ?? 'Surah'} • $refLabel',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:126`
  - Code snippet: `'${surahName ?? 'Surah'} • $refLabel',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:136`
  - Code snippet: `'ayah': '$boundedStart',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared Widgets
  - File path: `lib/shared/widgets/quran_reference_block.dart:137`
  - Code snippet: `'endAyah': '$boundedEnd',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

### Shared

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared
  - File path: `lib/shared/application/app_summary_providers.dart:348`
  - Code snippet: `final day = DateTime.tryParse('${entry.key}T00:00:00');`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Shared
  - File path: `lib/shared/application/special_mode_provider.dart:71`
  - Code snippet: `return '$y-$m-$d';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared
  - File path: `lib/shared/application/special_mode_provider.dart:71`
  - Code snippet: `return '$y-$m-$d';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Hardcoded text in logic/config/helpers
  - Feature area: Shared
  - File path: `lib/shared/persistence/local_store.dart:25`
  - Code snippet: `return '$y-$m-$d';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: refactor the helper to accept `AppLocalizations` or return a stable enum/value that the UI localizes.
  - Estimated effort: small
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Shared
  - File path: `lib/shared/persistence/local_store.dart:25`
  - Code snippet: `return '$y-$m-$d';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

### App Shell / Navigation

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: App Shell / Navigation
  - File path: `lib/app/app.dart:52`
  - Code snippet: `'app-$scopeVersion-$localeTag',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: App Shell / Navigation
  - File path: `lib/app/app_router.dart:1137`
  - Code snippet: `if (id.isNotEmpty) return '/journey/habit/$id';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: App Shell / Navigation
  - File path: `lib/app/app_router.dart:1150`
  - Code snippet: `if (id.isNotEmpty) return '/journey/habit/$id';`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

### Main.Dart

- Severity: **medium**
  - Category: Interpolation/template risk
  - Feature area: Main.Dart
  - File path: `lib/main.dart:22`
  - Code snippet: `'${documentsDirectory.path}/path_of_nur.sqlite3',`
  - Why it is a problem: this is visible or likely visible user-facing text that bypasses the ARB pipeline and will stay English in localized builds.
  - Recommended fix approach: convert to an ARB template/plural/select message and use locale-aware formatting helpers.
  - Estimated effort: medium
  - Dependency notes: may require new ARB keys; some cases also require reusable widget API cleanup.

## 3. Findings by Fix Type

### Direct hardcoded UI text (3650)

- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:20` — `Accounts, Profiles & Sync`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:25` — `Current Profile`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:26` — `See who is active right now and how this profile is protected.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:46` — `Switch Profile`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:47` — `Move between profiles without leaking progress.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:52` — `Profiles in This Account`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:63` — `Accounts on This Device`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:64` — `Keep multiple signed-in identities separate on one phone or tablet.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:70` — `Signed-In Accounts on This Device`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:79` — `Sync Status`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:80` — `Understand what is stored locally, what is synced, and what needs attention.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:85` — `Connected Devices`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:86` — `See which phones, tablets, watches, and TVs are linked to this journey.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:90` — `Connected Devices`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:97` — `Backup & Restore`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:106` — `Backup & Restore`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:117` — `Shared Device Safety`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:118` — `Require profile picking on launch and keep child or adult profiles protected.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:124` — `Shared Device Safety`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:133` — `Shared Device Mode`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:134` — `Show the profile picker on shared tablets and TVs.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:172` — `Choose a Profile`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:222` — `Add Profile`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:223` — `Create an adult, youth, child, or guest profile.`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:228` — `Sign In Another Account`
- ... and **3625** more similar findings

### Interpolation/template risk (1126)

- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:38` — `'${activeProfile.profileType.name} • ${activeProfile.syncMode.name}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:55` — `'Manage the profiles stored under ${activeAccount.displayName}.'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:71` — `'${state.accounts.length} account${state.accounts.length == 1 ? '`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:91` — `'${state.connectedDevices.length} device${state.connectedDevices.length == 1 ? '`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:185` — `'${profile.profileType.name} • ${profile.syncMode.name} • Last active ${_formatWhen(profile.lastActiveAtIso)}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:346` — `'${profile.profileType.name} • ${profile.syncMode.name} • Last active ${_formatWhen(profile.lastActiveAtIso)}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:362` — `'${profile.displayName} is now active.'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:509` — `'${_titleFromEnum(account.provider.name)} • ${account.identifier} • ${account.syncMode.name}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:691` — `'${_titleFromEnum(device.platform.name)} • Last active ${_formatWhen(device.lastActiveAtIso)}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:922` — `'${_syncModeLabel(sync.syncMode)} • ${sync.transportLabel}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:943` — `'${sync.pendingChangesCount} pending changes'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:980` — `'• $event'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1012` — `'${_syncModeLabel(sync.syncMode)} • ${sync.transportLabel}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1035` — `'${sync.pendingChangesCount} change${sync.pendingChangesCount == 1 ? '`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1042` — `'${sync.transportLabel} • ${sync.transportAvailable ? '`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1096` — `' ${match.group(1)}'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1127` — `'${diff.inMinutes}m ago'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1128` — `'${diff.inHours}h ago'`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1129` — `'${diff.inDays}d ago'`
- `lib/core/reminders/local_notification_service.dart:153` — `'growth.${item.id}'`
- `lib/core/reminders/local_notification_service.dart:181` — `'.$habitId.'`
- `lib/core/reminders/local_notification_service.dart:197` — `'fasting.moment.$id'`
- `lib/core/reminders/local_notification_service.dart:254` — `'prayer_reminders_adhan_${resolvedAdhan.id}'`
- `lib/core/reminders/local_notification_service.dart:255` — `'Prayer Reminders (${resolvedAdhan.title})'`
- `lib/core/reminders/local_notification_service.dart:328` — `'${_prayerName(item.prayerId)} prayer'`
- ... and **1101** more similar findings

### Hardcoded text in logic/config/helpers (283)

- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1122` — `Not yet`
- `lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart:1126` — `Just now`
- `lib/core/reminders/local_notification_service.dart:332` — `Dhikr reminder`
- `lib/core/reminders/local_notification_service.dart:336` — `Daily reflection`
- `lib/core/reminders/local_notification_service.dart:338` — `Fasting reminder`
- `lib/core/reminders/local_notification_service.dart:340` — `Cycle check-in`
- `lib/core/reminders/local_notification_service.dart:351` — `Take a calm moment for dhikr.`
- `lib/core/reminders/local_notification_service.dart:355` — `Capture a brief reflection before your day ends.`
- `lib/core/reminders/local_notification_service.dart:357` — `Prepare your intention for fasting today.`
- `lib/core/reminders/local_notification_service.dart:359` — `Review your status and resume prayer reminders when ready.`
- `lib/features/onboarding/presentation/onboarding_page.dart:1096` — `Extra large`
- `lib/features/onboarding/presentation/onboarding_page.dart:1249` — `بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ`
- `lib/features/onboarding/presentation/onboarding_page.dart:1251` — `بسمِ اللهِ الرحمنِ الرحيم`
- `lib/features/onboarding/presentation/onboarding_page.dart:1253` — `بسم الله الرحمن الرحيم`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1454` — `This iPhone`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1456` — `This iPad`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1458` — `Apple Watch`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1460` — `This Apple Device`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1462` — `This Android Phone`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1464` — `This Android Tablet`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1466` — `Wear OS Watch`
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1468` — `Android TV`
- `lib/features/accounts_sync/application/sync_foundation.dart:993` — `Apple Device`
- `lib/features/accounts_sync/application/sync_foundation.dart:995` — `Android Device`
- `lib/features/accounts_sync/application/sync_foundation.dart:999` — `Windows PC`
- ... and **258** more similar findings

## 4. Quick Wins

- `lib/core/reminders/local_notification_service.dart:221` — Path of Nur (Notifications)
- `lib/core/reminders/local_notification_service.dart:311` — Path of Nur (Notifications)
- `lib/core/reminders/local_notification_service.dart:332` — Dhikr reminder (Notifications)
- `lib/core/reminders/local_notification_service.dart:336` — Daily reflection (Notifications)
- `lib/core/reminders/local_notification_service.dart:338` — Fasting reminder (Notifications)
- `lib/core/reminders/local_notification_service.dart:340` — Cycle check-in (Notifications)
- `lib/core/reminders/local_notification_service.dart:351` — Take a calm moment for dhikr. (Notifications)
- `lib/core/reminders/local_notification_service.dart:355` — Capture a brief reflection before your day ends. (Notifications)
- `lib/core/reminders/local_notification_service.dart:357` — Prepare your intention for fasting today. (Notifications)
- `lib/core/reminders/local_notification_service.dart:359` — Review your status and resume prayer reminders when ready. (Notifications)
- `lib/core/reminders/local_notification_service.dart:428` — Path of Nur (Notifications)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1454` — This iPhone (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1456` — This iPad (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1458` — Apple Watch (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1460` — This Apple Device (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1462` — This Android Phone (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1464` — This Android Tablet (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1466` — Wear OS Watch (Accounts / Sync)
- `lib/features/accounts_sync/application/accounts_sync_controller.dart:1468` — Android TV (Accounts / Sync)
- `lib/features/accounts_sync/application/sync_foundation.dart:993` — Apple Device (Accounts / Sync)
- `lib/features/accounts_sync/application/sync_foundation.dart:995` — Android Device (Accounts / Sync)
- `lib/features/accounts_sync/application/sync_foundation.dart:999` — Windows PC (Accounts / Sync)
- `lib/features/accounts_sync/application/sync_foundation.dart:1001` — Linux Device (Accounts / Sync)
- `lib/features/accounts_sync/application/sync_foundation.dart:1003` — Path of Nur Device (Accounts / Sync)
- `lib/features/celestial/application/celestial_services.dart:287` — Dawn is unfolding (Features)
- `lib/features/celestial/application/celestial_services.dart:289` — Dusk is settling (Features)
- `lib/features/celestial/application/celestial_services.dart:596` — New moon (Features)
- `lib/features/celestial/application/celestial_services.dart:597` — Waxing crescent (Features)
- `lib/features/celestial/application/celestial_services.dart:598` — First quarter (Features)
- `lib/features/celestial/application/celestial_services.dart:599` — Waxing gibbous (Features)
- `lib/features/celestial/application/celestial_services.dart:600` — Full moon (Features)
- `lib/features/celestial/application/celestial_services.dart:601` — Waning gibbous (Features)
- `lib/features/celestial/application/celestial_services.dart:602` — Last quarter (Features)
- `lib/features/celestial/application/celestial_services.dart:603` — Waning crescent (Features)
- `lib/features/celestial/application/celestial_services.dart:604` — New moon (Features)
- `lib/features/celestial/presentation/celestial_explorer_page.dart:265` — Sky reflection saved. (Features)
- `lib/features/celestial/presentation/celestial_explorer_page.dart:270` — Save reflection (Features)
- `lib/features/celestial/presentation/celestial_explorer_page.dart:292` — What did the sky make you notice today? (Features)
- `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:199` — Moon phase (Features)
- `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart:207` — Next event (Features)

## 5. Structural Refactors

- Create locale-aware formatting helpers for relative time, plural counts, date labels, and compact numeric summaries.
- Refactor helper methods and enum/switch label mappers that currently return English display strings.
- Move notification title/body/channel composition behind a localization-aware builder.
- Normalize reusable widget APIs so raw strings are not the default contract for visible labels, titles, and actions.
- Consolidate duplicate-meaning ARB keys and remove stale keys after feature sweeps.
- Add an automated hardcoded-string scan for presentation-layer widgets as a CI guardrail.

## 6. Proposed Execution Plan

### Phase 1: safest quick wins

- Sweep direct `Text("...")`, button labels, section headers, dialogs, and snackbars in high-traffic presentation widgets.
- Fix Accounts / Sync, Onboarding, Home, Learn, and Ocean first.
- Localize shared widgets such as location pickers, Quran action blocks, and reusable cards.

### Phase 2: medium-complexity feature sweeps

- Localize Settings / Profile and prayer-related configuration flows.
- Localize notification content and reminder channel labels.
- Localize learning/family/kids/community surfaces end to end.

### Phase 3: architecture/refactor items

- Introduce template/plural/relative-time formatting helpers.
- Refactor helper-return APIs and enum label mappers.
- Normalize shared widget contracts around localized inputs.

### Phase 4: final QA/regression sweep

- Run the hardcoded-string scan again and compare counts.
- Run `flutter gen-l10n` and reduce untranslated counts.
- Manually verify RTL, long-string overflow, semantics labels, and notifications in at least one non-English locale.

## 7. Mega Prompt Batches

- Batch 1: navigation + app shell + Home
- Batch 2: settings + profile + accounts sync
- Batch 3: prayer flows + notifications + location/time formatting
- Batch 4: dhikr + worship + fasting surfaces
- Batch 5: learning + kids mode + family/shared learning
- Batch 6: ocean/community + streak/xp/rings/rewards
- Batch 7: dialogs/errors/forms + shared widgets
- Batch 8: semantics/accessibility + template/pluralization cleanup + ARB consolidation

## Appendix A. Top Feature Areas by Finding Count

- Learning: **3203**
- Features: **736**
- Learning Journey: **469**
- Worship: **164**
- Accounts / Sync: **134**
- Ocean / Community: **78**
- Home: **74**
- Notifications: **52**
- Onboarding: **45**
- Settings / Profile: **43**
- Prayer Core: **25**
- Watch Companion: **15**
- Shared Widgets: **12**
- Shared: **5**
- App Shell / Navigation: **3**
- Main.Dart: **1**

## Appendix B. Notes on Scope and Confidence

- This report intentionally excludes clearly internal-only identifiers such as most storage keys, route names, import strings, and asset paths.
- Counts are filtered for likely user-visible issues, but follow-up fix passes should still verify whether each helper/config string is actually reachable in release UI.
- Asset/JSON content that may leak into production UI should be reviewed in a dedicated follow-up sweep if those assets are rendered directly.