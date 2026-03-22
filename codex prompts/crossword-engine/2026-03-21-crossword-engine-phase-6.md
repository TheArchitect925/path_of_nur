===== PHASE 6 PROMPT — CROSSWORD PUZZLE =====

You are working in the existing Flutter codebase for “Path of Nūr”.

==================================================
PRIMARY OBJECTIVE === BUILDING CROSSWORD PUZZLE
==================================================

Evolve the Crossword Puzzle system into a foundational “Knowledge Games Engine” that:
- powers crossword puzzles
- supports additional game types in the future
- reuses a shared content + progression + reward system
- scales cleanly across multiple learning experiences

This phase is NOT about adding more crossword features.
This phase is about extracting and structuring reusable systems so that:
- crossword becomes one game type
- the app can support multiple knowledge-based game formats

The Crossword Puzzle must continue to work exactly as before, with no regression.

==================================================
GLOBAL APP CONSISTENCY (MANDATORY)
==================================================

The implementation MUST:
- keep the same app build and feel
- use the global theme system
- use shared components, layouts, spacing, typography, and motion
- preserve localization
- reuse XP, levels, streaks, Ocean Drops, and reward systems
- remain visually consistent with all existing pages

DO NOT:
- create a separate “games app”
- introduce a new UI system
- break crossword behavior
- duplicate reward or persistence logic

Everything must remain native to Path of Nūr.

==================================================
TASK TYPE
==================================================

Refactor and extend Crossword into a reusable Knowledge Games Engine.

==================================================
EXECUTION RULES
==================================================

1. Audit first before editing.
2. Do NOT break existing crossword functionality.
3. Extract reusable systems carefully.
4. Keep everything offline-first.
5. Keep architecture clean and modular.
6. Avoid over-engineering.
7. Run analyzer on changed files and summarize results.

==================================================
A. AUDIT PHASE (MANDATORY FIRST STEP)
==================================================

Audit the current crossword system across all previous phases.

Identify:
- crossword-specific logic
- reusable logic (content, rewards, progression)
- puzzle models vs UI vs services
- pack and category systems
- daily challenge system
- persistence and resume logic
- reward triggers
- content normalization

Classify:
1. what is crossword-specific
2. what can be generalized
3. what must remain unchanged

==================================================
B. CREATE KNOWLEDGE GAME CORE MODELS
==================================================

Introduce reusable core models:

class KnowledgeGame {
  final String id;
  final String type; // crossword, word_search, matching, etc.
  final String category;
  final int difficulty;
  final List<String> tags;
}

class KnowledgeGameSession {
  final String gameId;
  final String type;
  final DateTime startedAt;
  final bool isCompleted;
  final Map<String, dynamic> state;
}

class KnowledgeGameResult {
  final String gameId;
  final bool completed;
  final bool perfect;
  final int xpEarned;
  final int dropsEarned;
}

These models should:
- NOT replace crossword models immediately
- but sit above them as a shared abstraction layer

==================================================
C. EXTRACT SHARED SYSTEMS
==================================================

Refactor reusable systems from crossword into shared modules:

1. CONTENT SYSTEM
- normalized entries
- categories
- tags
- difficulty
- eligibility

2. PACK SYSTEM
- packs
- categories
- progression
- completion state

3. DAILY SYSTEM
- daily resolver
- streak handling
- history tracking

4. REWARD SYSTEM HOOKS
- XP triggers
- Ocean Drops triggers
- completion states

5. PROGRESSION SYSTEM
- completion tracking
- resume state
- next recommended item

Ensure:
- crossword uses these shared systems
- no duplicate logic remains

==================================================
D. DEFINE GAME TYPE ADAPTERS
==================================================

Create a pattern for game types.

Example:

abstract class KnowledgeGameAdapter {
  String get type;
  Widget buildGameUI(...);
  KnowledgeGameResult evaluate(...);
  dynamic createInitialState(...);
}

Implement:

CrosswordGameAdapter

This adapter should:
- wrap existing crossword logic
- expose it through a common interface
- allow future game types to plug in cleanly

==================================================
E. STANDARDIZE GAME FLOW
==================================================

Create a shared flow:

1. Select Game
2. Load Game
3. Play Game
4. Evaluate Result
5. Reward + Progress Update
6. Completion Screen
7. Next Recommendation

Ensure:
- crossword uses this flow
- flow is reusable for future games

==================================================
F. SHARED GAME UI SHELL
==================================================

Create a reusable game container/shell:

KnowledgeGameScreen

Responsibilities:
- header (title, category, difficulty)
- progress state
- hint area (if applicable)
- game body (injected via adapter)
- completion overlay
- reward display

Crossword should be rendered inside this shell.

==================================================
G. PREPARE FOR FUTURE GAME TYPES
==================================================

Do NOT build these yet, but prepare support for:

- word search
- matching game
- fill-in-the-blank
- quiz grids

Ensure:
- content system supports them
- game adapter system supports them
- reward system supports them
- progression system supports them

==================================================
H. CONTENT REUSE ENFORCEMENT
==================================================

Ensure ALL game types (including crossword):
- pull from the same knowledge pool
- do not duplicate datasets
- respect category tagging
- respect difficulty system

==================================================
I. CROSSWORD INTEGRATION CHECK
==================================================

After refactor:

Ensure:
- crossword puzzles still load correctly
- packs still work
- daily still works
- hints still work
- rewards still work
- persistence still works
- UI unchanged visually

Zero regression allowed.

==================================================
J. CLEANUP
==================================================

- remove duplicate logic extracted into shared systems
- keep naming consistent
- keep modules clean and isolated
- avoid large monolithic services

==================================================
K. VALIDATION
==================================================

Confirm:
- crossword fully functional
- shared systems working
- no duplication of logic
- adapter pattern works
- game shell renders correctly
- rewards/streaks still correct
- analyzer passes

==================================================
DELIVERABLES
==================================================

After implementation, provide:

1. files created / updated
2. what was extracted into shared systems
3. how crossword now plugs into the game engine
4. how adapters work
5. how future games will plug in
6. any limitations
7. recommended next feature to build using this engine

==================================================
END
==================================================
