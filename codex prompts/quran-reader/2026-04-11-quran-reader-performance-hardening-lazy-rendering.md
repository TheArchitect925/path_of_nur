===== PHASE X PROMPT — QURAN READER PERFORMANCE HARDENING (LAZY AYAH RENDERING + NARROWER REBUILDS) =====

PRIMARY OBJECTIVE === FIX THE MAIN STUTTER SOURCE IN THE QURAN READER WITHOUT CHANGING USER-FACING BEHAVIOR

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-safe performance optimization for the Quran reader only.

Background:
An audit has already been completed. The main findings were:
- the Quran reader eagerly builds the full surah ayah list
- the page-level build watches too many providers
- per-ayah provider watches inside the ayah loop multiply rebuild cost
- each ayah card is expensive to render
- follow-mode scroll logic may add hitching, but it is not the first fix target

Execution rules:
1. Do not redesign the UI.
2. Do not remove features.
3. Do not break playback, follow mode, search, memorization, notes, bookmarks, personalization, enrichment, or ayah actions.
4. Preserve routing, localization, theming, and existing behavior.
5. Do not change persistence or delete any user data/state.
6. Audit the current implementation again briefly before editing so the final change matches the live code.
7. Make the smallest production-ready changes that remove the main bottlenecks.
8. Run analyzer on changed files and summarize results.

Implement the following in this order:

A. Convert eager ayah rendering to lazy rendering
- Replace the current eager full-surah ayah construction pattern with a lazy builder approach.
- Prefer a ListView.builder / CustomScrollView + SliverList / equivalent lazy rendering strategy that fits the existing reader architecture.
- Keep current reader behavior intact.
- Ensure long surahs no longer build all ayah cards up front.

B. Narrow page-level rebuild scope
- Reduce broad page-level provider subscriptions in QuranReaderPage.
- Keep only the provider reads that truly need to live at page scope.
- Use smaller extracted widgets and/or `select` where appropriate so playback/search/settings/highlight changes do not trigger unnecessary full-page rebuilds.
- Be careful not to change behavior.

C. Move per-ayah reactive dependencies into narrow ayah item boundaries
- Remove per-ayah provider watches from the parent ayah loop.
- Move them into narrowly scoped ayah item widgets so only the relevant visible item rebuilds when needed.
- Keep current ayah card content and logic intact.

D. Preserve fragile behavior
- Preserve:
  - playback controls
  - follow mode
  - current ayah tracking
  - search highlighting
  - word/ayah highlighting
  - memorization state
  - contextual knowledge/theme links
  - notes/bookmarks/actions
- Do not do a broad refactor of follow-mode logic yet unless needed for compatibility with lazy rendering.

E. Keep visuals unchanged for this pass
- Do not remove the glass system in this pass.
- Do not redesign ayah cards.
- Only make the structural performance changes needed to reduce stutter.

F. Add light safeguards if needed
- If lazy rendering affects scroll-to-current-ayah or ensureVisible behavior, update that logic carefully so it still works with lazy-built items.
- Do not use hacky delays unless absolutely necessary and justified.

G. Validation
Confirm:
1. long surahs render lazily
2. the reader no longer eagerly constructs all ayah cards on first build
3. page-level rebuild scope is smaller than before
4. per-ayah watches are no longer multiplied in the parent loop
5. playback/follow/search/highlighting still work
6. analyzer passes on changed files

Deliverables:
Provide a concise summary with:
- files changed
- what was changed
- how lazy rendering was implemented
- what page-level watches were narrowed
- what per-ayah watches were moved
- any compatibility adjustments made for follow mode / scroll targeting
- analyzer results

At the very end, include a short audit note on whether the next likely optimization after this should be:
1. follow-mode scroll coordination
2. ayah card paint simplification
3. text/highlight span optimization

===== END =====
