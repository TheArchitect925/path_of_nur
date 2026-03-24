# Arabic Content Authoring Rules

Last updated: 2026-03-24

Use the shared Arabic content-authoring layer under `lib/features/arabic/` before adding new Arabic learning content.

## When to create a content unit

- Create a new `ArabicContentUnit` when the content is a reusable learning item that may appear in packs, search, bridge flows, or future review/discovery surfaces.
- Reuse an existing unit when the same canonical item already exists and only the presentation differs between Kids and adults.
- Keep route ownership outside the page where possible by attaching the canonical `ArabicLearningRouteTarget` to the unit.

## Required metadata

- stable canonical `id`
- audience ownership: `kids`, `adult`, or separate per-audience units when the route target differs
- `type`
- `target`
- `sortOrder`
- Arabic text or transliteration when the item is learner-facing content
- related shared ids when the item builds on existing letters, words, or phrases

## What stays shared vs local

- Shared:
  - canonical letter ids
  - shared beginner word and phrase ids
  - Qur’an bridge snippet ids
  - short-surah bridge ids
  - shared route-target metadata where the destination is canonical
- Local:
  - page-specific layout
  - presentation-only copy
  - learner-progress state
  - bridge or review progress persistence

## Packs and composition

- Author pack grouping through `ArabicContentPackComposition`.
- Reference units by id instead of embedding duplicated content objects.
- Keep pack metadata small: pack id, audience, pack type, order, and unit ids.
- Use localized pack titles/subtitles in the presentation layer rather than hardcoding them in the composition.

## Audio and references

- Reuse existing shared audio asset references whenever the content overlaps the shared beginner catalog or bridge layers.
- Do not create duplicate audio ids for the same canonical word or phrase.
- Qur’anic references must continue to use exact structured refs and existing shared deep-link helpers.

## Route access

- New Arabic content must remain reachable through existing Kids/adult Arabic owners, shared lesson packs, or existing bridge surfaces.
- Avoid page-local one-off route logic for content that should later be searchable or grouped.
- If a new content type is not yet searchable, structure its unit metadata so search can index it later without another refactor.
