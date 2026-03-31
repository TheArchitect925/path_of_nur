# Platform and Content Completion Audit

Date: 2026-03-31

Scope:
- Full-platform readiness review using the continuity memory, release docs, platform docs, tests, and active source trees
- Content-completion sweep for seeded learning/catalog content, kids stories, hadith, duas, and Learn/Journey placeholder-backed surfaces

## Executive Summary

The app is feature-rich and broadly implemented, but it is not fully content-complete across the whole platform.

The two main remaining debt clusters are:
- release readiness outside iOS/iPadOS
- generic Learn/catalog content that is still placeholder-backed or reference-incomplete

Safe current release scope remains:
- iOS
- iPadOS

Still not honest to ship as fully ready:
- Apple Watch
- tvOS
- broad multilingual launch across all locales

## Platform Readiness

### iOS and iPadOS

Current posture:
- strongest and most realistic launch target
- supported by current release docs and continuity memory
- repo evidence continues to treat this as the first public-release scope

Remaining release work:
- signed-device QA for notifications, playback, auth, backup/restore, auto-backup, accessibility, and large-text behavior

### Apple Watch

Current posture:
- native watch app, extension, complications, sync bridge, and QA docs all exist
- watch simulator build path exists
- watch functionality is substantially scaffolded

Evidence of remaining blockers:
- watch release docs still require real paired-device verification
- watch launch still depends on signing, App Group alignment, bundle registration, and full checklist execution
- the earlier go-live audit still records the archive packaging issue:
  - `Watch app archive is missing CFBundleIconName=AppIcon`

Audit conclusion:
- Apple Watch is implemented enough to continue hardening
- Apple Watch is not release-ready

### tvOS

Current posture:
- native canonical target exists in `ios/PathOfNurTV`
- tvOS has strong documentation, governance, parity registries, and test coverage
- repo contains `10` dedicated tvOS test files and `37` tvOS-focused docs

Evidence of remaining blockers:
- current release docs still say tvOS is not first-release ready
- TestFlight checklist still requires signed archive validation and real Apple TV hardware QA
- platform inventory explicitly keeps public launch blocked on signed-distribution proof and real-device evidence

Audit conclusion:
- tvOS is far beyond “just planned”
- tvOS is still not release-ready for public ship claims

### Localization Platform Risk

Localization validator result on 2026-03-31:
- `ar`: missing `2`, extra `70`, placeholder mismatches `0`
- `bn`: missing `2`, extra `73`, placeholder mismatches `61`
- `de`: missing `12`, extra `70`, placeholder mismatches `0`
- `fa`: missing `2`, extra `73`, placeholder mismatches `68`
- `fa_AF`: missing `2`, extra `73`, placeholder mismatches `68`
- `ha`: missing `2`, extra `73`, placeholder mismatches `19`
- `hi`: missing `2`, extra `70`, placeholder mismatches `36`
- `id`: missing `2`, extra `73`, placeholder mismatches `61`
- `ku`: missing `2`, extra `72`, placeholder mismatches `21`
- `ms`: missing `2`, extra `73`, placeholder mismatches `61`
- `pa`: missing `2`, extra `73`, placeholder mismatches `15`
- `ps`: missing `2`, extra `72`, placeholder mismatches `0`
- `tg`: missing `133`, extra `72`, placeholder mismatches `15`
- `tr`: missing `2`, extra `72`, placeholder mismatches `35`
- `ur`: missing `12`, extra `70`, placeholder mismatches `0`

Audit conclusion:
- structural localization debt is still a go-live blocker for multilingual release
- German, Urdu, Tajik, Hausa, and several other locales still need follow-up even after the recent 10-phase pass

## Content Completion Audit

### Dua

Current dataset status from `dua_seed_data.dart`:
- total items: `180`
- complete items: `165`
- stub items: `15`

Important nuance:
- many completed entries still retain legacy `stub_*` ids, so ID prefix counts are not trustworthy
- the dataset header and `completionStatus` are the real source of truth

