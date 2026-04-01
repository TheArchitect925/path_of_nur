===== PHASE 6 PROMPT — PERSONALIZATION & PATH INTELLIGENCE =====

PRIMARY OBJECTIVE === BUILD A PRODUCTION-READY PERSONALIZATION AND PATH INTELLIGENCE LAYER FOR PATH OF NUR SO THE LEARN EXPERIENCE CAN SAFELY RECOMMEND THE RIGHT NEXT STEP FOR EACH USER WITHOUT BREAKING EXISTING ROUTES, PATHS, SEARCH, OR CONTENT OWNERSHIP

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- naming/copy cleanup
- Guided Learning Paths V1
- safe Learn route / alias / canonical ownership consolidation
- deep UX polish & progression clarity

This is an intelligence-layer pass.
It should make the Learn experience feel more personal, more guided, and more relevant.

Core rule:
Do not go haywire and remove/delete records, routes, pages, content, progress data, metadata, search mappings, analytics hooks, reward hooks, or canonical route ownership for no reason.

This phase should be:
- rule-based first
- production-safe
- explainable
- lightweight
- privacy-respectful
- easy to extend later

==================================================
PRODUCT GOAL
==================================================

The Learn experience should stop feeling like the same static page for everyone.

Instead, Path of Nūr should start answering:
- what should this user do next?
- what path should we recommend now?
- what content fits their recent activity?
- what is the clearest next guided action?

This phase should introduce:
- recommendation logic
- a lightweight user learning profile
- smarter “next step” logic
- path sequencing suggestions
- simple seasonal/context-aware suggestions
- safer and more meaningful Learn landing personalization

==================================================
GUIDING PRODUCT PRINCIPLES
==================================================

- Personal, not creepy
- Helpful, not noisy
- Rule-based, not magical
- Explainable, not arbitrary
- Calm, not pushy
- Lightweight, not overengineered

==================================================
IMPORTANT NON-GOALS
==================================================

DO NOT:
- build a heavy AI/ML system
- call external AI services for recommendations
- create unstable black-box ranking logic
- rewrite core Learn architecture
- duplicate existing content
- break current guided paths
- break `/quran/*` canonical ownership
- break kids route family
- break search/indexing
- overfit recommendations to weak signals
- create manipulative engagement loops

==================================================
CORE CAPABILITIES TO BUILD
==================================================

A. Lightweight user learning profile
B. Recommendation / suggestion engine
C. Smarter “Your Next Step” logic
D. Path sequencing / next-best-path suggestions
E. Seasonal and contextual suggestions
F. Personalized Learn landing enhancements
G. Safe persistence and explainable behavior
H. Production-safe documentation

==================================================
IMPLEMENTATION TASKS
==================================================

A. AUDIT EXISTING SIGNALS BEFORE BUILDING
Before editing:
- inspect what learning-related progress, resume, activity, and usage signals already exist
- inspect guided path progress signals
- inspect Qur’an, Dhikr, Salah, Kids, and Learn interaction signals that are safe to reuse
- inspect where “Continue Your Journey” currently gets its state
- identify what data already exists vs what must be added

Document clearly:
- reusable signals
- missing signals
- risky signals not worth using yet

B. BUILD A LIGHTWEIGHT USER LEARNING PROFILE MODEL
Create a production-ready personalization model such as:
- UserLearningProfile
- LearningSignals
- RecommendationContext
- PathSuggestion
- RecommendationReason
- LearningIntentSignal

The user learning profile should be lightweight and derived from app usage, not invasive.

Suggested profile inputs:
- active guided paths
- completed guided paths
- recent completed steps
- recent visited learning domains
- recent Learn destinations
- Qur’an engagement
- Dhikr engagement
- Salah learning engagement
- Kids usage if relevant
- recency and consistency indicators
- whether user is new / returning / active / dormant from a Learn perspective

Important:
- keep identifiers stable
- keep the model explainable
- use existing persistence patterns
- do not collect unnecessary sensitive data

C. BUILD A RULE-BASED RECOMMENDATION ENGINE (V1)
Implement a simple, production-ready recommendation engine.

Suggested services:
- LearningRecommendationEngine
- PathSuggestionService
- LearningNextStepResolver

The engine should answer at minimum:
1. What is the single best next action for this user?
2. What path should we recommend next?
3. What backup suggestions should we show?
4. Why was this recommendation made?

The logic must be deterministic and explainable.

Possible V1 rules:
- if user has an active guided path with incomplete next step -> recommend continuing that step first
- if user completed a path recently -> recommend the next logical path in sequence
- if user has no path history -> recommend Foundations Path
- if user is engaging heavily with Qur’an -> recommend Qur’an Beginner Path or next Qur’an-related path
- if user is engaging with Dhikr consistently -> recommend Daily Dhikr Path or the next Dhikr-related step
- if user started but abandoned a path recently -> suggest resuming it if still relevant
- if user is inactive -> recommend a short, light, easy re-entry action
- if user is mainly in kids surfaces -> prioritize Kids Starter Path or kids-friendly follow-up
- if no strong signal exists -> fall back to a safe beginner recommendation

Do not create fake precision.
If the signals are weak, recommendations should remain broad and safe.

D. BUILD “YOUR NEXT STEP” UX
Upgrade the top Learn action area so it becomes more intelligent.

Possible visible pattern:
- “Your Next Step”
- show one primary recommendation
- show a short reason/subtitle
- show direct CTA

Examples of the kind of output:
- Continue Salah Path — Step 3 of 7
- Start Foundations Path
- Return to Daily Dhikr
- Continue Qur’an Beginner Path
- Explore Stories next

