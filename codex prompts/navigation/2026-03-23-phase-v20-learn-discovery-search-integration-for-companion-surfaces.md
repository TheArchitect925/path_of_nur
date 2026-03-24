# ===== PHASE V20 PROMPT — LEARN DISCOVERY + SEARCH INTEGRATION FOR COMPANION SURFACES =====

## PRIMARY OBJECTIVE === BUILDING LEARN DISCOVERY + SEARCH INTEGRATION FOR COMPANION SURFACES

You are working in the existing Flutter codebase for Path of Nūr.

Goal:
Improve discoverability of the new companion surfaces inside Learn and any existing in-app search/discovery systems.

Critical safety rule:
Do not redesign Learn IA broadly.
Do not flood search/discovery with low-signal entries.
Build on top of current taxonomy and discovery patterns.

Task type:
Discoverability + taxonomy/search refinement.

Implement:
1. Audit how /learn/seerah, /learn/character, and /learn/daily-wisdom currently appear in:
   - Learn taxonomy
   - category pages
   - explore/discovery surfaces
   - any in-app search/index layer if available
2. Improve their discoverability in the most natural category placements.
3. Add or refine search keywords / discovery metadata if such structures already exist.
4. Improve card copy/subtitles so users understand what each surface offers.
5. Do not create noisy duplicate entries.
6. Add/update tests for taxonomy/discovery routing if needed.
7. Run analyzer and relevant tests.

Deliverables:
- discovery audit findings
- discoverability improvements
- files changed
- tests run
- analyzer result
- remaining discovery gaps