What remains incomplete:
- `15` intentionally unfilled `Planned Dua` placeholders remain
- these are still product-curation placeholders rather than source-safe finalized entries

Audit conclusion:
- Dua is substantially complete
- only the final planned placeholders remain

### Hadith

Current dataset status:
- `88` seeded hadith entries
- no obvious stub shells in the main hadith foundation dataset

Remaining incompleteness:
- all `88` entries still have `transliterationSourceVerified: false`
- no `transliteratedText` field usage was found in this dataset

Audit conclusion:
- Hadith is content-present
- transliteration and source-verification depth are still incomplete

### Kids Prophet Stories and Kids Stories

Current live seeded content:
- prophet bedtime stories: `14`
- kids Islamic stories: `10`
- companion stories: `3`

Live-content conclusion:
- these seeded story collections are populated and usable
- they are not the main remaining content-completion risk

Separate draft-source debt:
- `docs/kids_prophet_stories_source.md` is still marked as source-draft-only and not wired into live UI
- `docs/kids_bedtime_story_audio_metadata_source.md` is still marked as source-draft-only and notes incomplete Prophet Muhammad Part 2 prose coverage

Audit conclusion:
- live kids stories are mostly complete
- draft story-source docs still need consolidation or cleanup

### Generic Learn Content Catalog

This is the biggest remaining content-completion problem.

`learn_content_catalog.dart` still includes:
- `3` `Qur’an reference placeholder` values
- `4` `Hadith reference placeholder` values

`learn_content_data.dart` still includes:
- `24` placeholder mentions
- many topic pages still rely on generic reference placeholders such as:
  - `Qur’an reference placeholder`
  - `Hadith reference placeholder`
  - `Zakat placeholder`
  - broad thematic labels instead of structured references

Audit conclusion:
- generic Learn topic pages exist
- many are still structurally content-incomplete because their Islamic references are placeholder-level rather than final

### Learn Category Catalog

`learn_category_catalog.dart` still contains `12` entries marked `sectionType: 'placeholder'`.

These are:
- Guidance for New Muslims
- Aqeedah Essentials
- The Five Pillars of Islam
- Ramadhan and Fasting
- Zakah & Sadaqah
- Jummah
- Hajj
- Umrah
- Eid
- Funeral
- Fiqh Basic
- FAQ

Important nuance:
- some of these routes now point to real pages or real content-detail pages
- but the catalog still classifies them as placeholder-backed, which means completion/ownership is still not fully normalized

Audit conclusion:
- the Learn taxonomy still carries visible placeholder debt
- this is the clearest remaining browse/discovery completion gap

### Learning Journey

Current signal:
- route-backed Learning Journey is broadly implemented
- direct registry counts no longer show active explicit placeholder stage entries in the main registry
- the codebase still contains placeholder handling paths and a placeholder lesson page for compatibility/containment

Audit conclusion:
- Learning Journey is less incomplete than the generic Learn catalogs
- remaining debt is mostly containment/legacy support, not large missing content batches

## Highest-Priority Remaining Content To Complete

1. Replace placeholder references in generic Learn topic content with real Qur'an and hadith references.
2. Normalize the `12` placeholder-tagged Learn catalog entries so they either point to clearly finished owned content or are intentionally hidden.
3. Finish the final `15` planned Dua placeholders after product/source curation.
4. Decide whether hadith transliteration is required for launch and, if yes, build a verified transliteration pass.
5. Consolidate or archive the unwired kids story source-draft docs so they do not linger as shadow content debt.

## Honest Platform Conclusion

The platform is not missing large amounts of code. It is missing:
- release-grade validation on Apple Watch and tvOS
- multilingual integrity cleanup
- completion of the generic Learn reference/catalog layer

If the question is “do we still have remaining content that needs to be completed?”, the answer is yes.

The biggest remaining content debt is:
- generic Learn topic references and placeholder-tagged catalog entries

The biggest remaining platform debt is:
- watchOS real-device/signing/archive readiness
- tvOS signed-distribution and hardware QA
- localization validator parity and translation quality
