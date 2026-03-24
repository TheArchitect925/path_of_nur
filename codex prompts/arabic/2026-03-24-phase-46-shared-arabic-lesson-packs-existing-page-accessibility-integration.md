# Phase 46 Prompt — Shared Arabic Lesson Packs + Existing Page Accessibility Integration

PRIMARY OBJECTIVE === BUILDING A SHARED ARABIC LESSON-PACK SYSTEM FOR FUTURE SCALING WHILE ENSURING ALL NEW LESSONS, PAGES, AND CONTENT REMAIN EASILY ACCESSIBLE THROUGH EXISTING ARABIC LEARNING SURFACES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready architecture and integration phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared beginner words and phrases foundation
- Kids Arabic learning flows
- Adult Arabic learning flows
- shared continuity/resume layer
- shared review layer
- Arabic search/filter
- Qur’an readiness bridge
- Tajweed ↔ Qur’an integration layer

DO NOT rebuild Kids Arabic, Adult Arabic, or Qur’an learning from scratch. DO NOT create isolated new content that is only reachable through brand-new obscure routes. Build safely on top of the current implementation.

CORE RULES
- Audit first before editing
- Preserve all current Arabic learning systems, routing, progress, and shared foundations
- Build one shared lesson-pack structure beneath Kids and Adults
- Ensure all new lessons/pages/content remain accessible from existing pages and existing discovery flows
- Do not flatten Kids and Adults into one generic UI
- Keep Kids simpler, more guided, and visual
- Keep Adults cleaner, easier, and more direct
- Avoid route sprawl and hidden content islands
- No destructive migrations
- Run analyzer/tests and summarize results

PHASE OBJECTIVES
1. Create a shared reusable Arabic lesson-pack system for future content expansion
2. Support lesson packs for things like letters, words, phrases, reading, review, bridge, and tajweed-support content
3. Ensure all newly added lessons/pages/content are reachable through existing Arabic learning pages and flows
4. Reduce future duplication and route fragmentation
5. Make Arabic learning scalable without becoming harder to navigate

SUCCESS CRITERIA
- there is a shared Arabic lesson-pack system
- all new lessons/pages/content are accessible through existing Arabic learning pages and flows
- no important content is stranded behind obscure routes
- Kids and Adults remain distinct in presentation
- continuity/review/search integrate cleanly with the new pack system
- no regressions are introduced into tracing, reading, review, audio, routing, or shared foundations
- Arabic learning becomes easier to scale without becoming harder to navigate
