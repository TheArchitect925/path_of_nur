===== PHASE 5 PROMPT — QUR’AN HOME IA CLEANUP, SEARCH EXPANSION, AND NOTES CONSISTENCY =====

PRIMARY OBJECTIVE === BUILDING QUR’AN HOME INFORMATION ARCHITECTURE CLEANUP, EXPANDED SEARCH, AND NOTES CONSISTENCY

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement. DO NOT rebuild. DO NOT delete working logic or user data. Build on top.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Do not delete or overwrite user notes, bookmarks, or progress
- Preserve offline-first behavior
- Do not break existing navigation or resume logic
- Keep scope limited to this phase
- No unnecessary refactors outside this scope

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Remove top Qur’an quote from Qur’an home (Daily Ayah Reflection already exists)

2. Expand Qur’an search so it searches:
   - ayah Arabic text
   - translation text
   - transliteration text
   - surah names

3. Audit Add Notes across the entire app and standardize behavior

4. Auto-enrich Qur’an notes:
   - Category = Quran
   - Add useful tags (Surah name, Ayah reference, Quran)
   - Preserve source context (surah, ayah)

5. Reorder Qur’an home:
   - Search (top)
   - Read Qur’an (under search)
   - Continue (under Read)
   - Remove Continue Learning from this page

6. Move Continue Learning:
   - into Qur’an Learning (Learning Hub)
   - preserve progress and routing

7. Enforce structure:
   - Qur’an page = reading/listening only
   - Learning content = Learning Hub only

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit current implementation:

Qur’an Page:
- Where quote is rendered
- Current layout order
- Placement of Search, Read, Continue, Continue Learning

Search:
- What fields are currently indexed
- Whether ayah, translation, transliteration exist locally

Notes:
- All note entry points across app
- Category/tag behavior
- Source awareness (is context preserved?)

--------------------------------------------------
B. REMOVE TOP QUR’AN QUOTE
--------------------------------------------------

- Remove quote ONLY from Qur’an page
- Do NOT affect other pages using the same component
- Clean up layout spacing

--------------------------------------------------
C. REORDER QUR’AN HOME
--------------------------------------------------

Final order must be:

1. Search
2. Read Qur’an
3. Continue (under Read)
4. Other reading-related items only

- Remove Continue Learning from Qur’an page

--------------------------------------------------
D. MOVE CONTINUE LEARNING
--------------------------------------------------

- Move to Qur’an Learning page (Learning Hub)
- Preserve state and progress
- Ensure routing still works

--------------------------------------------------
E. EXPAND SEARCH
--------------------------------------------------

Search must match:

- Surah names
- Ayah Arabic text
- Translation text
- Transliteration text

Requirements:
- Must work offline
- Must be performant
- No UI freezing
- Avoid duplicate/noisy results

Optional grouping:
- Surahs
- Ayahs

--------------------------------------------------
F. NOTES SYSTEM AUDIT + IMPROVEMENT
--------------------------------------------------

Audit all note entry points and standardize:

- UI consistency
- Category behavior
- Tag usage
- Source-awareness

Do NOT rebuild system — improve consistency only

--------------------------------------------------
G. AUTO-ENRICH QUR’AN NOTES
--------------------------------------------------

When creating a note from an ayah:

Automatically apply:
- Category: Quran
- Tags:
  - Quran
  - Surah name
  - Ayah reference (e.g. 2:255)

Attach source metadata if supported:
- surah number
- ayah number
- reference string

Rules:
- No duplicate tags
- No tag spam
- Metadata must remain editable
- Old notes must remain unchanged

--------------------------------------------------
H. SAFE DATA HANDLING
--------------------------------------------------

- No destructive migrations
- Existing notes must remain valid
- Do not overwrite existing metadata
- Only enrich new notes

--------------------------------------------------
I. TESTING
--------------------------------------------------

Add/update tests for:

- Qur’an home layout order
- Continue Learning removed from Qur’an page
- Continue Learning present in Learning page
- Search matching ayah/translation/transliteration
- Qur’an note enrichment
- No duplicate note creation

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Qur’an page changes summary
3. Search upgrade explanation
4. Notes audit summary
5. Data safety explanation
6. Test results
7. FINAL AUDIT:
   - what was done
   - what remains
   - any regressions fixed
   - any technical debt left

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Quote removed
- Search expanded
- Layout fixed
- Continue Learning moved correctly
- Notes enriched automatically
- No data loss
- No regression in reading/playback

--------------------------------------------------

“Read in the name of your Lord who created.” — Qur’an 96:1

===== END PHASE 5 PROMPT =====
