# Iteration 9 — Memory Graph

## Goal
Add a **graph-based knowledge layer** to `codex_context_engine` so the system can retrieve not only isolated memory records, but also the **relationships between them**.

This iteration evolves the engine from flat memory retrieval toward **connected contextual reasoning**, while preserving the existing autoincremental workflow.

## Why this iteration exists
Earlier iterations gave the engine strong building blocks:
- persistent repository memory
- deterministic context assembly
- diagnostics and metrics
- planning
- failure memory
- task-specific memory
- context cost optimization

However, those layers still mostly work with **lists, categories, and direct matches**.

Iteration 9 introduces a new capability: the engine can move from a relevant seed to its **related context neighborhood**.

That means it can connect:
- tasks to repository areas
- repository areas to files and modules
- failures to fixes
- decisions to affected components
- task types to recurring patterns

## Core concept

```text
Task
  ↓
Planner selects initial signals
  ↓
Base memories are retrieved
  ↓
Memory Graph expands related knowledge
  ↓
Optimizer trims and budgets final packet
  ↓
Codex executes with connected context
```

The graph does **not** replace previous memories.
It enriches them.

## Intended capabilities
The Memory Graph layer should support:
- graph nodes for files, modules, task types, failure patterns, solutions, decisions, concepts, and repository areas
- graph edges describing explicit relationships between those entities
- bounded graph traversal from relevant seeds
- graph expansion that remains compatible with context budgets
- incremental graph refresh when memory artifacts change
- fallback behavior if graph data is missing or incomplete

## Design principles

### Preserve the autoincremental flow
The engine must remain cumulative and safe to upgrade.

### Build on existing artifacts
Graph nodes and edges should be derived from prior engine knowledge whenever possible.

### Keep it inspectable
The graph must stay repository-local and understandable by humans.

### Keep expansion bounded
Connected retrieval is useful only if it does not explode in size.

### Stay cost-aware
Graph expansion must still feed into the optimizer before final model injection.

## Suggested structure
A practical implementation may use a repository-local structure such as:

```text
.codex_memory_graph/
  nodes/
  edges/
  indexes/
  snapshots/
```

The exact structure may vary if the target repo already has stronger conventions.

## Examples of useful relationships
- `failure_pattern -> fixed_by -> solution`
- `solution -> affects -> module`
- `task_type -> associated_with -> repository_area`
- `architecture_decision -> relates_to -> concept`
- `repository_area -> contains -> file`
- `file -> referenced_by -> memory_entry`

## Benefits
- richer context retrieval
- better architectural awareness
- faster connection of bugs to prior fixes
- improved reuse of repository-specific knowledge
- stronger support for complex refactors and debugging workflows

## Compatibility expectations
This iteration must remain backward-compatible.
If the graph cannot be built or queried, the engine should continue operating with the previous memory layers.

## Summary
Iteration 9 turns the engine into a more connected contextual system.
It is the first step from structured memory toward **relationship-aware context orchestration**.
