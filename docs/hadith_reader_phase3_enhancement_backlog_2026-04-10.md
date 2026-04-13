# Hadith Reader Phase 3 Enhancement Backlog

1. Completed 2026-04-12: Added a small source-provenance disclosure row on the reader page so future imports can surface trusted import/source pipeline metadata without changing the reader structure again.
2. Completed 2026-04-12: Added a copy confirmation surface that works even when the page is hosted outside a `Scaffold`, using a reusable shared transient-feedback helper for sacred-reading surfaces.
3. Completed 2026-04-12: Added category/subcategory chips in the reader header area so Hadith taxonomy is visible without competing with source trust metadata. The subcategory chip now deep-links through the canonical Hadith subcategory route.
4. Completed 2026-04-12: Wired the reader into canonical source-book and chapter browse routes using normalized source collection/chapter metadata. The source row opens the source collection and the new chapter row opens the exact source chapter when available.
5. Completed 2026-04-12: Added a dedicated Hadith share formatter that splits compact list/card sharing from richer reader-page sharing. Compact sharing is now available on search, browse, and source-browse result cards while the reader keeps the fuller share composition.

## Notes

- The provenance row now reuses `HadithEntry.sourceMetadata` and surfaces a localized human-readable provenance label plus optional pipeline detail.
- The new shared feedback helper lives under `lib/shared/widgets/app_transient_feedback.dart` and does not depend on `ScaffoldMessenger`.
- Reader taxonomy visibility now stays in the header card instead of creating a separate discovery section or a page-local search/filter system.
- Source/chapter navigation now reuses the canonical `/learn/hadith/source/:sourceId` and `/learn/hadith/source/:sourceId/chapter/:chapterId` owners instead of adding one-off route logic.
- The share formatter now has separate compact and reader variants so list surfaces stay concise while the reader still shares fuller Hadith context.

## QA, Localization, and Hardening

- Completed 2026-04-12: Finished real translations for the new Hadith reader provenance and chapter labels across the remaining supported locales instead of leaving English fallback text in shipped locale bundles.
- Completed 2026-04-12: Added focused QA coverage for reader metadata formatting and compact-versus-reader share formatting, and repaired the older test call site that still referenced the pre-split share API.
- Performance review 2026-04-12: No extra providers, controllers, animations, or persistent listeners were added in this phase. The taxonomy chips and provenance rows remain lightweight display widgets, and the new formatting helpers stay synchronous and allocation-light for per-entry rendering.
- Search/indexing impact: none in this hardening pass. Existing canonical Hadith taxonomy and source metadata reuse remains unchanged.
- tvOS parity note 2026-04-12: No mirrored tvOS Hadith reader surface is currently owned like the Home prayer or Qur’an surfaces, so this pass required no same-pass tvOS UI divergence update.
