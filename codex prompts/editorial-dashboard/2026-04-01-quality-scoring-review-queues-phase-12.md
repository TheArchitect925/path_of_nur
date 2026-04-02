===== PHASE X PROMPT phase 12 — MASTER DASHBOARD QUALITY SCORING, REVIEW QUEUES, AND CONTENT TRIAGE =====

PRIMARY OBJECTIVE === BUILDING MASTER DASHBOARD QUALITY SCORING, REVIEW QUEUES, AND CONTENT TRIAGE

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

===== QURAN EXPLANATION SOURCE & VALIDATION RULE =====

All Qur’an explanation content MUST follow authentic tafsir methodology.

When generating explanation content:

1. Determine the meaning using:
   - Qur’an (cross-referenced ayahs)
   - authentic tafsir grounding (e.g., Ibn Kathir-level understanding)
   - widely accepted interpretations from mainstream Sunni scholarship

2. Then simplify into Path of Nūr language:
   - simple
   - standard
   - kids

3. STRICT RULES:
   - Do NOT copy tafsir text directly
   - Do NOT invent interpretations
   - Do NOT introduce speculative or modern reinterpretations without grounding
   - Do NOT introduce sectarian, fringe, polemical, or weakly grounded claims
   - If meaning is unclear or disputed, keep explanation general and safe

4. PRIORITY:
   - accuracy over creativity
   - clarity over depth
   - simplicity without distortion

5. If uncertain:
   - fallback to a safe, widely accepted general meaning
   - never guess or over-interpret

===== END =====

At the very end, audit everything and provide one full summary.

TASK TYPE
Build a quality scoring, review queue, and triage layer inside the hidden Master Editorial Dashboard.

GOAL
Turn the dashboard from a passive content viewer into an active internal review system that helps the app owner quickly identify:
- weak content
- missing content
- inconsistent tone
- missing kids-safe variants
- missing source metadata
- missing localization
- incomplete content packs
- high-priority items needing attention first

This phase must work across the full app, not only the Qur’an:
- Qur’an ayah explanations
- surah summaries
- hadith
- stories
- duas
- dhikr
- learning paths
- kids content
- actions / Ocean Drops mappings
- recommendations / spiritual moments
- localization health

IMPORTANT PRODUCT DIRECTION
This is still an internal-only owner dashboard feature.
It should feel like:
- content operations
- editorial triage
- review control center

Not:
- a messy admin panel
- a destructive bulk editor
- a noisy developer dump

The system must help answer:
- what is most important to review next?
- what is missing?
- what is weak?
- what is launch-ready?
- what is unsafe or incomplete?

SECURITY / ACCESS RULES
1. Reuse the hidden master dashboard access model already added:
   - hidden unlock gesture
   - PIN gate
   - initial PIN 0786
   - session unlock state
   - production-safe feature flag
2. Do not expose review queues in public navigation.
3. Do not weaken access protection.

EXECUTION RULES
1. Audit first before editing.
2. Reuse the Master Editorial Dashboard architecture already added.
3. Build scoring and triage in a normalized way across content domains.
4. Keep all destructive actions disabled or heavily constrained in this phase.
5. Prefer read-first, review-first workflows.
6. Preserve localization.
7. Run analyzer on changed files and summarize results.

AUDIT REQUIREMENTS

A. Audit current dashboard data model
Identify:
- what normalized metadata already exists
- what content flags exist today
- what review statuses already exist
- which domains are already represented cleanly
- which domains need derived scoring instead of direct metadata

B. Audit current editorial pain points
Find what is currently difficult to see quickly:
- missing simple/standard/kids/deep coverage
- draft vs reviewed vs verified imbalance
- missing tags/source refs
- missing kids-safe adaptations
- content packs with weak completion
- routes with content but no quality metadata
- recommendation systems depending on incomplete source content

C. Decide scoring strategy
Choose a scoring model that is transparent, explainable, and easy to tune.
Preferred:
- rule-based scoring
- weighted flags
- human-readable issue reasons
- domain-aware adjustments where needed

IMPLEMENTATION REQUIREMENTS

A. Add normalized quality scoring model
Create shared internal models such as:
- EditorialQualityScore
- EditorialIssue
- EditorialReviewQueueItem
- EditorialTriageCategory
- EditorialPriorityLevel

Suggested concepts:
- numeric score (for example 0–100)
- priority (critical / high / medium / low)
- issue reasons
- readiness level
- review status
- domain
- content id
- route/link

Keep this normalized enough to work across all content domains.

B. Add rule-based scoring engine
Build an internal scoring engine that evaluates each content item based on factors such as:
- required fields present
- optional but important fields present
- kids-safe variant present where expected
- source reference present
- localization present
- explanation/action/recommendation dependencies satisfied
- review status
- content length sanity
- tone risk flags if available
- stale or unreviewed content flags
- coverage completeness for grouped packs

