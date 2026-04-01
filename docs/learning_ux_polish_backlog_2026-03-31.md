# Learning UX Polish Backlog — 2026-03-31

## High Priority

- Add screenshot-based QA for `/learn` in light, dark, and Midnight Manuscript.
- Add a small “return to path overview” affordance on launched step destinations where safe.
- Consider one shared empty-state component for Learn path cards, Explore search, and future guided surfaces.

## Medium Priority

- Add optional scroll-to-current-step behavior after step completion on the path detail page.
- Add a lightweight “recently completed” state on `/learn` to reduce ambiguity after path completion.
- Improve Explore All with short descriptive sublabels for tools, notes, FAQ, and library routes.
- Surface a clearer distinction between “not started” and “ready to continue” for non-guided continue items.

## Low Priority

- Add richer progress analytics once completion events are more trustworthy across reused learning destinations.
- Add subtle haptics on supported platforms for step completion and full path completion.
- Introduce seasonal guided path highlighting when the content mapping is ready.

## Do Not Break

- `/learn` as the main front door
- `/quran/*` canonical ownership
- kids route family
- guided path ids and persisted progress keys
- Learn search/index metadata

## Dependencies

- Better automatic completion requires stable completion hooks from underlying route owners.
- Stronger Explore summaries depend on a clearer ownership audit for lower-priority destinations.

## Enhancement Options

- Add a “Why this path matters” line to each guided path detail page.
- Add optional estimated weekly pace text for longer paths.
- Add a family-friendly filter or audience chip to Explore All without changing route ownership.
