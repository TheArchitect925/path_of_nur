# Hadith Reader Multi-Phase Delivery Plan

Date: 2026-04-12

## Recommended phase count

6 phases

This keeps the work incremental, lets us ship visible reader improvements early, and avoids coupling metadata, navigation, sharing, and UX feedback into one risky pass.

## Phase 1 — Reader Trust Foundation

Goal:
- Add the small source-provenance disclosure row on the reader page.

Scope:
- Extend the reader metadata area to surface trusted provenance/import pipeline details when present.
- Keep the row lightweight and secondary to the existing source, grade, reference, and narrator metadata.
- Reuse the current Hadith reader metadata/presentation structure instead of inventing a new reader section.
- Localize all new labels and helper text.

Likely files:
- `lib/features/learn/hadith/presentation/hadith_lesson_page.dart`
- `lib/features/learn/hadith/presentation/widgets/hadith_content_block.dart`
- `lib/features/learn/hadith/domain/hadith_foundation_models.dart`
- `lib/features/learn/hadith/application/hadith_foundation_repository.dart`
- `lib/l10n/app_*.arb`

Definition of done:
- Reader shows a provenance row only when trusted provenance data exists.
- No Qur'an text is touched.
- Existing reader layout remains calm and stable on iPhone and tvOS parity review is documented if relevant.

## Phase 2 — Shared Copy Confirmation Surface

Goal:
- Add a copy confirmation UX that works even when the page is not inside a `Scaffold`.

Scope:
- Build a reusable shared toast/banner/helper rather than a Hadith-only snackbar.
- Wire reader copy actions to the helper.
- Keep this suitable for future sacred-reading surfaces like Qur'an and Dua.
- Localize the visible confirmation text.

Likely files:
- `lib/features/learn/hadith/presentation/hadith_lesson_page.dart`
- `lib/shared/widgets/` shared feedback helper
- `lib/l10n/app_*.arb`

Definition of done:
- Copy confirmation works from the Hadith reader without depending on local `ScaffoldMessenger`.
- The helper is reusable and does not change global theme or architecture.

## Phase 3 — Reader Taxonomy Visibility

Goal:
- Add collection/category/subcategory chips to the reader header area.

Scope:
- Surface taxonomy only after Phase 1 trust metadata is in place so source trust stays primary.
- Reuse existing collection and subcategory metadata already present in the Hadith corpus.
- Keep chips navigable only if the route handoff is already canonical and stable.
- Localize any new helper copy or empty-state text.

Likely files:
- `lib/features/learn/hadith/presentation/hadith_lesson_page.dart`
- `lib/features/learn/hadith/presentation/widgets/hadith_content_block.dart`
- `lib/features/learn/hadith/presentation/hadith_subcategory_page.dart`
- `lib/features/learn/hadith/application/hadith_foundation_repository.dart`
- `lib/l10n/app_*.arb`

Definition of done:
- Reader taxonomy is visible without crowding the header.
- Chips reuse canonical browse/search ownership instead of creating page-local filters.

## Phase 4 — Source Book and Chapter Navigation

Goal:
- Add source-book and chapter handoff inside the reader.

Scope:
- Reuse the canonical source browse routes already present under `/learn/hadith/sources`.
- Let the reader open the source collection or exact chapter when normalized metadata exists.
- Preserve reader continuity behavior.
- Avoid duplicate navigation logic by reusing route helpers and existing source browse ownership.

Likely files:
- `lib/features/learn/hadith/presentation/hadith_lesson_page.dart`
- `lib/features/learn/hadith/presentation/hadith_source_browse_page.dart`
- `lib/features/learn/hadith/presentation/hadith_reader_continuity.dart`
- `lib/features/learn/hadith/domain/hadith_source_browse_models.dart`
- `lib/l10n/app_*.arb`

Definition of done:
- Reader can open the right collection/chapter when metadata exists.
- Missing chapter metadata degrades gracefully to collection-only navigation.

## Phase 5 — Dedicated Hadith Share Formatter

Goal:
- Replace the current single share-text path with purpose-specific Hadith sharing formats.

Scope:
- Add a compact share format for cards/lists/search results.
- Add a fuller reader share format for the reader page.
- Keep trusted source, grade, and narrator context clear.
- Make copy/share labels and errors localization-ready.

Likely files:
- `lib/features/learn/hadith/application/hadith_reader_share_service.dart`
- `lib/features/learn/hadith/presentation/hadith_lesson_page.dart`
- Hadith list/card/search surfaces that trigger sharing
- `lib/l10n/app_*.arb`

Definition of done:
- Reader share is richer than card share.
- Formats stay respectful, concise, and source-aware.

## Phase 6 — QA, Localization, and Hardening

Goal:
- Finish the rollout safely.

Scope:
- Localization completion for every new string across all supported locales.
- Widget or focused logic coverage for provenance visibility, copy confirmation fallback, chapter navigation, and share formatting.
- Reader performance review to avoid unnecessary rebuilds from the new metadata/header actions.
- Same-pass tvOS parity review note for any mirrored surface impact.
- Backlog follow-up for anything intentionally deferred.

Definition of done:
- `flutter gen-l10n` passes.
- New user-facing strings are localized through the existing system.
- No core architecture or global theme changes were introduced.

## Dependency order

1. Phase 1 first because it establishes the trusted metadata lane.
2. Phase 2 next because it creates reusable reader feedback infrastructure.
3. Phase 3 after that because taxonomy should sit around the stabilized metadata/header structure.
4. Phase 4 once reader metadata and taxonomy placement are settled.
5. Phase 5 after the navigation and metadata contract is stable, so the share formatter uses the right final fields.
6. Phase 6 closes the pass with localization and regression hardening.

## Delivery recommendation

- Ship Phases 1 and 2 together if we want an early UX-quality pass.
- Ship Phases 3 and 4 together if we want one discovery/navigation pass.
- Ship Phase 5 separately so share formatting can be reviewed on its own.
- Keep Phase 6 mandatory before calling the feature complete.
