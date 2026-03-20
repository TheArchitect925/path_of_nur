# Learning Page Restore Follow-up Backlog

Date: 2026-03-20

## Purpose

This backlog captures the next safe follow-up options after restoring the Learn landing and category flow to the earlier pre-hierarchy-rewrite version.

## Recommended next options

1. Re-link currently orphaned lesson families into the restored category flow:
   - Dua
   - World
   - Kids Dua
   - Kids Arabic
   - Baby Names

2. Audit `LearnCategoryPage` content density and remove any remaining stale chevrons or spacing drift if you want a cleaner restored surface without changing routing.

3. Decide whether `/learn/explore` and `/learn/browse` should stay dual-entry compatibility routes or whether one should become the clearly documented primary discovery route.

4. Add a targeted widget test for:
   - `LearningSectionLandingPage`
   - `LearnCategoryPage`
   - category -> filtered subcategory query flow

5. Audit glossary placement inside Learn so the route remains intentional and does not drift into another navigation regression later.
