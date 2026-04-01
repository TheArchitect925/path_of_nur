# Personalization Backlog

Date: 2026-03-31

## Enhancement options

### High value / low risk

- Add a dedicated Stories starter path so story interest stops mapping through broader Character/Qur'an fallbacks.
- Add a lightweight Games follow-up recommendation lane that points into existing quiz/challenge owners without creating a second games system.
- Add a short “Why this next?” expandable explanation on the personalized card for users who want more clarity.
- Add a small “Not now” dismissal memory so the same recommendation can cool down briefly without losing path progress.

### Medium value

- Derive stronger domain intent from more recent route visits where stable route metadata already exists.
- Add Ramadan-specific sequencing rules if the repo's seasonal infrastructure becomes richer and stable enough.
- Add a soft “return after inactivity” mini-stack with 1-step re-entry suggestions instead of only a path-level suggestion.
- Add path difficulty/depth metadata so recommendations can distinguish beginner vs deeper follow-up.

### Longer-term

- Multi-profile / family-aware recommendation tuning.
- More nuanced sequencing graphs with branch confidence.
- Recommendation tuning backed by safe analytics review.
- Optional AI-assisted recommendation experimentation only after deterministic rule coverage is strong and product explicitly requests it.

## Dependencies

- richer stable learn-domain signals
- more starter paths beyond the current six
- stronger seasonal/context infrastructure if Ramadan/Friday logic expands
- more trustworthy route-level completion hooks

## Do-not-break notes

- keep `/quran/*` canonical
- keep kids route family preserved
- do not create a second recommendation or progress ledger
- keep search/indexing additive only
- preserve guided path step ids and route targets unless compatibility handling exists

## Recommended next order

1. Add one or two richer starter paths for Stories and Games
2. Add optional recommendation cool-down / dismissal memory
3. Improve inactivity recovery suggestions
4. Expand seasonal/context logic only if stable infrastructure already exists
5. Revisit adaptive sequencing after more path coverage exists
