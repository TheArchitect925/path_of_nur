===== PHASE X PROMPT phase 9 — PERSONALIZATION ENGINE FOR AYAH SELECTION, GUIDED PATHS, AND ADAPTIVE SPIRITUAL JOURNEYS =====

PRIMARY OBJECTIVE === BUILDING PERSONALIZATION ENGINE FOR AYAH SELECTION, GUIDED PATHS, AND ADAPTIVE SPIRITUAL JOURNEYS

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
Production-ready personalization system for ayah recommendations, action suggestions, and guided spiritual growth.

GOAL
Build a personalization engine that uses existing Path of Nūr systems to recommend:
- ayahs to read
- explanations to focus on
- reflection prompts
- “Live this Ayah” actions
- guided paths or thematic journeys

The system should feel:
- calm
- helpful
- respectful
- adaptive
- non-intrusive
- spiritually grounded

IMPORTANT PRODUCT DIRECTION
This is NOT a manipulative engagement engine.
It must not try to maximize screen time.

It should instead:
- help the user find the right ayah at the right moment
- gently support consistency
- connect the Qur’an to their real life
- adapt based on habits without becoming creepy or invasive

The system should feel like:
“Here is something beneficial for you today.”
Not:
“We are optimizing you.”

EXECUTION RULES
1. Audit first before editing.
2. Reuse existing explanation, action, Ocean Drops, reading progress, and journey systems.
3. Keep the engine deterministic and understandable.
4. Prefer transparent recommendation rules over black-box complexity.
5. Do not require external AI or network dependency in this phase.
6. Keep everything local-first and privacy-respecting.
7. Preserve existing reader and home flows.
8. Run analyzer and summarize results.
9. At the end provide one full audit summary and implementation summary.

AUDIT REQUIREMENTS

A. Identify all usable user signals already available in the codebase
Examples may include:
- recent ayahs read
- reading streak
- bookmarks
- notes
- memorization markers
- reflection/action completions
- prayer tracking
- dhikr usage
- learning journey progress
- kids profile / child mode
- time of day / day context
- prior recommended ayahs
- Ocean Drops history

B. Identify current recommendation surfaces
Find where personalized or semi-personalized content can appear safely, such as:
- home page
- Qur’an home/front door
- inside the reader
- journey/growth page
- kids home/reader
- daily cards

C. Identify constraints
Audit where personalization must remain lightweight and non-disruptive:
- do not interrupt reading
- do not clutter settings
- do not create route complexity
- do not conflict with memorization or playback

IMPLEMENTATION REQUIREMENTS

D. Add a clear personalization domain model
Introduce structured models for recommendation inputs and outputs.

Examples:
- QuranPersonalizationProfile
- QuranRecommendationContext
- QuranRecommendedAyah
- QuranRecommendationReason
- QuranRecommendationBundle
- QuranAdaptiveJourneySuggestion

Suggested fields:
- recommended ayah reference
- reason code
- confidence/priority score
- relevant tags
- recommended detail level
- recommended action if available
- recommended journey/path if relevant
- expiration / freshness metadata if useful

Keep the design understandable and maintainable.

E. Build a transparent recommendation engine
Create a local recommendation service/provider that scores ayahs based on clear weighted signals.

Potential signals:
- recently read ayah/topic continuity
- incomplete “Live this Ayah” actions
- foundational ayahs for beginners
- user-selected journey interests
- tags matching recent activity
- time-of-day appropriateness
- repetition avoidance
- streak support
- spiritual balance (do not show the same theme too often)

The recommendation logic must be:
- explainable
- deterministic enough to debug
- tunable
- not overly complex for v1

F. Add recommendation reason labels
Each recommendation should carry a human-readable reason, such as:
- “Continue where you left off”
- “Matches your recent reflection”
- “A gentle ayah for today”
- “Supports your prayer journey”
- “Good for memorization review”
- “Recommended for beginners”

These labels must be localized.

G. Personalize explanation detail level
Allow the engine to suggest a suitable explanation level based on context.