Requirements:
- calm and simple
- no overwhelming recommendation wall
- one strong primary next action
- optional 1–2 secondary suggestions
- integrate cleanly with existing Learn landing
- preserve prior progression clarity UX

E. BUILD PATH SEQUENCING / NEXT-BEST-PATH LOGIC
Create a simple path progression graph or equivalent safe mapping.

Example sequence ideas:
- Foundations -> Salah
- Salah -> Daily Dhikr
- Daily Dhikr -> Character
- Foundations -> Qur’an Beginner
- Qur’an Beginner -> deeper Qur’an path later
- Kids Starter -> appropriate next kids lane

Requirements:
- this should be data-driven, not hardcoded in UI widgets
- safe to extend later
- preserve the ability to branch based on interest/domain
- document sequencing decisions clearly

F. BUILD SEASONAL / CONTEXTUAL SUGGESTIONS (LIGHTWEIGHT)
Add a small contextual recommendation layer where practical.

Examples:
- Friday learning suggestion
- Ramadan suggestion hooks if app already has date/context infrastructure
- a short “easy re-entry” suggestion after inactivity
- a “keep your momentum” suggestion when user is actively progressing

Important:
- keep it lightweight
- do not overbuild a calendar engine
- do not make the Learn page noisy
- only surface contextual suggestions if signal strength is good enough

If seasonal infrastructure is not ready, scaffold it safely and document follow-up work rather than forcing a brittle implementation.

G. PRESERVE `/QURAN/*` CANONICAL OWNERSHIP
If recommendations suggest Qur’an content:
- route into canonical `/quran/*` surfaces where appropriate
- do not create a second full Qur’an owner under Learn
- keep Learn as the recommender/orchestrator, not the duplicate owner

H. PRESERVE KIDS SAFETY
If kids-related personalization is included:
- keep it audience-appropriate
- do not accidentally over-surface kids content to users without relevant usage
- preserve the kids route family
- keep kids recommendations intentional and explainable

I. PRESERVE GUIDED PATHS & PROGRESS
Recommendations must not break guided paths.

Requirements:
- current path progress remains intact
- recommended next step uses actual persisted path progress
- step completion state remains authoritative
- do not create conflicting progress logic
- if route targets change, centralize the resolution safely

J. PRESERVE SEARCH / INDEXING / METADATA
Do not regress:
- Learn search
- route metadata
- content indexing
- category metadata
- guided path lookup metadata

If recommendation metadata is added:
- keep it additive
- do not destabilize existing content contracts

K. REWARD / OCEAN / XP INTEGRATION (LIGHTWEIGHT)
Where safe and already supported, integrate subtle reinforcement.

Possible examples:
- recommendations can surface completion momentum
- completing recommended actions can still reuse existing reward hooks
- do not create inflated or exploitable reward systems just because recommendations exist

Important:
- no artificial reward farming loops
- no spammy encouragement
- keep motivation calm and sincere

L. LOCALIZATION
All new user-facing text must be localization-ready.

Requirements:
- do not hardcode new user-facing strings if the project uses localization
- reuse existing keys where appropriate
- add only necessary new keys
- update all relevant locale files/resources
- preserve current localization loading and structure

At the end, report:
- which keys were added
- which keys were reused
- which locale files were updated

M. PERFORMANCE & STABILITY
Ensure:
- recommendation calculations are lightweight
- no heavy recomputation on every frame
- avoid rebuild storms
- use memoization/providers/selectors where appropriate
- keep state ownership clean
- preserve offline-first behavior

N. DOCUMENTATION
Create a markdown file such as:
docs/personalization_and_path_intelligence_v1_2026-03-31.md

Include:
- executive summary
- signals used
- user learning profile model
- recommendation engine overview
- primary recommendation logic
- next-best-path sequencing model
- seasonal/contextual logic
- Qur’an ownership notes
- Kids safety notes
- reward integration notes
- localization impact
- performance considerations
- future extension opportunities

O. CREATE A FOLLOW-UP BACKLOG
Create a second markdown file such as:
docs/personalization_backlog_2026-03-31.md

Include:
- richer personalization ideas
- difficulty/depth levels
- adaptive sequencing
- multi-profile/family-aware recommendations
- Ramadan and seasonal expansion
- stronger inactivity recovery flows
- analytics and tuning needs
- future AI-assisted recommendation possibilities
- do-not-break notes

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. A production-ready personalization layer exists.
2. A lightweight user learning profile exists.
3. A rule-based recommendation engine exists.
4. “Your Next Step” or equivalent intelligent top action works.
5. Active guided paths are prioritized correctly.
6. Next-best-path suggestions are coherent and explainable.
7. Recommendations do not break existing guided path progress.
8. `/quran/*` remains canonical.
9. kids route family remains safe.
10. search/indexing/metadata was not regressed.
11. localization remains intact.
12. performance remains smooth.
13. analyzer passes on changed files, or remaining issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement Personalization & Path Intelligence V1.
2. Create the documentation markdown file.
3. Create the backlog markdown file.
4. Return a concise but thorough summary including:
   - audit findings before changes
   - files changed
   - user learning profile/domain model added
   - signals used
   - recommendation rules implemented
   - how “Your Next Step” works
   - path sequencing model
   - seasonal/contextual logic added
   - how `/quran/*` ownership was preserved
   - how Kids was preserved
   - localization keys added/reused
   - performance impact
   - analyzer results
5. At the very end, audit your own implementation and provide one full summary so we can work on fixing this next.

===== END PHASE 6 PROMPT — PERSONALIZATION & PATH INTELLIGENCE =====
