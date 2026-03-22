# Content Expansion Structure

This folder is the canonical import/export target for internal Path of Nūr content authoring.

Current runtime content still loads from the existing seeded Dart data across each feature. Phase 15 adds a normalized internal schema and builder so future content can move toward one versionable structure without breaking shipped game flows.

Recommended layout:

- `content/crossword/`
- `content/word_search/`
- `content/matching/`
- `content/ayah/`
- `content/hadith/`
- `content/growth/`
- `content/packs/`
- `content/variations/`

Expected flow:

1. Create or edit content in the internal builder.
2. Validate against the normalized schema.
3. Preview the draft.
4. Export JSON.
5. Review and move exported files into the appropriate `content/` folder.
6. Bridge those files into runtime seeds only when the import path is ready.

Notes:

- Keep Qur'an content reference-driven and sourced from the app's canonical verified Qur'an dataset.
- Keep Hadith references tied to the existing authenticated Hadith source layer.
- Do not duplicate reward, pack, or variation logic inside exported content.
- Keep localization keys centralized; do not scatter large authored strings across widgets.
