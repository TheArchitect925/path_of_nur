# Learn Route Alias Cleanup Backlog

Last updated: 2026-03-21

Enhancement options:

- verify whether `/learn/journey-home` still needs to remain a first-class public route once the Learning Journey island hub fully replaces it
- audit `learnLegacy` usages in `LearningJourneyRegistry`, `LearnCategoryCatalog`, and older browse surfaces, then replace only the ones that now have real route-specific destinations
- migrate remaining Learn-owned Qur'an alias route-name usage to canonical `/quran*` navigation after verifying desired tab-stack behavior
- document canonical route-name usage, not only canonical path usage, for the most common Learn destinations
- add a small router smoke test covering canonical-to-alias expectations for `/learn/explore`, `/learn/prophets`, `/learn/quizzes`, and `/learn/duas`