Examples:
- Qur’an ayah entry with simple+standard+kids+sourceRefs+reviewed = high score
- kids content with no kids-safe variant = major penalty
- story item missing route or summary = medium penalty
- recommendation content pointing to incomplete source content = penalty

C. Add issue classification
For each low-scoring item, classify issues clearly, such as:
- missing_simple
- missing_standard
- missing_kids
- missing_source_ref
- missing_localization
- needs_review
- draft_only
- incomplete_route_metadata
- weak_pack_coverage
- kids_safety_gap
- missing_action_mapping
- missing_recommendation_tags

These issue codes should be internal, structured, and filterable.

D. Add review queues
Build queue views inside the Master Dashboard such as:
- Critical Issues
- Needs Review
- Kids Safety Gaps
- Missing Localization
- Missing Source Metadata
- Incomplete Content Packs
- Low Quality / Weak Coverage
- Ready for Verification
- Recently Updated
- Stale / Old Content

Each queue should show:
- item title
- domain
- status
- score
- issue summary
- route / link to inspect

E. Add pack-level health views
For grouped content packs, show health status such as:
- total items
- reviewed items
- verified items
- missing required fields count
- kids-safe coverage %
- source metadata coverage %
- localization coverage %
- overall pack readiness

This is especially important for:
- Qur’an rollout packs
- stories packs
- kids content packs
- learning path packs

F. Add triage dashboard widgets
On the main Master Dashboard overview page, add concise widgets like:
- critical issues count
- high-priority review count
- items needing kids-safe adaptation
- items missing source refs
- incomplete packs
- items ready to verify
- recent content changes
- localization gaps

Keep the overview useful and glanceable.

G. Add content health drill-down
Allow drilling into:
- domain → pack → item
- queue → item
- score band → items

This should make it easy to go from “something is wrong” to “which item exactly?”

H. Add internal notes / flags support
If there is already a clean metadata place for lightweight notes, add internal review notes support such as:
- owner note
- review note
- blocked reason
- follow-up action

Keep it simple and local-first.
Do not build a full collaboration platform.

I. Add readiness labels
Support internal readiness states such as:
- not_started
- draft
- reviewed
- verified
- launch_ready
- needs_revision

Make these visible in the dashboard and usable for filtering.

J. Add domain-aware expectations
Not all domains need the same scoring rules.

Examples:
- Qur’an ayah entries expect explanation coverage and source refs
- hadith entries may need source/collection strength
- kids content expects child-safe adaptation
- recommendations expect tags and linked source content
- actions expect Ocean Drop mapping sanity
- localization items expect ARB or translated content readiness

Implement shared core scoring plus domain-specific extensions.

K. Add search and filter improvements
Extend the Master Dashboard filtering to support:
- by score range
- by issue type
- by priority
- by readiness state
- by domain
- by pack
- by kids-safe gap
- by source-ref gap
- by localization gap

L. Keep editing limited and safe
This phase should remain mostly read-first / review-first.
If any inline mutation is added, keep it limited to very safe metadata actions like:
- mark reviewed
- mark verified
- add/remove internal review note
- assign readiness state

Do NOT add dangerous bulk destructive actions.

M. Add internal debug / explainability
For each score, make it possible to inspect why it got that score:
- positive factors
- penalties
- issue list
- readiness effect
- pack effect if any

This must be internal-facing and readable.

N. Preserve existing systems
Do not regress:
- dashboard access control
- master overview
- Qur’an readers
- kids reader
- explanation system
- action system
- recommendations
- spiritual moments
- Ocean Drops mappings
- localization overview
- routing stability

O. Cleanup and ownership
Keep the design modular:
- scoring engine
- issue classification
- queue assembly
- dashboard widgets
- drill-down views
- safe metadata actions

Avoid mixing scoring logic directly into UI widgets.

VALIDATION
1. Confirm quality scores are generated for supported content domains.
2. Confirm review queues populate correctly.
3. Confirm issues are classified and filterable.
4. Confirm pack-level health works.
5. Confirm dashboard overview shows triage widgets clearly.
6. Confirm access control still works and dashboard remains hidden from normal users.
7. Confirm any inline review-state changes are safe.
8. Confirm analyzer passes on changed files.

DELIVERABLES
After implementation, provide:
- audit summary
- files changed
- scoring model design
- scoring rules summary
- queue categories added
- pack health metrics added
- overview widgets added
- filters/search enhancements
- any safe inline review actions added
- analyzer results
- follow-up recommendations for Phase 13

===== END =====
