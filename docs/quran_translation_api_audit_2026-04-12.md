# Qur'an Translation API Audit

Date: 2026-04-12

## Goal

Audit the current Path of Nur Qur'an, dua, and hadith translation posture and compare three candidate Qur'an APIs for a future trusted-source multilingual translation expansion.

## Current repo posture

### Qur'an

- Canonical Qur'an reader ownership remains in:
  - `lib/features/learn/quran/data/quran_repository.dart`
  - `lib/features/learn/quran/data/quran_content_repository.dart`
- Current Qur'an translations are resolved locally through the `quran` package, not through a live remote API.
- The current allowed translation codes are a fixed curated set:
  - `en.sahih`
  - `en.clear`
  - `ur.urdu`
  - `bn.bengali`
  - `id.indonesian`
  - `tr.saheeh`
  - `fa.dari`
- Translation code gating currently lives in `lib/features/learn/quran/application/quran_providers.dart`.
- Translation resolution currently lives in `QuranRepository._translationForCode(...)`.
- Transliteration is already treated as a separately managed trusted asset and is bundled locally for deterministic offline behavior:
  - `lib/features/learn/quran/data/quran_transliteration_local_data.dart`
  - file header says it was generated from a trusted transliteration source: `AlQuran.cloud (edition: en.transliteration)`

### Dua

- Dua content is already repo-curated rather than API-driven.
- The main dataset lives in `lib/features/learn/dua/data/dua_seed_data.dart`.
- Entries carry explicit trust and source metadata such as:
  - `sourceType`
  - `sourceRef`
  - `verificationStatus`
  - `completionStatus`
- This is aligned with the product requirement to avoid unreviewed auto-translated devotional content.

### Hadith

- Hadith content is already on a stronger verified-source pipeline than the Qur'an translation layer.
- The runtime and source models include explicit verification fields such as:
  - `translationSourceVerified`
  - `arabicMatnSourceVerified`
  - `transliterationSourceVerified`
- Key files:
  - `lib/features/learn/hadith/domain/hadith_foundation_models.dart`
  - `data/hadith/hadith_master_dataset.json`
  - `lib/features/learn/hadith/data/generated_hadith_foundation_data.dart`

## Audit summary

- The app already follows the right governance pattern for dua and hadith: trusted, curated, reviewable, source-aware.
- The Qur'an reader is currently trustworthy, but its translation inventory is constrained by the local package integration and fixed code mapping.
- The strongest future direction is not "live auto-translation." It is:
  - trusted human-reviewed Qur'an translations
  - source-aware metadata
  - curated allowlisting
  - optional local caching/bundling for stability

## Candidate API comparison

### 1. Quran Foundation / Quran.com API

Pros:

- Best fit for Path of Nur's trust posture.
- Official, Quran-specific content API with explicit support for translations, resources, and languages.
- Documentation explicitly states the API delivers peer-reviewed translations and warns against auto-translation.
- Better long-term match for a product that wants governance and source credibility, not just raw access.

Cons:

- More integration overhead than the simpler public APIs.
- Requires authentication / client setup rather than pure unauthenticated public fetches.
- Migration will need a proper ingestion and allowlist layer rather than ad hoc runtime calls.

Assessment:

- Best product fit.
- Best theological/governance fit.
- Best foundation for future source metadata and translator allowlisting.

### 2. AlQuran Cloud

Pros:

- Very easy to use.
- Strong edition model with multiple languages and translators.
- Supports listing available editions and fetching multiple editions for a verse or surah.
- Already familiar to this repo because transliteration was generated from `en.transliteration`.

Cons:

- Easier technically, but weaker as a source-governance story than Quran Foundation for a trust-sensitive production reader.
- Broad open edition inventory means we would still need our own strict allowlist and review process.
- Better as a data source helper than as the canonical trust anchor.

Assessment:

- Good fallback or migration helper.
- Good for internal tooling and ingestion.
- Not my first choice as the long-term canonical source of multilingual Qur'an translations for this app.

### 3. Quranpedia API

Pros:

- Supports translations and available-language queries.
- No auth, simple read-only access.
- Could be useful for exploration or secondary tooling.

Cons:

- Less aligned with the current app architecture and trust posture than Quran Foundation.
- Broader content surface, but the translation-governance story is less compelling for this particular app decision.
- Would still require a strong local curation layer before shipping.

Assessment:

- Technically usable.
- Not the best fit for the app's current trust-first pattern.

## Recommendation

Recommended primary source: `Quran Foundation / Quran.com API`

Why:

1. It best matches the app's existing trust model for hadith and dua.
2. Its docs explicitly support the "do not auto-translate Qur'an text" rule.
3. It provides a better long-term canonical source for reviewed translations, language discovery, and translator metadata.
4. It supports a future architecture where only explicitly approved translation resources are exposed in the app.

Recommended fallback/helper source: `AlQuran Cloud`

Why:

- already used indirectly in the repo for trusted transliteration bundling
- useful for comparison, ingestion tooling, or emergency coverage checks
- not the preferred canonical product source

## Proposed phased approach

### Phase 0: Audit and policy lock

- Finalize the product rule that Qur'an translations must come only from approved human-reviewed translator resources.
- Define a source allowlist per release language.
- Keep dua and hadith on their current curated pipelines; do not collapse them into a shared "generic translation" system.

### Phase 1: Metadata and architecture preparation

- Introduce a first-class Qur'an translation resource model in the app, separate from locale UI strings.
- Capture:
  - translation id
  - language code
  - display name
  - translator / edition name
  - source provider
  - source URL or canonical reference
  - approved-for-release flag
- Keep the current local translation package path alive during this phase.

### Phase 2: Ingestion prototype

- Build a small ingestion script or import layer that pulls only approved Qur'an translation resources from Quran Foundation.
- Store imported translation metadata and text in a controlled local artifact rather than relying on uncontrolled runtime fetches for first release behavior.
- Start with the current languages already present in the app:
  - English
  - Urdu
  - Bengali
  - Indonesian
  - Turkish
  - Persian/Dari

### Phase 3: Runtime integration behind a compatibility boundary

- Replace direct package-only translation lookup with a repository interface that can read from:
  - current bundled source
  - imported trusted-source translation bundle
- Keep Arabic text untouched and separate from translation payloads.
- Keep transliteration as its own independently governed source path.

### Phase 4: Search and QA hardening

- Rebuild translation search indexes from the approved imported translations.
- Run language-by-language QA:
  - verse correctness spot checks
  - search behavior
  - reader rendering
  - deep links
  - daily verse
  - quotes/reader content joins

### Phase 5: Rollout and expansion

- Promote the imported trusted-source translation path to canonical.
- Add more release languages only after source review and product QA.
- Consider optional download bundles later if size becomes a concern.

## Implementation guidance

- Do not auto-translate any Qur'an translation text.
- Do not mix UI locale expansion with Qur'an translation expansion as one system.
- Do not fetch arbitrary public editions at runtime and expose them without review.
- Preserve the current local-first behavior where possible, especially for reader stability and search determinism.

## Final recommendation

- Choose `Quran Foundation / Quran.com API` as the canonical future Qur'an translation source.
- Use `AlQuran Cloud` only as a secondary helper or migration aid.
- Do not choose `Quranpedia` as the primary source for this app unless a later constraint blocks Quran Foundation adoption.
