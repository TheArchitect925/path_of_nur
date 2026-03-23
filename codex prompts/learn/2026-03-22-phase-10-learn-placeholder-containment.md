===== PHASE 10 PROMPT — LEARN PLACEHOLDER/STUB SURFACING AUDIT AND CONTAINMENT =====

PRIMARY OBJECTIVE === BUILDING LEARN PLACEHOLDER/STUB SURFACING AUDIT, CONTAINMENT, AND PRODUCTION-SAFE LEARN ROUTING

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-readiness phase focused on the Learn area. DO NOT rebuild the Learn system. DO NOT delete working lesson data, progress, notes, bookmarks, journey progress, learning completion state, or routing unless a route is clearly placeholder-only and must be safely contained. Build carefully on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve working learning content, routing, progress, and saved state
- Do not delete real lesson data or user completion records
- Do not break Learning Hub navigation
- Do not mass-rewrite the entire Learn architecture in this phase
- Contain placeholder/stub content safely and cleanly
- Prefer reuse of real content over placeholder exposure
- Do not leave dead taps on reachable surfaces
- Keep the app production-safe for internal beta and closer to public beta
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Run a full Learn-area audit focused on placeholder, stub, shell, and incomplete content that is still reachable from live routes

2. Identify all Learn routes/pages/cards that currently expose:
   - placeholder sections
   - stub-backed items
   - shell pages
   - incomplete content catalogs
   - routes that look real but are not production-safe

3. Contain or fix those reachable placeholder/stub surfaces so the Learn experience is trustworthy

4. Preserve and surface real content where available instead of exposing placeholder-backed catalog sections

5. Leave a clean backlog of what should be properly built later versus what must be hidden/contained now

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the Learn system end-to-end before editing.

Inspect at minimum:
- Learning Hub landing page
- Learn category catalog and all reachable category routes
- Qur’an Learning area
- Hadith / History / Life / World sections if routed through Learn
- Dua surfaces and seeded dua content
- learning journey placeholders
- any cards or islands that route into incomplete learning content
- any “Browse all” or category explorer surfaces in Learn
- any lesson/detail pages reachable from placeholder categories
- any shared learn-section builders or catalogs

Audit these questions:
- Which Learn routes are reachable from live navigation?
- Which of those are backed by real content?
- Which are backed by placeholder catalogs or stub seed data?
- Which pages look production-ready at first glance but collapse into placeholder content after tap-through?
- Which placeholder sections are safe to temporarily hide?
- Which can be replaced by real content already موجود in the codebase?
- Are there catalog entries that should remain in code for future build-out but should not surface in production-facing UI today?
- Which sections are strongest and should remain prominently surfaced?
- Which routes need graceful “not yet available” containment instead of broken/incomplete detail pages?

--------------------------------------------------
B. CLASSIFY LEARN SURFACES
--------------------------------------------------

For each reachable Learn surface, classify it as one of:

- Production ready
- Mostly ready but needs polish
- Functional but structurally weak
- Placeholder-backed and should be hidden
- Placeholder-backed but can be contained gracefully
- Real route but needs content-source cleanup
- Future-facing catalog entry that should remain non-surfaced

Do not guess. Base this on actual route reachability and data backing.

--------------------------------------------------
C. CONTAIN PLACEHOLDER-BACKED CATEGORY SECTIONS
--------------------------------------------------

Find all category sections in Learn that are reachable today but backed mainly by placeholder data.

For each one, choose the safest production-ready outcome:
- hide from live Learn entry surfaces
- replace with a real existing destination/content set
- keep visible but clearly and gracefully contained if partial content is genuinely usable
- convert to a smaller curated subset of real items only

Requirements:
- do not expose fake breadth
- do not leave users tapping into shells
- do not destroy future catalog structure in code if it is useful later
- prefer trustworthy smaller scope over misleading larger scope

--------------------------------------------------
D. CONTAIN LEARNING-JOURNEY PLACEHOLDERS
--------------------------------------------------

Audit learning-journey-related placeholder routes or cards in the Learn area.

Requirements:
- if a learning journey route is not truly ready, it should not behave like a complete production feature
- hide, reroute, or gracefully contain incomplete journey placeholders
- preserve any real journey progress data already in place
- do not remove working journey systems that are already used elsewhere

If a placeholder journey entry is visible today:
- either replace it with a production-safe destination
- or contain it in a calm, honest, non-broken way
- but do not leave misleading shells

--------------------------------------------------
E. DUA STUB SURFACING AUDIT
--------------------------------------------------

Audit the Dua area carefully.

The audit already flagged many stub-backed seeded items on live surfaces.

Requirements:
- identify which dua entries are real and usable
- identify which are stub/placeholder/incomplete
- ensure live dua surfaces do not overpromise or expose obviously incomplete entries
- preserve real dua content
- preserve data structure for future expansion if useful
- prefer curated real dua sets over noisy stub catalogs

