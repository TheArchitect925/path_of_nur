Phase 14 prompt archive: Game Variations System

Implemented as an additive offline-first extension over the existing Knowledge Games Engine.

Shipped scope:
- shared variation config and handler abstractions
- deterministic daily variation assignment
- shared variation badges and timed shell UI
- low-risk per-game hooks:
  - crossword: no clue, sequential guidance, timed bonus
  - word search: memory/fog/sequential support, timed bonus
  - matching: reverse + memory support, timed bonus
  - ayah completion: audio/challenge/sequential support, bonus handling
  - hadith reflection: reflection/challenge support, bonus handling

Deferred:
- deeper non-daily variation browsing
- richer fog rendering
- stronger pack-level variation discovery
- broader widget interaction coverage
