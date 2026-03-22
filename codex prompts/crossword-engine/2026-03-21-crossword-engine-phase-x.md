# Crossword Puzzle Engine Prompt

Date: 2026-03-21
Feature Area: crossword-engine

## User Prompt

You are working in the existing Flutter codebase for “Path of Nūr”.

==================================================
PRIMARY OBJECTIVE
==================================================

Build a reusable, scalable, offline-first Crossword Puzzle Engine inside Path of Nūr.

This engine must:
- Support Kids and Adult crossword experiences
- Reuse existing knowledge/content across the app
- Integrate with XP, Levels, Streaks, and Ocean Drops systems
- Follow the app’s global theme, UI system, and architecture
- Be extensible into a broader “Knowledge Games Engine”

This is NOT a standalone feature.
This must feel like a native, deeply integrated part of the app.

==================================================
GLOBAL APP CONSISTENCY (MANDATORY)
==================================================

The implementation MUST:
- Use existing global theme system (colors, typography, spacing)
- Use existing shared components (cards, surfaces, layout shells)
- Follow existing navigation patterns
- Respect localization system
- Reuse reward, XP, drops, and streak systems
- Match animation style and interaction patterns already used in the app

DO NOT:
- introduce new visual styles
- create isolated UI patterns
- break consistency with existing pages

Everything must feel like it was always part of Path of Nūr.

==================================================
TASK TYPE
==================================================

Design and implement a Crossword Engine + UI system.

==================================================
EXECUTION RULES
==================================================

1. Audit first before editing anything.
2. Reuse existing systems wherever possible.
3. Keep V1 simple, stable, and extensible.
4. Use local seeded data (offline-first).
5. Avoid over-engineering procedural generation in V1.
6. Keep architecture modular and future-ready.
7. Run analyzer and report results.

==================================================
A. AUDIT PHASE (MANDATORY FIRST STEP)
==================================================

Audit the repository and identify:

- Existing quiz systems
- Learning challenges
- Kids learning components
- Reward / XP hooks
- Ocean Drops logic
- Streak systems
- Daily challenge systems
- Shared grid / tile UI components
- Navigation and layout shells
- Existing datasets (Qur’an, Hadith, Duas, Prophets, etc.)

Determine:
- What can be reused
- What should be extended
- What should NOT be duplicated

Base all implementation decisions on this audit.

==================================================
B. CONTENT INTEGRATION (CRITICAL)
==================================================

The crossword engine must reuse existing knowledge.

Pull content from:
- Qur’an learning
- Hadith dataset
- Prophets
- Duas
- Arabic letters (kids)
- Learning Hub categories
- Worship / Adab / Character content

DO NOT create a disconnected dataset.

Create a normalized crossword entry structure:

class CrosswordEntry {
  final String id;
  final String mode; // kids / adult / daily
  final String category;
  final int difficulty;
  final String clue;
  final String answer;
  final String? hint;
  final String? imageKey;   // kids mode
  final String? audioKey;   // kids mode
  final String sourceType;
  final List<String> tags;
}

==================================================
C. CORE ENGINE STRUCTURE
==================================================

Implement core models:

class CrosswordPuzzle {
  final String id;
  final int difficulty;
  final int gridSize;
  final List<CrosswordClue> clues;
  final List<List<String>> solutionGrid;
}

class CrosswordClue {
  final String clue;
  final String answer;
  final int row;
  final int col;
  final bool isAcross;
}

==================================================
D. MODES TO IMPLEMENT
==================================================

1. KIDS MODE
- Small grids (3x3, 4x4)
- Visual clues (images optional)
- Tap-to-fill interaction
- Simple words (ALIF, SALAH, KAABA)
- Friendly animations
- Voice hint support (if existing system available)

2. ADULT MODE
- Larger grids (5x5 → 11x11)
- Knowledge-based clues
- Deeper concepts (BADR, IHSAN, HIRA)

3. DAILY MODE
- Rotating themed puzzle
- Based on weekday categories:
  Monday → Qur’an
  Tuesday → Hadith
  Wednesday → Prophets
  Thursday → Duas
  Friday → Jummah theme
  Weekend → Mixed

==================================================
E. DIFFICULTY SYSTEM
==================================================

Implement scalable difficulty:

Level 1–10 → 3x3 grid (direct clues)
Level 10–25 → 5x5 grid (mixed clues)
Level 25–50 → 7x7 grid (contextual)
Level 50–75 → 9x9 grid (indirect)
Level 75–100 → 11x11 grid (conceptual)

==================================================
F. GAMEPLAY MECHANICS
==================================================

1. INPUT SYSTEM
- Tap cell
- Enter letter
- Navigate across/down

2. VALIDATION
- Check word completion
- Highlight correct answers
- Allow correction

3. COMPLETION STATE
- Detect full puzzle completion
- Trigger reward system

==================================================
G. REWARDS + PROGRESSION
==================================================

Integrate with existing systems:

- Each word solved → +1 Ocean Drop
- Puzzle completion → XP reward
- Perfect completion → bonus XP
- Daily puzzle → streak increment

DO NOT duplicate reward logic.
Reuse existing hooks.

==================================================
H. UI / UX IMPLEMENTATION
==================================================

Build:

1. Crossword Home
- Kids mode
- Adult mode
- Daily crossword card

2. Puzzle Screen
- Grid
- Clues list
- Input interaction
- Hint button (future-ready)

3. Completion State
- Glow effect
- Reward feedback
- XP display

Follow:
- global theme
- spacing system
- animation patterns

==================================================
I. DATA SEEDING (V1)
==================================================

Create initial local datasets:

- 10 kids puzzles
- 10 adult puzzles

Keep:
- small
- clean
- extendable

==================================================
J. CLEANUP
==================================================

- Remove duplicate or unused logic
- Keep naming consistent
- Ensure modular structure

==================================================
K. VALIDATION
==================================================

Confirm:

- Crossword renders correctly
- Input works smoothly
- Words validate correctly
- Rewards trigger correctly
- Drops increment correctly
- UI matches app theme
- No performance issues
- Analyzer passes

==================================================
DELIVERABLES
==================================================

After implementation, provide:

1. Files created / updated
2. What systems were reused
3. How content was sourced
4. Puzzle structure explanation
5. Reward integration details
6. Any limitations or next steps

==================================================
END
==================================================