Examples:
- beginner/new Muslim → simple or standard
- kids reader → kids
- reflection session → reflection-friendly explanation rendering
- memorization flow → lighter explanation emphasis
- study-heavy user → standard or deep where available

Do NOT override the user’s chosen setting aggressively.
Use this as a recommendation or fallback behavior only where appropriate.

H. Personalize “Live this Ayah” actions
Use action tags and user behavior to recommend the most relevant ayah action.

Examples:
- if user recently engaged with gratitude-related content → surface gratitude ayah/action
- if prayer tracking is active → surface prayer-related ayah/action
- if user is consistent but not reflective → suggest a gentle reflection-oriented ayah

Keep it balanced and avoid repetition.

I. Add daily recommendation bundle
Create a daily recommendation bundle that can include:
- 1 primary ayah
- 1 explanation preview
- 1 suggested action
- optional journey/path suggestion
- optional secondary ayah if helpful

This bundle should be reusable across:
- home page
- Qur’an hub
- growth/journey surfaces

J. Add personalization surfaces
Integrate recommendations into the app in calm, non-intrusive places.

Preferred surfaces:
1. Home
   - “For you today” or equivalent
   - one ayah + one reason + one action

2. Qur’an home/front door
   - “Recommended next”
   - continue reading / reflect / live this ayah

3. Reader
   - subtle “You may also want to reflect on…” or “Related for your path”
   - keep small and secondary

4. Growth/Journey page
   - “Suggested spiritual focus”
   - tie to existing journey structure

Do not overuse this system everywhere.

K. Add kids-safe personalization path
For kids:
- use a much simpler rule set
- prioritize:
  - short surahs
  - moral/character ayahs
  - previously seen child-friendly content
  - simple actions
- reasons should be child-friendly and short

No heavy profiling.
No adult-style recommendation messaging.

L. Add repetition and freshness controls
Prevent the engine from recommending the same ayah too often unless intentionally needed.

Include:
- cooldown rules
- history-aware rotation
- continuity exception (okay to repeat if the user is in an active path or unfinished action)

M. Add preference and control support
Users should retain agency.

Consider adding lightweight controls such as:
- dismiss recommendation
- save for later
- “show me something simpler”
- “more like this” only if it fits existing architecture cleanly

Do not overbuild recommendation settings in this phase.

N. Keep privacy-first and local-first
This engine must work fully on-device/local logic in this phase.
Do NOT:
- require cloud profiling
- use external AI
- create invasive tracking
- infer sensitive states in a creepy way

O. Add internal scoring/debug support
Provide internal developer-readable structure to inspect why a recommendation happened.

This can include:
- reason codes
- signal contributions
- matched tags
- excluded candidates
- cooldown state

Keep this internal-facing, not user-facing.

P. Tie into Ocean Drops without distortion
Recommendations may support actions that lead to Ocean Drops,
but the engine must not become a farming optimizer.

Goal:
- meaningful action first
- drops second

Q. Preserve existing systems
Do not regress:
- explanation engine
- main reader
- kids reader
- Ocean Drops
- journeys
- playback
- memorization
- notes/bookmarks
- home page stability

R. Cleanup and final shaping
Keep ownership clean:
- profile/signal gathering
- recommendation scoring
- recommendation output bundle
- UI presentation

Avoid scattering recommendation logic across many widgets.

VALIDATION
1. Confirm the engine produces stable recommendations.
2. Confirm recommendation reasons are surfaced correctly.
3. Confirm daily recommendation bundle works.
4. Confirm kids recommendations stay child-safe.
5. Confirm repetition controls work.
6. Confirm explanation/action integration still behaves correctly.
7. Confirm no privacy-invasive behavior was introduced.
8. Confirm analyzer passes on changed files.

DELIVERABLES
After implementation, provide:
- audit summary
- files changed
- user signals used
- recommendation model design
- scoring logic summary
- recommendation surfaces added/updated
- adult vs kids personalization differences
- repetition/freshness logic
- internal debug/scoring support summary
- analyzer results
- follow-up recommendations for future personalization refinement

===== END =====
