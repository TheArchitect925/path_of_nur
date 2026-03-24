# Sister Logo Fix Backlog

1. Add a small widget regression test around the home greeting block once that section is easier to pump in isolation, so future asset-path edits cannot quietly break the profile logo again.
2. If more profile-specific imagery is added later, move all profile/avatar asset selection through the same shared resolver instead of reintroducing page-local path strings.
