# Qur'an Reader Modes Audit Backlog

1. Add widget and route tests for explicit reader mode switching so `reading`, `reflection`, `study`, `memorization`, and `theme` all prove their expected visible sections and density rules.
2. Localize the remaining hardcoded reader settings strings and helper copy in `quran_reader_page.dart`, especially the settings headers, audio labels, beta labels, and fallback error text.
3. Split the current mixed “mode card + settings drawer + playback controls” UX into clearer sections only if product QA confirms users are confusing modes with display toggles.
4. Add a compact ayah-level “Details” entry surface that opens the existing related-knowledge/reference viewer from any mode, so related content does not depend mainly on study-heavy inline sections.
5. Decide whether a dedicated `Listen` mode should be introduced as a first-class reader mode or whether the current shared playback surface plus follow-mode and mini-player already cover listening well enough without adding a sixth mode.
