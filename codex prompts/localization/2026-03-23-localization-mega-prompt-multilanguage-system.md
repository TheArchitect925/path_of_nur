# Phase Localization Mega Prompt — Multi-Language Translation System

PRIMARY OBJECTIVE === BUILDING A FULL MULTI-LANGUAGE LOCALIZATION SYSTEM FOR PATH OF NŪR

You are working in the existing Path of Nūr Flutter codebase.

Task type:
Multi-language ARB translation pipeline.

This is NOT a one-off translation.
This is a production-ready localization system rollout.

========================================================
CORE GOAL
========================================================

Translate a single source ARB file (`app_en.arb`) into multiple target languages:

- Urdu (app_ur.arb)
- Arabic (app_ar.arb)
- German (app_de.arb)
- Hindi (app_hi.arb)
- Turkish (app_tr.arb)
- French (app_fr.arb)
- Indonesian (app_id.arb)

Ensure:
- consistency across languages
- correct Islamic terminology
- preserved JSON structure
- placeholder safety
- mobile UX friendliness

========================================================
GLOBAL RULES (APPLY TO ALL LANGUAGES)
========================================================

1. DO NOT change keys
2. DO NOT change JSON structure
3. DO NOT remove placeholders
4. DO NOT translate variable names
5. Preserve metadata (@key) exactly
6. Ensure valid JSON output
7. Keep consistent terminology across languages
8. Maintain mobile-friendly phrasing

========================================================
PLACEHOLDER RULES (CRITICAL)
========================================================

Example:
"{count} days completed"

Must remain:
"{count} ..."

Do NOT:
- remove {}
- rename variables
- break ordering

========================================================
ISLAMIC TERMINOLOGY RULES
========================================================

Maintain correct meaning and consistency across all languages.

Key concepts:
- Qur’an
- Salah
- Dhikr
- Hadith
- Surah
- Ayah

Translate appropriately per language while preserving meaning and recognition.

========================================================
LANGUAGE-SPECIFIC RULES
========================================================

URDU:
- simple, natural Urdu
- avoid overly formal or heavy Arabic phrasing

ARABIC:
- Modern Standard Arabic
- clear and concise
- not overly classical

GERMAN:
- natural, modern German
- avoid long compound words
- optimize for UI readability

HINDI:
- simple Hindi
- avoid heavy Sanskrit
- conversational tone

TURKISH:
- modern Turkish
- short and clear
- natural phrasing

FRENCH:
- clear, modern French
- avoid overly formal constructions

INDONESIAN:
- simple Bahasa Indonesia
- friendly and natural tone

========================================================
EXECUTION STRATEGY (IMPORTANT)
========================================================

DO NOT translate all languages in one giant block.

Instead:

1. Split the input ARB into manageable chunks (e.g. 50–150 keys per batch)
2. For EACH batch:
   - translate into ALL target languages
   - maintain consistency across languages
3. Continue until full file is processed

========================================================
CONSISTENCY RULE
========================================================

If a key appears multiple times or shares meaning:
- use the SAME translation style in all languages

Example:
- “Continue” must not have 5 different meanings across languages

========================================================
OUTPUT REQUIREMENTS
========================================================

For EACH language, output a full ARB file:

- app_ur.arb
- app_ar.arb
- app_de.arb
- app_hi.arb
- app_tr.arb
- app_fr.arb
- app_id.arb

Each must:
- contain all keys
- preserve structure
- pass JSON validation

========================================================
VALIDATION BEFORE RETURN
========================================================

Before returning:

1. All keys exist in all languages
2. No missing entries
3. No extra entries
4. Placeholders intact
5. JSON valid
6. Language encoding correct

========================================================
OUTPUT FORMAT
========================================================

Return:

1. Summary:
   - total keys processed
   - languages completed
   - any inconsistencies detected

2. Then each file:

app_ur.arb
{ ... }

app_ar.arb
{ ... }

app_de.arb
{ ... }

app_hi.arb
{ ... }

app_tr.arb
{ ... }

app_fr.arb
{ ... }

app_id.arb
{ ... }

========================================================
FINAL RULE
========================================================

This must be production-ready localization.

Do not:
- break JSON
- break placeholders
- mix inconsistent terminology
- produce robotic translations

===== END =====
