# tvOS Master Phase Index

Date: 2026-03-25

Canonical execution order for future tvOS implementation prompts:

1. Phase 1 — tvOS product audit and architecture foundation
2. Phase 2 — shared design system and Path of Nūr tvOS look and feel
3. Phase 3 — app shell, navigation, focus engine, and route structure
4. Phase 4 — shared domain and content parity layer
5. Phase 21 — shared feature flag and parity system for future releases
6. Phase 22 — shared content registry and modular section onboarding
7. Phase 5 — tvOS home screen and continue your journey
8. Phase 6 — Qur’an browse and reading experience for tvOS
9. Phase 7 — Qur’an audio playback and full-screen listening mode
10. Phase 10 — learn hub master layout
11. Phase 11 — stories, prophets, and reflection content
12. Phase 15 — signs, creation, and visual learning experiences
13. Phase 8 — prayer section for tvOS
14. Phase 9 — dhikr and guided remembrance mode
15. Phase 12 — kids mode and family-safe TV learning
16. Phase 13 — Arabic letters and beginner learning on TV
17. Phase 14 — quizzes, games, and remote-friendly interactivity
18. Phase 16 — favorites, playlists, saved items, and watch-later flow
19. Phase 17 — localization, readability, and accessibility for television
20. Phase 18 — offline content, caching, and sync-aware behavior
21. Phase 19 — profiles, household usage, and session continuity
22. Phase 20 — settings and tvOS-specific preferences
23. Phase 24 — analytics, crash safety, and quality guardrails
24. Phase 25 — test suite, focus navigation QA, and regression harness
25. Phase 26 — performance optimization for large-screen media surfaces
26. Phase 23 — tvOS update pipeline and release governance
27. Phase 27 — launch polish, empty states, and production release readiness

## Operating rules

- Phases should be implemented in this order unless an explicit dependency requires a small inversion.
- Shared logic, content ownership, localization, and playback rules should be reused before adding tvOS-specific duplicates.
- Any shared refactor must preserve existing iOS behavior.
- tvOS UX should prefer remote-first adaptation over touch-first parity.
- Each phase should end in a stable, testable state.
