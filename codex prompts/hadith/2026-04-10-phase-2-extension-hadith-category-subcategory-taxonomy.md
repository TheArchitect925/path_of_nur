===== PHASE 2 EXTENSION — ADD CANONICAL HADITH CATEGORY / SUBCATEGORY TAXONOMY =====

PRIMARY OBJECTIVE === MAKE HADITH ENTRIES CANONICALLY CATEGORIZED WITH CATEGORY + SUBCATEGORY STRUCTURE, SIMILAR IN SPIRIT TO THE DUA DOMAIN, SO THEY CAN SUPPORT SEARCH, THEMES, TOPICS, AND CROSS-DOMAIN DISCOVERY CLEANLY

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task extending the current Hadith normalization phase.
Do not redesign the app yet.
Do not build Hadith search yet.
Do not guess. Use the actual repo ownership already established for the Hadith foundation.

CONTEXT
We are normalizing the Hadith foundation model before building search and reader parity.

A key missing piece is canonical categorization.

Hadith entries should not rely only on loose editorial tags.
They need a structured taxonomy similar in spirit to the Dua domain, so they can later support:
- browse
- search
- filtering
- themes
- topics
- lesson grouping
- cross-links to Qur’an / Duas / Learn content

GOAL
Add a canonical Hadith category / subcategory taxonomy to the Hadith foundation layer and apply it to the active Hadith foundation content path.

IMPORTANT PRODUCT RULES
- Category/subcategory should become part of the canonical Hadith metadata foundation.
- This is not the same thing as themes, tags, or lessons.
- Keep these layers distinct:
  - Category/Subcategory = canonical information architecture
  - Theme/Topic = discovery/editorial grouping
  - Tags = supporting metadata
  - Lessons = educational takeaway metadata

IMPLEMENT THE FOLLOWING

A. ADD CANONICAL CATEGORY / SUBCATEGORY FIELDS
- Extend the canonical Hadith foundation model with structured fields for:
  - category id
  - category title/display label
  - subcategory id
  - subcategory title/display label
- Keep normalized ids separate from display labels where practical.

B. DEFINE A CLEAN HADITH TAXONOMY LAYER
- Create a canonical taxonomy definition for Hadith categories and subcategories.
- Use repo-grounded, app-appropriate structure.
- Keep the taxonomy clean, not overly granular for V1.
- Example broad categories may include:
  - Faith
  - Worship
  - Character
  - Family
  - Knowledge
  - Manners
  - Repentance
  - Gratitude
  - Patience
  - Hereafter
- Subcategories should sit meaningfully under these.

C. MAP EXISTING HADITH FOUNDATION CONTENT
- Apply category/subcategory assignments to the active Hadith foundation content path.
- Reuse existing theme/tag/lesson metadata where helpful, but do not let loose tags become the canonical taxonomy automatically without review.
- Keep mappings deterministic and maintainable.

D. KEEP TAXONOMY DISTINCT FROM THEMES / TAGS / LESSONS
- Do not collapse category/subcategory into theme ids or tag lists.
- Keep clear separation in the model and repository helpers.
- Preserve existing tags/themes/lessons, but position category/subcategory as the canonical browse/search structure.

E. PREPARE FOR FUTURE SEARCH / DISCOVERY
- Add repository/model helpers that make it easy later to:
  - browse by category
  - browse by subcategory
  - filter search by category/subcategory
  - connect Hadiths to other Learn domains by topic/category
- Do not build the full search UI yet.

F. KEEP TRUST RULES COMPATIBLE
- Ensure the verified-only public surfacing rules from Phase 1 still hold.
- Do not broaden public surfacing accidentally.

G. PRESERVE CURRENT FLOWS
- Keep existing routes and current public Hadith flows working.
- Do not break daily Hadith, saved Hadith, kids Hadith, Hadith Reflection, or route names.

H. ADD TEST COVERAGE
Add or update focused tests for:
- category/subcategory metadata exists on public Hadith entries
- taxonomy ids are stable and deterministic
- category/subcategory logic does not break verified-only surfacing
- existing Hadith repository/public provider paths remain valid

I. DO NOT BREAK
- canonical public Hadith owner
- verified-only public surfacing
- route names
- persistence keys
- editorial override path
- kids Hadith / Hadith Reflection flows
- localization

J. KEEP THE CHANGESET TIGHT
- Focus only on canonical category/subcategory taxonomy at the foundation layer.
- Do not build the full browse/search UI in this pass.
- Do not redesign the Hadith reader yet.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What category/subcategory structure was added
4. How existing Hadith entries were mapped
5. How taxonomy remains distinct from themes/tags/lessons
6. Validation notes
7. Analyzer results
8. Test results
9. Any follow-up notes for Hadith reader parity and future search

At the very end, explicitly confirm:
- Hadith entries now have canonical category/subcategory metadata
- verified-only public surfacing still holds
- current routes and flows remain intact

===== END =====
