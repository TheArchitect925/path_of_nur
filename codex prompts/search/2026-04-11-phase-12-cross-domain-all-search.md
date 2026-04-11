===== PHASE 12 — CROSS-DOMAIN “ALL SEARCH” (QURAN + HADITH + DUA + LEARN) =====

PRIMARY OBJECTIVE === BUILD A TRUSTWORTHY, FEDERATED “ALL SEARCH” THAT SURFACES QURAN, HADITH, DUA, AND LEARN CONTENT TOGETHER, WHILE PRESERVING EACH DOMAIN’S CANONICAL SEARCH OWNER AND TRUST RULES

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task building on:
- canonical Qur’an search
- canonical Hadith search (verified-only)
- Dua search/discovery
- Learn discovery/index
- canonical cross-domain editorial relation model

Do not replace existing domain search systems.
Do not weaken trust rules.
Do not guess. Reuse the existing canonical owners for each domain.

CONTEXT
We now have:
- Qur’an search (mature)
- Hadith search (polished, verified-only)
- Dua domain with Qur’an linking
- Learn/World content with verse anchors
- canonical cross-domain editorial relation model (stable ids + relation types)

What is missing:
- one unified “All” search surface that:
  - aggregates results from each domain
  - keeps domains distinct and trustworthy
  - optionally surfaces connected content via the relation model

GOAL
Create a federated “All” search experience that:
1. accepts a single query
2. queries each domain through its canonical search owner
3. merges results into a grouped, readable UI
4. preserves safe navigation into each domain’s canonical reader/detail
5. optionally augments results with relation-based connections (lightweight)

IMPORTANT PRODUCT RULES
- Do NOT build a new monolithic search engine.
- Use each domain’s canonical search:
  - Qur’an → quran search owner
  - Hadith → hadith search owner (verified-only)
  - Dua → dua repository/search
  - Learn → existing discovery/index
- Keep results grouped by domain.
- Keep the UI calm; do not overwhelm the user.
- Do not mix trust levels across domains.

IMPLEMENT THE FOLLOWING

A. ADD A CANONICAL “ALL SEARCH” OWNER
- Create a federated search owner that:
  - accepts a query
  - dispatches to each domain’s canonical search provider
  - collects results into a unified result model
- Do not duplicate domain logic; call existing providers.

B. DEFINE A FEDERATED RESULT MODEL
- Each result must include:
  - domain (quran | hadith | dua | learn)
  - id (canonical id)
  - title/label
  - snippet
  - highlight terms
  - navigation payload (route + params)
- Keep this model thin and composable.

C. ADD A DEDICATED “ALL SEARCH” ROUTE / PAGE
- Create a new route (e.g. `/search` or `/learn/search`)
- Provide:
  - search input
  - grouped result sections
  - empty states
- Do not replace `/quran/search` or `/learn/hadith/search`.

D. GROUP RESULTS BY DOMAIN
Display sections like:
- Qur’an
- Hadith
- Duas
- Learn

Within each section:
- show top N results (e.g. 3–5)
- add “View all in <domain>” handoff:
  - → `/quran/search?q=...`
  - → `/learn/hadith/search?q=...`
  - → appropriate Dua/learn routes

E. USE EXISTING SEARCH OWNERS
- Qur’an results must come from the canonical Qur’an search
- Hadith results must come from the canonical Hadith search (verified-only)
- Dua results must use Dua repository/search logic
- Learn results must use existing discovery/index providers

F. ADD LIGHT RELATION-AWARE AUGMENTATION (OPTIONAL V1)
- For top results, optionally add 1–2 related items using the editorial relation model:
  - e.g. Hadith result → show related Qur’an chip
  - Qur’an result → show related Hadith chip
- Keep this minimal and deterministic.

G. ADD SEARCH MEMORY (OPTIONAL REUSE)
- Reuse or extend existing search memory patterns:
  - recent queries
  - suggestion chips
- Keep it unified at the “All” level but do not break domain-specific memory behavior.

H. EMPTY STATES
- If no results:
  - suggest simpler queries
  - show curated suggestions
- If query empty:
  - show suggestions across domains (balanced set)

I. RESULT NAVIGATION
- Each result must open the canonical route:
  - Qur’an → `/quran/surah/...`
  - Hadith → `/learn/hadith/lesson/:id`
  - Dua → existing dua detail route
  - Learn → appropriate content route
- Do not bypass domain routing or trust logic.

J. TRUST RULES
- Hadith results must still come only from verified public subset
- Qur’an results remain canonical
- Dua/learn must respect their own trust models
- Do not surface non-public or incomplete data

K. ADD TEST COVERAGE
Add or update tests for:
- federated search owner calling each domain search
- grouped result output structure
- navigation correctness per domain
- verified-only Hadith enforcement
- empty state behavior
- suggestion behavior

L. DO NOT BREAK
- canonical domain search owners
- `/quran/search`
- `/learn/hadith/search`
- Hadith reader/detail
- Qur’an reader
- Dua flows
- Learn routes
- localization
- persistence keys

M. KEEP THE CHANGESET TIGHT
- Build the federated layer only.
- Do not rewrite domain search engines.
- Do not redesign readers.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What federated search owner was added
4. How results are grouped by domain
5. How each domain search is reused
6. How navigation works per domain
7. How trust rules remain intact
8. Validation notes
9. Analyzer results
10. Test results
11. Any follow-up notes for future deeper relation-aware search

At the very end, explicitly confirm:
- a canonical cross-domain “All search” now exists
- each domain still uses its own search owner
- Hadith results remain verified-only
- navigation opens correct canonical readers
- existing routes and trust rules remain intact

===== END =====
