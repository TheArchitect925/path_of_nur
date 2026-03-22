# Crossword Engine Backlog

Last updated: 2026-03-21

## Phase 7 candidates

1. Add widget tests for the crossword puzzle screen covering clue focus, hint actions, reward dedupe, daily objective rendering, and completion-state rendering.
2. Decide whether child profiles should receive a kids-only daily crossword instead of the current adult-owned daily mode remaining hidden for child profiles.
3. Add an explicit replay/reset flow for completed puzzles so "Play again" becomes a true reset rather than reopening a locked solved board.
4. Build the first second game type on top of the shared Knowledge Games layer, with word search as the strongest candidate.
5. Add a fuller daily archive/history route so users can reopen more past daily crosswords by date instead of only seeing the recent summary on home.
6. Add kids-friendly image and optional audio hint rendering once enough clue assets exist to support it consistently.
7. Expand the layout-template library beyond simple paired rows so semi-dynamic assembly can support richer overlap patterns without full procedural generation.
8. Add richer completion analytics such as solve time, hint-free completion, and streak milestones if those metrics align with the broader Journey telemetry direction.
9. Review whether crossword completion should later project into canonical ledger-backed XP and Drops summary surfaces more explicitly once the wider XP/Drops migration finishes.
10. Generalize pack/history/recommendation surfaces further if the second game type proves the shared Knowledge Games abstractions are stable.
