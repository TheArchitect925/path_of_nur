# Final Learn Launch Checklist

Date: 2026-03-31

## Route checks

- Verify `/learn` opens `LearningSectionLandingPage`
- Verify `/learn/explore` and `/learn/browse` stay aligned
- Verify `/learn/legacy` still opens safely as a compatibility surface
- Verify key compatibility aliases redirect without loops
- Verify `/learn/paths/:pathId` opens for all shipped guided paths

## Path checks

- Start, resume, and complete each guided path
- Verify next-step highlighting and progress bar behavior
- Verify path-completion enrichment appears only on completed paths
- Verify no path ends in a dead end

## Kids checks

- Verify Kids Starter Path only appears for child profile in path grids
- Verify kids discovery remains visible from general `/learn`
- Verify kids step targets stay inside kids-owned routes where intended

## Qur'an handoff checks

- Verify Qur'an Beginner Path opens the soft bridge first
- Verify bridge hands off into canonical `/quran/*`
- Verify search results for Qur'an open canonical destinations

## Search checks

- Search `how to pray`
- Search `start quran`
- Search `daily dhikr`
- Search `kids arabic letters`
- Search `prophets stories`
- Verify grouped results do not repeat the same item

## Personalization checks

- Verify active guided path is prioritized
- Verify new learner fallback recommends Foundations
- Verify child profile recommends Kids Starter
- Verify a strong Qur'an signal can recommend Qur'an Beginner

## Analytics checks

- Verify landing view logs
- Verify guided path start/resume/complete logs
- Verify search open/query/result-open logs
- Verify compatibility alias hits are still measurable

## Milestone checks

- Verify first path started milestone
- Verify first step completed milestone
- Verify first path completed milestone
- Verify pending milestone can be acknowledged
- Verify memory cards render calmly on `/learn`

## Localization checks

- Verify no new hardcoded strings from this pass
- Verify key Learn surfaces still load localized strings correctly

## Performance / manual QA checks

- Verify `/learn` scroll remains smooth
- Verify Explore filtering remains responsive
- Verify large text does not collapse key actions
- Verify child/adult profile switching does not leave stale Learn surfaces visible
