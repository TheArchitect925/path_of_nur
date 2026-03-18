# Router enhancement backlog

Non-blocking follow-up items after the routing hardening pass:

1. Add a small typed route helper layer for the highest-churn flows only:
   - prophets hub
   - learn quizzes hub
   - dua hub
   - growth deep links

2. Add focused tests for:
   - `/learn/hub/prophets`
   - `/learn/hub/duas`
   - `/learn/hub/quizzes`
   - `/profile/summary`
   - `/learn/quran/*` alias redirects

3. Migrate remaining string route-name usage in feature metadata to a limited set of shared constants if route churn continues.

4. Add a small deep-link markdown table if product plans to publish supported links externally.

5. Review whether `NavTab.learn` should continue opening `LearningJourneyHomePage` or whether the Learn shell should become the canonical tab root in a later product decision.
