# Codex Context Engine — Iteration 9 Prompt
## Memory Graph

You are implementing **Iteration 9 — Memory Graph** for the `codex_context_engine`.

This iteration must be implemented **on top of the existing engine**, not as a rewrite.
The current system already includes earlier layers such as persistent memory, structured context retrieval, diagnostics, planning, failure memory, task-specific memory, and context cost optimization.

Your job is to extend that foundation with a **graph-based knowledge layer** while **preserving the autoincremental flow of the engine**.

---

## Primary goal

Introduce a **Memory Graph** that captures relationships between repository knowledge entities so the engine can retrieve not only isolated records, but also their **connected context**.

The graph must help Codex understand:
- how files relate to modules
- how modules relate to decisions
- how decisions relate to failures
- how failures relate to fixes
- how tasks relate to recurring repository areas
- how architectural concepts connect across the repo

This iteration must remain:
- incremental
- repository-local
- inspectable
- deterministic enough for operational use
- backward-compatible with the existing engine

---

## Non-negotiable constraints

1. **Maintain the autoincremental engine flow.**
   The engine must still evolve safely through cumulative layers.

2. **Do not rewrite previous iterations.**
   Reuse the current memory structures whenever possible.

3. **Do not replace existing list-based memories outright.**
   The graph is an additional intelligence layer built from them.

4. **Do not create a graph that requires external services, databases, or network calls.**
   Everything must work locally inside the repository.

5. **Do not make the graph opaque.**
   The stored relationships must remain human-inspectable.

6. **Do not introduce fragile magic inference.**
   Prefer explicit, traceable graph construction from known artifacts.

7. **Do not include instructions about creating the iteration folder structure or these prompt/readme files.**
   Focus only on implementing the engine changes inside the target repository.

---

## Context from the roadmap

Iteration 9 is the **Memory Graph** layer.
It follows the planner, optimizer, failure memory, and task-specific memory layers.

Its purpose is to evolve the engine from retrieving flat records into retrieving **related knowledge neighborhoods**.

The intended progression is:

```text
Task
  ↓
Context Planner
  ↓
Task-Specific / Failure / Persistent Memories
  ↓
Memory Graph Expansion
  ↓
Context Cost Optimization
  ↓
Deterministic Context Packet
  ↓
Codex Execution
```

This means the graph must support the engine, not dominate it.
It should enrich selection before final packet optimization.

---

## Desired capability

After this iteration, the engine should be able to do things like:

- start from a task hint such as “refactor auth flow”
- identify related files, modules, prior decisions, known failure patterns, and task-specific notes
- expand only one or two hops through the graph
- assemble a richer but still bounded context neighborhood
- pass that neighborhood to the cost optimizer before packet injection

Example conceptual chain:

```text
Task: fix flaky onboarding tests
  → task type: tests
  → related area: onboarding
  → related files: onboarding UI / test helpers / state manager
  → related failure record: async timing race
  → related decision: debounce introduced in prior refactor
  → related architectural note: onboarding state centralized
```

---

## What to implement

Implement the Memory Graph layer in the target repository with the following components.

### 1. Graph storage
Create a repository-local graph storage format that is:
- file-based
- simple to inspect
- easy to append/update
- deterministic enough to be queried by tooling

A pragmatic approach is acceptable, for example:
- JSON files
- NDJSON files
- lightweight adjacency lists
- node and edge files

Prefer a structure such as:

```text
.codex_memory_graph/
  nodes/
  edges/
  indexes/
  snapshots/
```

But adapt to the existing engine conventions if there is already a better naming pattern in the target repository.

### 2. Node model
Support graph nodes for at least these concepts when evidence exists:
- file
- module
- task_type
- memory_entry
- failure_pattern
- solution
- architecture_decision
- repository_area
- concept

Each node should have a stable identifier and minimal metadata.

Example fields:
- id
- type
- label
- source
- last_updated_at
- confidence
- tags

### 3. Edge model
Support explicit relationships such as:
- relates_to
- affects
- caused
- fixed_by
- located_in
- referenced_by
- associated_with
- belongs_to_task_type
- derived_from

Each edge should capture:
- from
- to
- relation
- source
- confidence
- timestamp

