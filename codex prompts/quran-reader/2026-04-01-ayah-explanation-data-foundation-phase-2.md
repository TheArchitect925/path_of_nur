# ===== PHASE X PROMPT phase 2 — AYAH EXPLANATION DATA FOUNDATION + SEEDED CONTENT =====

PRIMARY OBJECTIVE === BUILDING AYAH EXPLANATION SYSTEM DATA FOUNDATION

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
Production-ready domain/data implementation for ayah explanations.

GOAL
Build the explanation data layer used by the Qur’an reader:
- models
- repository
- providers
- seeded dataset
- fallback logic

EXECUTION RULES
1. Audit existing data architecture first.
2. Reuse repository/provider patterns.
3. Keep explanation system separate from insights/themes.
4. Preserve localization readiness.
5. Use local-first data (no network dependency).
6. Seed high-quality initial content (NOT placeholders).
7. Ensure graceful fallback for missing ayahs.
8. Run analyzer and summarize.

AUDIT REQUIREMENTS

A. Identify:
- where Qur’an data is loaded
- repository patterns
- provider patterns
- enrichment/insight systems (keep separate)

IMPLEMENTATION REQUIREMENTS

B. Add explanation detail enum:
- off
- simple
- standard
- deep
- kids

C. Add domain model:
QuranAyahExplanation:
- surahNumber
- ayahNumber
- simpleSummary
- standardExplanation
- deepExplanation
- kidsExplanation
- keyLessons
- reflectionPrompt
- sourceRefs

D. Add repository:
- fetch by surah + ayah
- optional fetch by surah
- safe fallback if missing

E. Add provider layer:
- explanation lookup
- explanation detail setting

F. Add settings integration:
- persist explanation detail level
- integrate with existing reader settings

G. Seed initial dataset (REQUIRED):

Include:
- Surah Al-Fatihah (full)
- Ayat al-Kursi (2:255)
- Last 10 surahs (full)

Each ayah must include:
- simpleSummary
- standardExplanation
- kidsExplanation

Deep explanation:
- include where possible
- fallback to standard if missing

H. Content rules:

Simple:
- 1–2 sentences
- beginner-friendly

Standard:
- clear explanation
- meaning + takeaway

Kids:
- very simple
- one core idea
- warm tone

I. Fallback logic:

simple → standard
standard → simple
deep → standard → simple
kids → simple → standard

Never crash
Never return empty UI data

J. Data structure:

Organize cleanly:
- grouped by surah or juz
- easy to extend

K. Attribution strategy:
- do NOT expose raw tafsir
- store internal source references only
- prepare for future attribution UI

L. Safety:
- do not modify playback, memorization, or reader logic
- do not break existing systems

VALIDATION
1. Explanation data loads correctly
2. Fallback works
3. Settings persist
4. No regressions
5. Analyzer passes

DELIVERABLES
- audit summary
- files created/changed
- data structure
- seeded ayahs list
- fallback logic
- analyzer results

===== END =====
