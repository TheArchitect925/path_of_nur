===== PHASE 16 PROMPT — KIDS HADITH STORIES, KIDS QUR’AN & HADITH ACCESS, AND FAQ QURANIC QUOTE CLEANUP =====

PRIMARY OBJECTIVE === BUILDING KIDS HADITH STORIES, KIDS QUR’AN AND HADITH EXPERIENCES, AND CLEANING FAQ QURANIC QUOTE DUPLICATION

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement. DO NOT rebuild systems. DO NOT delete content or user data. Build safely on top of existing Qur’an, Hadith, Kids Learning, and FAQ systems.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all Qur’an, Hadith, Kids, Notes, and FAQ functionality
- Do not break routing or user progress
- Reuse existing data and systems wherever possible
- No destructive migrations
- Keep UX clean, simple, and kid-friendly
- No placeholder content
- At the end, provide audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create Kids Hadith Stories from suitable hadiths
2. Add Qur’an for Kids (full browsing, simplified)
3. Add Hadith for Kids (short curated hadith only)
4. Add islands for both under Kids Learning
5. Link everything correctly
6. Remove duplicate Qur’anic verse from FAQ

--------------------------------------------------
A. AUDIT
--------------------------------------------------

Audit:
- hadith datasets
- kids stories system
- kids learning islands
- quran reader
- faq page
- global quote component

Identify:
- suitable hadiths for kids stories
- existing routing gaps
- faq duplicate quote source

--------------------------------------------------
B. CREATE KIDS HADITH STORIES
--------------------------------------------------

- select only meaningful hadiths
- convert into children-friendly stories
- preserve meaning
- no fabrication
- attach source reference

--------------------------------------------------
C. CREATE QUR’AN FOR KIDS
--------------------------------------------------

Create KidsQuranPage

Requirements:
- full surah list (reuse existing data)
- simplified UI
- each ayah shows:
  - Arabic
  - translation
  - optional transliteration
- reuse audio if safe

Remove:
- advanced controls
- heavy settings
- memorization complexity

--------------------------------------------------
D. CREATE HADITH FOR KIDS
--------------------------------------------------

Create KidsHadithPage

Requirements:
- only short hadith
- curated list (not full dataset)
- simple grouping (optional)

Also include:
- link to Hadith Stories

--------------------------------------------------
E. ADD KIDS LEARNING ISLANDS
--------------------------------------------------

Add:
- Qur’an for Kids
- Hadith for Kids

Ensure:
- consistent island design
- correct placement
- no clutter

--------------------------------------------------
F. ROUTING
--------------------------------------------------

Ensure:
- Kids → Qur’an for Kids → KidsQuranPage
- Kids → Hadith for Kids → KidsHadithPage
- Kids → Hadith Stories → correct story list

Do NOT route to adult pages

--------------------------------------------------
G. FAQ CLEANUP
--------------------------------------------------

- remove duplicate Qur’anic quote
- keep global quote only
- fix layout spacing

--------------------------------------------------
H. DATA SAFETY
--------------------------------------------------

Preserve:
- all hadith data
- quran data
- kids stories
- user progress
- notes/bookmarks

No data loss

--------------------------------------------------
I. TESTING
--------------------------------------------------

Test:
- islands appear
- routing is correct
- kids pages load correctly
- faq shows only one quote
- no broken routes

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Kids Qur’an summary
4. Kids Hadith summary
5. Kids Hadith Stories summary
6. Routing summary
7. FAQ cleanup summary
8. Data safety summary
9. Validation results
10. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids Qur’an allows full browsing (simplified)
- Kids Hadith shows short curated hadith
- Hadith Stories are created and linked
- Kids Learning islands are complete
- FAQ duplicate quote removed
- No broken routes
- No data loss

--------------------------------------------------

“And We have made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 16 PROMPT =====
