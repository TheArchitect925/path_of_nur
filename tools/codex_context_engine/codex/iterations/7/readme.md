# Iteration 7 — Failure Memory

## Goal

Iteration 7 adds **Failure Memory** to the engine.

The purpose of this layer is to let the system remember **previous failures, repeated friction points, and their resolutions** so future Codex runs can avoid wasting time on the same dead ends.

This iteration comes **after** context optimization and planning:

1. Iteration 5 — Context Cost Optimizer  
2. Iteration 6 — Context Planner  
3. **Iteration 7 — Failure Memory**

That order preserves the practical logic of the engine:

- first reduce waste
- then plan context better
- then learn from repeated failures

## Why this iteration exists

Many repository workflows fail in **predictable ways**:

- broken imports after refactors
- test failures caused by missing setup
- recurring migration mistakes
- flaky environment commands
- config drift
- misleading file locations
- repeated debugging traps

Without a memory layer for these failures, Codex may repeat the same ineffective actions in future sessions.

Failure Memory turns those past failures into **structured, reusable troubleshooting knowledge**.

## Concept

Failure Memory is not a raw execution log.

It is a **curated memory layer** that stores high-value records such as:

- category of failure
- symptoms
- likely root cause
- known solution
- files involved
- related commands
- occurrence count
- confidence / reusability

This makes it possible to reuse failure knowledge selectively during future tasks.

## Expected role in the engine

After this iteration, the engine conceptually behaves like this:

```text
User Task
  ↓
Context Planner
  ↓
Context Retrieval
  ├─ persistent repository memory
  ├─ failure memory
  ↓
Context Cost Optimizer
  ↓
Deterministic Context Packet
  ↓
Codex Execution
```

Failure Memory must remain **relevance-aware**.

The engine should only surface failure knowledge when it is likely to help with the current task.

## Expected artifacts

A typical implementation may introduce artifacts such as:

```text
.codex_failure_memory/
  index.json
  failures/
    <stable-id>.json
  summaries/
    common_patterns.md
```

The exact filenames may vary, but the subsystem should be:

- structured
- machine-readable
- appendable
- inspectable by humans
- safe for repeated upgrades

## Design expectations

This iteration should preserve the **autoincremental flow** of the engine.

It must:

- integrate with existing retrieval and planning behavior
- avoid duplicating records blindly
- remain safe for in-place upgrades
- preserve prior engine state
- avoid turning failure history into context bloat

## Benefits

- faster debugging
- fewer repeated mistakes
- repository-specific troubleshooting memory
- better context quality during execution
- improved continuity across Codex sessions

## Roadmap position

The active roadmap now looks like this:

| Iteration | Feature |
|-----------|---------|
| 5 | Context Cost Optimizer |
| 6 | Context Planner |
| 7 | Failure Memory |
| 8 | Task-Specific Memory |
| 9 | Memory Graph |

Failure Memory is the first layer that makes the engine learn systematically from **negative operational history**, not only from stable project knowledge.
