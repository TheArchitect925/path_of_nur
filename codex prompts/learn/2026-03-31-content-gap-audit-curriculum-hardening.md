===== PHASE 7 PROMPT — CONTENT GAP AUDIT & CURRICULUM HARDENING =====

PRIMARY OBJECTIVE === AUDIT THE CURRENT LEARNING CONTENT, GUIDED PATHS, TRANSITIONS, AND DOMAIN COVERAGE SO PATH OF NUR CAN IDENTIFY REAL CONTENT GAPS, WEAK JOURNEYS, DUPLICATES, AND CURRICULUM ROUGH EDGES BEFORE BUILDING MORE LESSONS

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- naming/copy cleanup
- Guided Learning Paths V1
- safe Learn route / alias / canonical ownership consolidation
- deep UX polish & progression clarity
- personalization & path intelligence

This is an AUDIT-FIRST curriculum pass.

Core rule:
Do not go haywire and remove/delete records, pages, lessons, routes, seeded content, metadata, search mappings, path steps, or curriculum structure for no reason.

This pass is primarily for:
- discovery
- curriculum assessment
- identifying gaps
- hardening structure
- producing a safe implementation backlog

Do NOT begin with a blind content rewrite.

==================================================
PRODUCT GOAL
==================================================

Now that Learn is cleaner, guided, and more intelligent, we need to inspect the actual learning experience itself.

The goal is to answer:
- where are the strongest content lanes?
- where do paths feel weak, abrupt, empty, duplicated, or too advanced?
- where is beginner guidance missing?
- where are transitions between steps poor?
- where do paths point to pages that are valid technically but weak pedagogically?
- what should be added next for the highest curriculum impact?

This phase should make it possible to improve learning quality intentionally instead of randomly adding more content.

==================================================
CORE CURRICULUM PRINCIPLES
==================================================

- Start simple
- Guide progressively
- Reduce abrupt jumps
- Avoid duplicate lessons with different names
- Preserve authentic Islamic framing
- Respect canonical domain ownership
- Keep kids content age-appropriate
- Prefer depth with clarity over endless scattered content
- Reuse good existing content before creating new content

==================================================
IMPORTANT NON-GOALS
==================================================

DO NOT:
- do a giant content rewrite
- mass-delete weak content
- rewrite Qur’an internals casually
- break guided paths
- break `/quran/*` canonical ownership
- break kids route family
- break Learn search/indexing
- invent placeholder lessons just to fill a table
- create fake “completeness” claims

==================================================
AUDIT SCOPE
==================================================

Audit all relevant Learn-related curriculum surfaces, including where applicable:
- Foundations
- Qur’an
- Worship
- Character
- Stories
- Games
- Explore-linked learning utilities where relevant
- Kids learning
- Arabic / letters / tracing / beginner Arabic
- Salah learning / wudu / prayer help
- Dhikr / adhkar beginner learning
- Qur’an beginner journey content
- reflections / notes / story-linked learning if part of curriculum
- guided learning paths and their step mappings
- personalization-driven recommendations if they expose weak path logic

Also inspect:
- seeded path definitions
- learning content metadata
- route targets used by path steps
- visible landing summaries/subtitles if they overpromise thin content
- any existing content indexes or search metadata
- domain data files, lesson lists, page groupings, content hubs, and path step mappings

==================================================
YOUR TASK
==================================================

1. AUDIT ALL CURRENT GUIDED PATHS
Inspect each current path such as:
- Foundations Path
- Salah Path
- Qur’an Beginner Path
- Daily Dhikr Path
- Character Path
- Kids Starter Path

For each path, assess:
- does it have a clear beginner-to-next-step flow?
- are the steps coherent?
- are there abrupt jumps?
- are any steps technically valid but weak pedagogically?
- are any steps duplicative?
- are any steps missing a needed bridge lesson?
- are any steps too shallow or too advanced for the intended path?
- is the path complete enough to feel useful?
- does completion feel meaningful?

2. IDENTIFY CURRICULUM GAPS BY DOMAIN
For each main domain:
- Foundations
- Qur’an
- Worship
- Character
- Stories
- Games
- Kids
- Arabic

Identify:
- missing beginner entry lessons
- missing bridge content
- missing practice-oriented support
- missing “what next?” transitions
- domains that exist structurally but feel thin
- domains with too many disconnected pages but weak guided flow
- domains with mislabeled or misplaced content
- domains that rely too heavily on technical route access rather than meaningful learning progression

3. IDENTIFY DUPLICATES / OVERLAPS
Find content that is:
- duplicated directly
- duplicated conceptually under different names
- competing across multiple hubs/pages
- repeated in paths in a confusing way
- redundant enough to simplify later without deleting yet

Be specific:
- note the pages/routes/lessons involved
- explain whether the duplication is harmless, helpful, or confusing

4. AUDIT BEGINNER SAFETY
Assess whether a true beginner can safely use the system.

Look for:
- assumptions of prior knowledge
- steps that are too advanced too early
- content with weak onboarding
- unexplained Islamic terms
- lack of “why this matters” context
- lack of short/simple entry lessons
- missing soft introductions before deeper topics

