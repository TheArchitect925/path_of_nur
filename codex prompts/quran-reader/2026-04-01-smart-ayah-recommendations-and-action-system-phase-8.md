===== PHASE X PROMPT phase 8 — SMART AYAH RECOMMENDATIONS + ACTIONABLE REFLECTION SYSTEM (OCEAN DROPS INTEGRATION) =====

PRIMARY OBJECTIVE === BUILDING SMART AYAH RECOMMENDATIONS AND ACTIONABLE REFLECTION SYSTEM

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
   - Do NOT introduce sectarian or weak interpretations
   - If meaning is unclear, keep it general and safe

4. PRIORITY:
   - accuracy over creativity
   - clarity over depth
   - simplicity without distortion

5. If uncertain:
   - fallback to safe general meaning
   - never guess

===== END =====

At the very end, audit everything and provide one full summary.

TASK TYPE
Build a smart recommendation and action system on top of the ayah explanation engine.

GOAL
Turn ayah understanding into:
- guided reflection
- small actionable steps
- habit formation
- Ocean Drops progression

This phase connects:
👉 Qur’an → Understanding → Action → Growth → Ocean Drops

IMPORTANT PRODUCT DIRECTION
This is the moment Path of Nūr becomes different from all other apps.

Not just:
❌ reading Qur’an  
❌ showing tafsir  

But:
✅ helping users LIVE the Qur’an

The system must feel:
- calm
- non-pushy
- meaningful
- optional but valuable

EXECUTION RULES
1. Audit first.
2. Reuse explanation system (Phase 2–7).
3. Integrate with Ocean Drops system (existing).
4. Keep UX minimal and calm.
5. Avoid gamification that feels artificial or forced.
6. Keep everything optional and user-respecting.
7. Run analyzer and summarize.

AUDIT REQUIREMENTS

A. Identify integration points
Find:
- where ayah explanation is rendered
- Ocean Drops logic
- daily/home surfaces
- journey/growth tracking system

B. Identify user signals available
Examples:
- last read ayah
- reading streak
- time of day
- prayer tracking
- dhikr usage
- learning progress

IMPLEMENTATION REQUIREMENTS

C. Add "Ayah Action Model"

Create a new domain model:

QuranAyahAction:
- surahNumber
- ayahNumber
- actionText (simple actionable step)
- category (e.g., patience, gratitude, prayer, kindness)
- difficulty (easy, medium, deep)
- suggestedDuration (optional)
- reflectionPrompt (reuse or override)
- rewardDrops (default = 1)

D. Generate actions from explanation

For each ayah (when possible):
- derive 1 simple action

Examples:
- “Make a short dua before starting something”
- “Be patient in one situation today”
- “Help someone quietly”
- “Remember Allah once before sleep”

Rules:
- must be realistic
- must be small
- must be doable today
- must not feel overwhelming

E. Add Action Recommendation Engine

Create a provider/service that:
- selects 1–3 ayahs per day for user
- prioritizes:
  - recently read ayahs
  - foundational ayahs
  - incomplete actions
  - variation (avoid repetition)

Output:
- recommended ayah
- explanation (already built)
- suggested action

F. Add "Act on this Ayah" UI

Inside main reader (subtle):

Add a small section:
👉 “Live this Ayah”

Contains:
- short action
- optional reflection prompt
- “Mark as done” button

Behavior:
- minimal
- non-intrusive
- only shown when explanation exists

G. Add Ocean Drops integration

When user completes action:
- +1 Ocean Drop
- add to user’s drop history
- tie into existing Ocean system

Rules:
- no spam clicking
- one completion per ayah per day
- prevent abuse

H. Add Daily Ayah Action (Home)

On homepage:

Add:
- “Today’s Ayah”
- explanation preview
- 1 action

User can:
- read
- reflect
- complete action

This becomes:
👉 daily spiritual anchor

I. Add Reflection tracking (lightweight)

Allow user to optionally:
- tap “Reflect”
- write 1 short note
- or skip

Do NOT force journaling.

J. Kids version (simplified)

In kids reader:
- show only:
  - “What we learn”
  - “Try this today”

Examples:
- “Say thank you to Allah”
- “Be kind to someone”

No complex tracking.
Still reward 1 drop.

K. Prevent gamification abuse

Do NOT:
- give multiple drops per tap
- allow spam completions
- turn into “grind system”

Keep:
- meaningful
- limited
- intentional

L. Add internal tagging system

Each ayah/action should have tags:
- patience
- gratitude
- prayer
- kindness
- honesty
- etc.

Used for:
- recommendations
- future personalization

M. Optional (if clean): streak logic

Track:
- consecutive days of actions completed

But:
- keep subtle
- do not pressure user

VALIDATION

1. Confirm actions appear correctly in reader.
2. Confirm action completion gives Ocean Drops.
3. Confirm daily ayah appears on home.
4. Confirm no spam/abuse possible.
5. Confirm kids version is simplified.
6. Confirm explanation system still works cleanly.
7. Confirm analyzer passes.

DELIVERABLES

- audit summary
- files added/changed
- action model design
- recommendation logic
- Ocean Drops integration details
- UI placement decisions
- fallback behavior
- analyzer results

===== END =====
