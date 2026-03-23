===== PHASE 3 PROMPT — LOCALIZATION TRANSLATION SYSTEM (GERMAN) =====

PRIMARY OBJECTIVE === BUILDING HIGH-QUALITY GERMAN LOCALIZATION FOR PATH OF NŪR

You are working in the existing Path of Nūr Flutter codebase.

Task type:
Localization translation implementation (Phase 3 — German).

This must be:
- natural
- user-friendly
- app-ready German

========================================================
CORE GOAL
========================================================

Translate the English ARB file into German while ensuring:
- natural German phrasing (not literal translation)
- clean UX wording for mobile apps
- correct handling of Islamic terms
- production-ready JSON

========================================================
INPUT
========================================================

You will be given:
- app_en.arb

========================================================
OUTPUT
========================================================

You must produce:
- app_de.arb (complete German translation)

========================================================
STRICT RULES
========================================================

1. DO NOT change keys
2. DO NOT change JSON structure
3. DO NOT remove placeholders
4. DO NOT translate variable names
5. Preserve placeholders EXACTLY

========================================================
PLACEHOLDER HANDLING
========================================================

Example:

EN:
"{count} days completed"

DE:
"{count} Tage abgeschlossen"

EN:
"Level {level}"

DE:
"Level {level}"

========================================================
ISLAMIC TERMS (IMPORTANT)
========================================================

Use consistent German conventions:

- Qur’an → Koran
- Salah → Gebet (NOT “Salah” in German UI)
- Dhikr → Dhikr (keep as-is or “Gedenken” depending on context)
- Hadith → Hadith
- Surah → Sure
- Ayah → Vers

👉 Important:
- Keep Islamic authenticity
- But make it understandable for German-speaking users

========================================================
LANGUAGE STYLE RULES
========================================================

Use:
- clear, modern German
- natural phrasing (not translated word-by-word)
- short sentences

Avoid:
- overly formal/legal German
- overly literal translation
- long compound sentences
- awkward phrasing

========================================================
TONE
========================================================

Tone should be:
- clean
- calm
- simple
- app-like (not academic or religious lecture style)

========================================================
UI / UX CONSTRAINTS
========================================================

German can get long → keep it tight:

- prefer shorter alternatives
- avoid long compound words where possible
- ensure buttons remain readable

Example:
❌ "Fortschrittsverfolgungssystem"
✅ "Fortschritt verfolgen"

========================================================
QUALITY RULES
========================================================

- Maintain consistency across the app
- Do not translate the same concept differently
- Ensure it reads like native German UX copy

========================================================
OPTIONAL IMPROVEMENTS
========================================================

You may:
- simplify awkward English phrasing
- improve clarity

BUT:
- do not change meaning
- do not expand scope

========================================================
VALIDATION BEFORE RETURN
========================================================

Before returning:

1. JSON must be valid
2. All keys must match app_en.arb
3. No missing entries
4. No extra entries
5. Placeholders intact
6. German text natural and readable

========================================================
OUTPUT FORMAT
========================================================

Return:

1. Summary:
   - total keys translated
   - any special handling notes

2. Complete translated file:

app_de.arb
{
  ...
}

========================================================
FINAL RULE
========================================================

This must feel like a real German app.

Do not:
- use literal translations
- create awkward phrasing
- break placeholders or JSON

===== END =====