This is especially important for:
- Foundations
- Salah
- Qur’an Beginner
- Dhikr
- Kids

5. AUDIT KIDS CURRICULUM QUALITY
Do a focused audit of kids learning.

Assess:
- entry flow clarity
- age-appropriateness
- progression quality
- Arabic learning progression
- story-led continuity
- whether tracing/letters content is integrated well
- whether kids paths feel coherent or fragmented
- whether kids is too broad or too scattered
- whether the Kids Starter Path actually feels like a meaningful start

6. AUDIT QUR’AN BEGINNER FLOW CAREFULLY
Important:
- `/quran/*` remains canonical
- do not propose duplication under Learn

Audit the pedagogical beginner experience, not just route correctness:
- is the beginner Qur’an journey truly beginner-friendly?
- is there a soft entry for users intimidated by the Qur’an tab?
- does the path balance reading/listening/reflection properly?
- are memorization steps introduced too early or too vaguely?
- are there missing bridge concepts?

7. AUDIT TRANSITIONS BETWEEN CONTENT
Assess transitions such as:
- Foundations -> Salah
- Foundations -> Qur’an Beginner
- Salah -> Daily Dhikr
- Daily Dhikr -> Character
- Stories -> deeper learning
- Kids Starter -> next Kids lane

Find:
- missing transition pages
- weak next-step logic
- abrupt difficulty spikes
- where a tiny bridge page/lesson would dramatically improve flow

8. ASSESS CONTENT DEPTH VS CLUTTER
For each domain/path, determine whether the current problem is:
- too little content
- enough content but poor sequencing
- enough content but poor labeling
- too much scattered content and weak curation
- missing practice support
- missing summaries or intros
- missing completion closure

9. CREATE A REALISTIC CURRICULUM HARDENING PLAN
After the audit, propose a phased hardening plan.

The plan must separate:
PHASE A — relabel/resequence only
PHASE B — add bridge lessons/pages
PHASE C — improve beginner intros
PHASE D — fill true domain gaps
PHASE E — improve kids progression
PHASE F — enrich stories/character depth
PHASE G — optional advanced paths later

Important:
- do not treat every gap as equally urgent
- prioritize by learner impact
- prefer small high-impact additions first

10. CREATE AN AUDIT DOCUMENT
Create a markdown file such as:
docs/content_gap_audit_curriculum_hardening_2026-03-31.md

It must include:
- executive summary
- path-by-path audit
- domain-by-domain gap analysis
- duplicate/overlap findings
- beginner safety findings
- kids-focused findings
- Qur’an beginner flow findings
- transition/bridge findings
- prioritized hardening recommendations
- risks and do-not-break notes

11. CREATE A HARDENING BACKLOG
Create a second markdown file such as:
docs/curriculum_hardening_backlog_2026-03-31.md

It must include:
- specific tasks
- grouped by phase
- impact level
- risk level
- dependencies
- recommended implementation order
- route/canonical ownership notes
- localization impact notes
- do-not-break notes

12. OPTIONAL SMALL SAFE FIXES ONLY IF TRIVIAL
If you find a very small, obvious, safe issue that can be fixed without restructuring, you may fix it.
Examples:
- clearly wrong path subtitle
- obviously broken path step label
- tiny ordering issue
- clearly missing link target if already known and safe

But:
- do not let “small fixes” turn into a rewrite
- document any such fixes clearly

13. PRESERVE LOCALIZATION
Any visible text changes must remain localization-ready.
If no text changes are needed in this audit-only pass, say so clearly.

At the end, report:
- which keys were added
- which keys were reused
- which locale files were updated
- or confirm none were changed

14. PRESERVE SEARCH / INDEXING / METADATA
Do not regress:
- search
- route metadata
- path metadata
- content indexing
- canonical destination handling

This is an audit pass, not a destructive metadata rewrite.

15. PRESERVE CANONICAL OWNERSHIP
Important:
- `/quran/*` remains canonical
- kids route family remains preserved
- guided paths remain orchestration, not replacement
- learn remains front door, not duplicate owner of all content internals

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. All main guided paths were audited.
2. All major Learn domains were reviewed.
3. Beginner safety was assessed.
4. Kids curriculum quality was assessed.
5. Qur’an beginner flow was assessed without breaking canonical ownership.
6. Duplicates/overlaps were identified.
7. Transition/bridge gaps were identified.
8. A realistic hardening plan was produced.
9. No destructive cleanup was performed.
10. Localization/search/metadata/canonical ownership remain intact.

==================================================
DELIVERABLES
==================================================

1. Perform the curriculum/content gap audit.
2. Create the audit markdown file.
3. Create the hardening backlog markdown file.
4. Return a concise but thorough summary including:
   - audit findings
   - strongest paths/domains
   - weakest paths/domains
   - biggest beginner-risk issues
   - biggest kids-content issues
   - biggest Qur’an beginner flow issues
   - duplicate/overlap findings
   - highest-priority fixes next
   - files created
   - localization impact
5. At the very end, audit your own audit and provide one full summary so we can work on fixing this next.

===== END PHASE 7 PROMPT — CONTENT GAP AUDIT & CURRICULUM HARDENING =====
