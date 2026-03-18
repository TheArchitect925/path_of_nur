# Iteration 6 — Context Planner

## Goal

Add a **planning layer** to `codex_context_engine` so the engine decides **which context to load before retrieval and packet assembly**.

Until Iteration 5, the engine could persist memory, score relevance, compact packets, expose metrics, and optimize cost. What it still lacked was a first-class step that decides:

- what kind of task is happening
- which context layers should be consulted
- how deep retrieval should go
- when exploration should stay narrow

Iteration 6 adds that planning layer.

## Why this iteration exists

Good memory and good optimization are not enough if the engine starts from the wrong retrieval strategy.

Before this iteration, the engine could still waste work by:

- exploring too broadly for a small task
- loading the wrong mix of memory layers
- treating a local fix and an architecture task too similarly
- retrieving context before deciding what the task actually needs

Iteration 6 addresses that by making planning explicit.

## Core concept

```text
User Task
  ↓
Context Planner
  ↓
Context Retrieval
  ↓
Deterministic Context Packet
  ↓
Context Cost Optimizer
  ↓
Codex Execution
```

The planner does not replace retrieval.
It routes retrieval.

## What this iteration adds

- task-shape detection before retrieval
- planning signals for execution scope
- selection of relevant context layers
- bounded retrieval depth
- safer fallback behavior when confidence is weak
- planner observability compatible with prior telemetry

## Typical planning decisions

The planner should help answer questions like:

- Is this a bug fix, test task, refactor, performance pass, or architecture task?
- Should the engine prioritize failure memory?
- Should retrieval stay local to a file/module, or expand wider?
- Should task-specific memory be queried?
- Should graph expansion remain shallow?
- Should the packet aim for a narrow or broad budget profile?

## Design constraints

Iteration 6 must preserve the **autoincremental engine model**.
It should remain:

- additive
- backward-compatible
- deterministic where practical
- safe for in-place upgrades
- compatible with Iterations 1–5

That means:

- no destructive resets
- no bypass of deterministic packet generation
- no replacement of existing memory layers
- no dependence on a fresh install

## Benefits

- better context routing before retrieval starts
- less unnecessary repo exploration
- stronger distinction between narrow and broad tasks
- cleaner use of failure memory, task memory, and graph expansion in later iterations
- more predictable packet quality

## Creates any new problems?

Yes, a few.

- It adds another decision layer that can be wrong.
- A weak planner can route retrieval badly and reduce quality downstream.
- It increases system complexity because planning rules must stay inspectable and stable.

Even so, the tradeoff is worth it: planning mistakes are easier to debug than uncontrolled retrieval.