Possible safe outcomes:
- filter live surfaces to real/complete duas only
- mark incomplete seed entries as non-surfaced
- restructure explorer pages so only production-safe content is presented
- keep internal backlog/catalog data but do not surface it publicly yet

--------------------------------------------------
F. LEARN HUB CLEANUP WITHOUT REBUILD
--------------------------------------------------

Improve the Learn Hub so it surfaces the strongest trustworthy destinations.

Requirements:
- do not rebuild the whole Learn Hub in this phase
- reduce exposure of incomplete or placeholder-backed destinations
- keep routing coherent
- improve trust in the visible Learn entry points
- prefer real sections such as Qur’an Learning / stronger Hadith or other real content areas over weak placeholder categories

Do not turn this into a full IA redesign. This phase is about production-safe containment and trustworthy surfacing.

--------------------------------------------------
G. GRACEFUL CONTAINMENT PATTERN
--------------------------------------------------

Where a section cannot yet be fully removed or replaced, implement a production-safe containment pattern.

This should be:
- graceful
- honest
- visually consistent
- non-broken
- not debug-like
- not “coming soon” spam everywhere

Requirements:
- no dead buttons
- no fake content cards
- no raw placeholder copy
- no confusing empty shells

If a route must remain reachable for architectural reasons, give it a proper contained state with:
- clear title
- calm explanation
- safe next actions
- links back to real learning content where appropriate

Keep this minimal and premium.

--------------------------------------------------
H. ROUTING SAFETY SWEEP
--------------------------------------------------

After containment changes, audit all affected Learn routes.

Check for:
- cards pointing to hidden/contained routes
- orphaned category entries
- duplicate destinations
- routes now better served by different real pages
- back navigation correctness
- deep-link safety where relevant

Requirements:
- do not remove route names casually if existing code depends on them
- prefer route-level containment or UI-level hiding over breaking route references
- preserve stability

--------------------------------------------------
I. CONTENT OWNERSHIP CLEANUP (LIGHTWEIGHT)
--------------------------------------------------

Where the audit shows confusing ownership between catalog data and real content:
- make small targeted cleanup improvements
- clarify what is production content versus future catalog structure
- avoid giant architecture surgery in this phase

Examples:
- mark/segregate placeholder catalog items
- centralize “is production-safe” filtering if needed
- avoid repeated ad hoc checks across multiple pages if a clean helper/model flag is better

But keep scope controlled.

--------------------------------------------------
J. EMPTY / LOADING / ERROR / CONTAINED STATES
--------------------------------------------------

Upgrade Learn surfaces that currently fail poorly.

Requirements:
- incomplete sections should fail gracefully
- empty content should explain itself cleanly
- loading states should be coherent
- errors should not look like broken developer shells
- contained states should still feel on-brand

This is especially important for:
- category pages
- explorer pages
- dua pages
- any contained journey surfaces

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

This phase must preserve:
- learning progress
- notes/bookmarks tied to Learn content
- lesson completion state
- journey progress
- any seeded real content already in use
- any future catalog structure still needed by the team

Requirements:
- no destructive migrations
- no record deletion just to hide placeholder content
- if filtering is introduced, do it safely and explicitly
- keep old records valid even if their parent category is no longer prominently surfaced

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add or update meaningful tests for the production-safety changes.

Prioritize:
- Learn Hub no longer exposes hidden placeholder-backed sections where intended
- contained routes render proper fallback/contained states
- real content routes still work
- dua live surfaces exclude stub-only items where intended
- no broken routing due to containment changes
- category filtering logic is covered if introduced

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Learn audit findings
   - reachable placeholder/stub surfaces found
   - strongest real surfaces retained
   - contained/hidden routes and why

3. Learn Hub summary
   - what is now surfaced
   - what was removed/contained from live entry points
   - why this is safer for production

4. Dua audit summary
   - real versus stub content findings
   - what was filtered/contained
   - any future backlog left in place

5. Routing safety summary
   - affected routes
   - hidden vs contained vs rerouted destinations
   - any intentionally preserved route shells

6. Data safety summary
   - confirmation that no user learning data/progress was lost
   - any model/filter changes introduced

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - remaining Learn debt
   - regressions found/fixed
   - what should be the next phase after this

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- reachable placeholder-backed Learn sections are no longer misleadingly exposed
- learning-journey placeholder surfacing is safely contained
- Dua live surfaces are cleaner and more trustworthy
- Learn Hub surfaces the strongest real destinations
- no broken routes or dead taps remain from this cleanup
- no user data/progress is lost
- Learn becomes materially safer for production/public beta

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire Learn architecture
- delete future catalog structure unnecessarily
- remove real content because it needs polish
- create fake filler content
- leave “coming soon” clutter everywhere
- break learning progress or route stability
- broaden into a full note-system rewrite
- broaden into full localization cleanup outside the Learn placeholder/stub scope

Stay focused on Learn placeholder/stub containment, trustworthy surfacing, and production-safe routing.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 10 PROMPT =====
