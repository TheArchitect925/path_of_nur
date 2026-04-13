===== PHASE 2 PROMPT — HADITH READER CONTINUITY CONTROLS =====

PRIMARY OBJECTIVE === ADD CALM, CONTEXT-AWARE READER CONTINUITY TO THE HADITH READER WITHOUT REDESIGNING THE READER PAGE

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-ready reader continuity enhancement for Hadith.

Background:
Phase 1 already improved the large browse/detail surfaces by:
- converting large theme and collection pages to lazy rendering
- adding summary-first structure
- adding lightweight narrowing controls
- preserving navigation into the existing reader

The next weakness is continuity after opening a single hadith:
- users can enter from themes, collections, source/chapter browse, paths, or search
- once inside the reader, there is no calm “continue through this lane” experience
- the reader itself is strong; the missing piece is contextual next/previous/navigation continuity

Execution rules:
1. Audit the current live implementation first before editing.
2. Do not redesign the global UI.
3. Do not break routing, localization, theming, saved state, daily hadith, review, paths, or existing reader sections.
4. Preserve the current hadith lesson page content structure.
5. Do not delete records, stored progress, saved items, or user state.
6. Build this as a production-ready feature, not a placeholder.
7. Keep behavior deterministic and easy to reason about.
8. Run analyzer on changed files and summarize results.

Implement the following:

A. Add contextual reader continuity
Support continuity when a hadith is opened from an identifiable lane, such as:
- theme
- collection / current collection-scoped page
- source chapter
- guided path
- other existing deterministic list contexts already present in the repo

For supported lanes:
- show Previous
- show Next
- show a Back to [current lane] action or equivalent compact return affordance

B. Preserve lane context into the reader
- Pass enough route/context information into the reader so it knows the current lane and the ordered set it belongs to.
- Keep this minimal and production-safe.
- Do not create a giant navigation state framework if a smaller structured context object is enough.

C. Keep the reader calm
- Integrate the continuity controls into the existing reader respectfully.
- Do not clutter the page.
- Keep controls visually aligned with the app’s current surfaces and tone.
- The continuity layer should feel supportive, not like a noisy toolbar.

D. Keep ordering deterministic
- Theme/collection/source/path continuity should use a stable order.
- Do not produce random or shifting next/previous behavior.
- Reuse existing order semantics where practical.
- If some routes do not yet have enough context for continuity, degrade gracefully rather than faking it.

E. Optional compact lane index only if trivial
- If there is already a clean way to expose a compact jump list or mini index for the current lane, add it only if it is small and safe.
- Otherwise defer it.
- Do not overbuild this phase.

F. Do not overextend search continuity
- Search results are more fragile because result sets can be ephemeral or filtered.
- Only add next/previous for search if the current architecture already supports a deterministic result lane safely.
- Otherwise preserve a “Back to results” style return path and defer full search-lane continuity.

G. Preserve current reader features
Do not break:
- Arabic/transliteration/translation display
- meaning/lessons/reflection
- Qur’an links
- practice/action cards
- related content
- saved/review behavior
- existing route behavior for direct opens

H. Localization
- Localize any new continuity labels properly.
- Do not leave raw strings in the UI.

I. Validation
Confirm:
1. reader continuity works for supported deterministic lanes
2. previous/next behavior uses stable ordering
3. back-to-lane behavior works
4. unsupported entry points degrade gracefully
5. reader UI remains calm and uncluttered
6. analyzer passes on changed files

Deliverables:
Provide a concise summary with:
- files changed
- how lane context is passed
- which entry surfaces now support continuity
- how previous/next ordering is determined
- what unsupported contexts do
- new localization keys
- analyzer results

At the very end, include a short audit note on the best next phase after this:
1. route ownership cleanup
2. canonical hadith browse surface
3. stronger search-to-reader continuity

===== END =====
