# Learn Missing Content Audit Backlog

Date: 2026-03-20

## Immediate follow-up options

1. Restore subcategory cards to use each subcategory's real `routeTarget` instead of local `?sub=` filtering when that subcategory owns a dedicated page or hub.

2. Keep local filtered category lists only for subcategories that actually have indexed `LearnHubKnowledgeItem` entries.

3. Add a small compatibility rule for empty subcategory filters:
   - if a selected subcategory has zero indexed items, open its dedicated destination instead of showing an empty state.

4. Done: re-indexed missing lesson families into the shared Learn knowledge index:
   - Dua
   - World
   - Kids Arabic lessons
   - Kids stories
   - Kids salah
   - Islamic trivia challenge content

5. Done: promoted secondary discovery hubs into first-class Learn indexing:
   - Kids Dua category pages
   - Kids stories hub and browse page
   - Kids Arabic review
   - Kids Arabic rewards
   - Trivia knowledge paths hub
   - World creation category pages
   - Baby Names home

6. Done: separated journey-managed subcategories from standard Learn discovery lists:
   - journey-backed subcategory cards still appear in Learn categories
   - their detail content no longer appears in regular Learn search/suggested/category lists
   - they now hand off to Journey routes directly so Journeys can be architected separately later

7. Add a focused widget test matrix for `LearnCategoryPage` covering:
   - subcategory with indexed items
   - subcategory with zero indexed items
   - self-loop subcategory
   - dedicated-route subcategory

8. Next safe indexing options:
   - index `kids-learning` starter duas directly, not only categories, stories, and My Day-linked entries
   - index `search-tools` utility items separately so Tools & Explore is fully populated
   - decide whether Islamic trivia path items should also appear under `worship-practice -> islamic-trivia` or remain challenge-only under Quizzes & Challenges
   - decide whether parent dashboards/settings should remain hub-only or be intentionally surfaced under Kids tools
