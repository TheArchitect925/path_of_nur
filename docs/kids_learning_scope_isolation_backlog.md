# Kids Learning Scope Isolation Backlog

## Next Safe Enhancements

- Unify fallback learner IDs across Kids Arabic, Kids Dua, Bedtime, and learner progression so single-learner households do not split progress across separate compatibility scopes.
- Migrate the remaining global `learningJourneyProgressProvider.recordActiveDay()` compatibility hook used by Kids Arabic into a learner-aware daily-activity model when the broader Journey architecture is ready.
- Audit whether any future Kids Arabic persisted child-created content, such as coloring/drawing outputs or custom review artifacts, should inherit the same learner-scoped storage pattern immediately instead of reintroducing global keys.
- Audit child-profile access to non-Learn tabs for adult-only learning shortcuts that may still deep-link into `/learn/...` and decide whether they should be hidden earlier in the originating UI.
- Review kids-facing routes under `/learn/kids/...` for parent-only surfaces such as parent dashboards/settings and gate those separately if child profiles should not see them directly.
- Reassign legacy `kids-learning` grouped knowledge items to more specific kids subcategories where helpful, so Kids Learning search/results feel cleaner and less generic.
- Add focused router tests covering child-profile redirects from adult Learn routes such as `/learn/journey-home`, `/learn/explore`, `/learn/category/foundations`, and `/learn/quizzes`.
- Add a focused provider test asserting that child profiles only receive `LearnHubCategoryId.kidsLearning` and kids-scoped knowledge items from the shared Learn providers.
- Add broader widget coverage for learner-switching on the bedtime parent dashboard and learner progression page once the shared animated page shell gets a lighter-weight test harness.
- Add an integration test that exercises Kids Arabic completion, progression ledger updates, and downstream parent/progression summaries in one end-to-end container flow.
