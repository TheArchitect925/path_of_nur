# PHASE QURAN ENRICHMENT PROMPT — REFERENCE QUALITY AUDIT + RELEVANCE HARDENING

## PRIMARY OBJECTIVE === BUILDING REFERENCE QUALITY AUDIT + RELEVANCE HARDENING

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the Qur’an ayah + surah knowledge reference enrichment pass.

Current state:
- the Qur’an reader now links ayahs and surahs to internal learning references
- this is valuable, but before expanding coverage aggressively, the system now needs **quality hardening**
- the biggest risk is not missing links
- the biggest risk is **weak, noisy, overly broad, or semantically poor matches**

This phase is an **audit and relevance hardening phase**, not a broad expansion pass.

**Critical safety rule:**  
Do not go haywire deleting the enrichment system or ripping out current links blindly.  
Do not massively expand mappings yet.  
Audit first, improve relevance quality, remove weak matches only where clearly justified, and preserve reader calmness.

## TASK TYPE

Reference quality audit, relevance refinement, semantic cleanup, and small safe UI/control improvements for Qur’an enrichment.

## PRODUCT GOAL

Make the Qur’an reader enrichment feel:
- trustworthy
- semantically correct
- curated
- useful
- calm

This phase should answer:
1. which references are strong,
2. which references are weak or noisy,
3. which categories work best,
4. where the matching logic should be tightened,
5. how to keep the “Learn more” section high-signal.