### 4. Graph builders
Add routines that can derive graph nodes/edges from existing engine artifacts where possible.
At minimum, attempt to build graph links from:
- persistent project memory
- task-specific memory
- failure memory
- context planner outputs if present
- file path / module heuristics already used by the engine

Use conservative derivation rules.
If a relation is weak, record lower confidence rather than overstating certainty.

### 5. Graph query layer
Add a query mechanism the engine can use during retrieval.
This does not need to be complex.
It should at least support:
- fetch node by id or label
- get direct neighbors
- get neighbors by relation type
- bounded expansion by depth
- bounded expansion by node/edge budget
- filtering by task type or repository area

### 6. Context expansion step
Add a retrieval step where the engine can:
- start from initial relevant memory/task signals
- expand through the graph within strict limits
- gather connected records
- pass the enriched candidate set to the optimizer

This is critical: **graph expansion must be bounded**.
Do not allow uncontrolled neighborhood growth.

### 7. Cost-aware behavior
The graph layer must cooperate with the existing optimizer.
That means:
- expansion depth should be small by default
- high-confidence and high-value relations should be preferred
- low-value expansions should be pruned early
- graph-driven context must still fit the engine’s budget-aware behavior

### 8. Rebuild / refresh behavior
Add a safe way to:
- initialize the graph from existing memory
- refresh it after new failure records or task memories are added
- avoid full rebuilds when incremental update is enough

Prefer incremental updates if the engine already has hooks where memory artifacts are written.

### 9. Observability
Add lightweight observability for graph usage, such as:
- number of nodes
- number of edges
- expansion depth used
- graph hits in a task
- whether graph expansion materially changed context selection

Keep this inspectable and small.

### 10. Documentation and compatibility
Ensure the implementation remains coherent with the existing engine docs and state markers.
If the engine tracks installed iteration state, update it to reflect the new highest iteration once the implementation is complete.

---

## Behavioral rules

### Preserve the engine’s operational philosophy
The engine must continue to behave like a **context system**, not an autonomous black box.

### Prefer traceability over cleverness
A slightly simpler graph that can be understood and debugged is better than a more ambitious opaque one.

### Bounded graph expansion only
Default expansion must remain conservative.
Recommended behavior:
- depth 1 by default
- optional depth 2 only when signal is strong
- node cap and edge cap enforced

### Backward compatibility
If graph data is missing or incomplete, the engine must still work using prior memory layers.
The graph should improve retrieval, not become a hard dependency that breaks execution.

### Safe degradation
If graph generation fails, do not block the rest of the engine.
Record the issue and continue with standard retrieval.

---

## Suggested implementation strategy

A good implementation path is:

1. inspect current memory, planner, optimizer, and failure/task-memory structures
2. define a minimal node/edge schema aligned with them
3. build a graph initializer from existing artifacts
4. add incremental graph updates when new memory records are written
5. add a bounded graph query helper
6. connect the planner/retrieval layer to the graph query step
7. feed the expanded candidates into the existing cost optimizer
8. add observability and validation
9. verify no previous engine behavior regressed

---

## Validation requirements

You must validate the implementation honestly.
Check at least:

1. the engine still works when the graph is empty
2. the graph can be initialized from existing memory artifacts
3. graph expansion stays bounded
4. connected knowledge can be retrieved from at least one realistic seed
5. the optimizer still trims final context after graph expansion
6. previous memory systems remain intact
7. installed iteration state is updated correctly if the repository uses it

If tests exist or can be added safely, add focused tests for:
- node creation
- edge creation
- bounded expansion
- fallback behavior when graph data is missing
- integration with retrieval / optimization pipeline

---

## Expected outcome

At the end of this iteration, the target repository should have:
- a new graph-based memory layer
- bounded graph expansion during retrieval
- compatibility with prior memory systems
- cost-aware connected-context enrichment
- updated docs/state where appropriate

The result should make the engine better at retrieving **related knowledge**, not just matching isolated records.

---

## Final instruction

Implement Iteration 9 as a **practical, inspectable, bounded Memory Graph layer** that strengthens the existing autoincremental engine without destabilizing previous iterations.

When making design tradeoffs, prefer:
- compatibility
- inspectability
- bounded behavior
- incremental updates
- deterministic operational value

over ambitious complexity.
