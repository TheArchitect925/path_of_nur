# Quran reader - ayah by ayah explanation ===== PHASE X PROMPT phase 1 — AYAH EXPLANATION SYSTEM AUDIT + READER INTEGRATION =====

PRIMARY OBJECTIVE === BUILDING AYAH EXPLANATION SYSTEM

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

At the very end, audit everything and provide one full summary.

TASK TYPE
Audit-first architecture and implementation plan, then safe production-ready implementation.

GOAL
Build an ayah-by-ayah explanation system that integrates into:
1. the existing main Qur’an reader
2. the existing kids Qur’an reader

The system must:
- preserve the existing reader architecture
- reuse the current reading modes system
- add explanation depth selection
- allow different levels of explanation detail
- support a simplified kids/new Muslim explanation mode
- remain localization-ready
- remain route-safe and state-safe
- avoid breaking playback, memorization, or current study features

IMPORTANT PRODUCT DIRECTION
This must NOT become a separate disconnected tafsir page.
This should become a native layer inside the current Qur’an reader experience.

High-level design:
- Keep existing reader modes
- Add a separate explanation detail preference
- Render ayah explanation inline or as an expandable section within the reader
- Add a kids-safe explanation mode in the kids Qur’an reader

EXECUTION RULES
1. Audit first before editing.
2. Confirm all current owners of:
   - reader modes
   - reader settings
   - learn more / insights blocks
   - kids Qur’an reader flow
3. Do not break existing routing, playback, bookmarks, notes, memorization, or reader settings.
4. Reuse existing Riverpod/local store patterns.
5. Preserve localization discipline. No hardcoded user-facing strings unless adding temporary internal dev-only labels that are later localized in the same pass.
6. Keep the implementation production ready and maintainable.
7. Run analyzer on changed files and summarize results.
8. At the end provide a full audit summary and implementation summary.

AUDIT REQUIREMENTS

A. Audit current main reader logic
Find and confirm:
- how QuranReaderStudyMode is defined and used
- how reader settings are persisted
- where mode switching is handled
- where “Learn More”, contextual links, insights, and themed content are rendered
- whether there is already any explanation-like content pipeline that can be reused

B. Audit current kids Qur’an reader logic
Find:
- the canonical kids Qur’an reader page / route / widgets
- whether it already has its own data source or is reusing the standard reader pipeline
- what UI area is safest for a kids explanation section
- whether the kids reader already has mode/settings state
- whether the kids reader should reuse the same provider with a separate detail mode, or have a separate kids wrapper provider

C. Identify architecture owners
List exact file owners for:
- reader modes
- reader settings
- ayah content loading
- learn more / ayah enrichment / insights
- kids Qur’an reader
- local persistence keys
- route query parameter handling for reader mode

D. Decide implementation path
Before editing, choose the safest path and state it in the audit summary:
- extend existing study mode enum directly
OR
- keep study mode as-is and add a second enum for explanation detail

Preferred default:
keep study mode as-is and add a separate explanation detail enum unless the codebase clearly proves otherwise.

IMPLEMENTATION REQUIREMENTS

E. Add explanation detail system
Introduce a new enum such as:
- off
- simple
- standard
- deep
- kids

Do NOT overload the existing study mode enum with explanation depth.

Add persistent reader preference(s) in the same style as current reader settings persistence.

Suggested shape:
- explanation enabled / disabled OR off as enum value
- explanation detail level
- optionally auto-expand explanations in certain modes

F. Add structured explanation domain model
Introduce a reusable ayah explanation model that supports:
- surahNumber
- ayahNumber
- simpleSummary
- standardExplanation
- deepExplanation
- kidsExplanation
- optional keyLessons
- optional reflectionPrompt
- optional sourceRefs / attribution metadata

Keep naming clean and future-proof.

G. Add explanation repository/provider layer
Create a repository/provider path for ayah explanations.

Requirements:
- must be able to return ayah explanations by surah + ayah
- should be safe to start with a partial curated dataset
- should support future scaling to all ayahs
- should not block the rest of the reader if explanation data is unavailable

If needed, start with:
- Al-Fatihah
- Ayat al-Kursi
- last 10 surahs
- selected foundational ayahs for beginners

Structure the data so it can scale cleanly later.

H. Integrate into main Qur’an reader
Add an explanation option into the existing reader settings / study tools area.

User should be able to:
- turn explanations off
- choose detail level
- keep existing reader modes unchanged

Render explanation in the reader itself.
Preferred behavior:
- Reading mode: compact / collapsed by default
- Reflection mode: explanation + reflection prompt emphasized
- Study mode: fuller explanation and deeper content
- Memorization mode: explanation minimized or optional
- Theme mode: explanation can coexist with theme links

Do not make the page cluttered.
Keep the section visually calm and aligned with the current Path of Nūr reader style.

I. Integrate into kids Qur’an reader
In the kids Qur’an reader:
- add a kids-safe explanation option
- default it to kids mode if appropriate
- keep the content short, warm, beginner-friendly, and non-technical
- avoid dense scholarly terminology
- keep UI simpler than the adult reader

Kids explanation should focus on:
- what Allah is teaching
- one simple takeaway
- one gentle action or moral if helpful

J. Explanation selection logic
Implement logic so rendering picks the right explanation body based on selected detail level:
- off => hide section
- simple => simpleSummary
- standard => standardExplanation
- deep => deepExplanation
- kids => kidsExplanation

If a requested level is missing for a given ayah:
- fall back gracefully in this order:
  kids -> simple -> standard
  deep -> standard -> simple
- never crash
- never show empty broken cards

K. UI requirements
Keep the UI uncluttered.

Main reader:
- compact explanation card or section
- expandable if needed
- clear label
- optionally show source badge / “based on tafsir” line later if data exists

Kids reader:
- softer, simpler container
- large readable text
- one idea at a time
- no dense metadata

L. Localization
All new user-facing labels must be localized.
Add ARB keys and wire them correctly.

M. Data seed strategy
Seed a production-quality initial dataset for a controlled rollout.
Do NOT generate placeholder nonsense.
Use carefully written, calm, simple content for the initial ayahs.

N. Safety / integrity
Do not remove or regress:
- playback controls
- follow ayah behavior
- bookmarks
- notes
- memorization mode
- existing insights / contextual chips
- route handling
- existing settings persistence

O. Cleanup
Remove dead or duplicate explanation placeholder logic if found.
Keep ownership clean.

VALIDATION
1. Confirm existing reader modes still work.
2. Confirm explanation detail preference persists.
3. Confirm main reader shows the correct explanation level.
4. Confirm kids reader shows kids-safe explanation content.
5. Confirm explanation fallback logic works.
6. Confirm existing playback and memorization flows still work.
7. Confirm analyzer passes on changed files.

DELIVERABLES
After implementation, provide:
- audit summary
- files changed
- architecture decision and why
- where explanation settings are stored
- where explanation data is stored
- how main reader integration works
- how kids reader integration works
- which ayahs were included in the initial rollout
- analyzer results
- follow-up recommendations for scaling to full Qur’an coverage

===== END =====
