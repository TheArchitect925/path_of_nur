# Iteration 8 — Task-Specific Memory

## Goal
Add a repository-local memory layer specialized by **task type** so the engine can retrieve more relevant context depending on the kind of work being executed.

This iteration preserves the autoincremental flow of the engine and extends the existing stack without replacing generic memory, planner behavior, optimizer behavior, or failure memory.

## Why this iteration exists
Generic repository memory is useful, but not every task needs the same kind of knowledge.
A bug-fixing task, for example, benefits from different patterns than a refactoring or performance task.

Task-Specific Memory gives the engine a way to store and retrieve reusable knowledge that is scoped to recurring task classes.

## Core concept
The engine should infer a task type before context retrieval is finalized, then use that signal to query a specialized memory area.
That task-specific knowledge is merged with the existing generic memory and other relevant layers.

Conceptual flow:

```text
User task
  ↓
Context Planner
  ↓
Task Type Inference
  ↓
Task-Specific Memory Retrieval
  ↓
Generic Memory + Failure Memory Retrieval
  ↓
Packet Assembly
  ↓
Context Cost Optimizer
  ↓
Codex execution
```

## Minimum capabilities
- deterministic task type inference
- repository-local task memory storage
- retrieval integration using inferred task category
- graceful fallback to generic memory when task type is unknown
- lightweight observability for task-memory usage
- concise learning/update behavior after execution

## Suggested task taxonomy
- `bug_fixing`
- `refactoring`
- `testing`
- `performance`
- `architecture`
- `feature_work`
- `unknown`

## Suggested storage area
```text
.codex_task_memory/
  bug_fixing/
  refactoring/
  testing/
  performance/
  architecture/
  feature_work/
  unknown/
```

The implementation should remain simple, human-readable, and compatible with future iterations.

## Design constraints
- maintain the autoincremental engine flow
- do not break earlier iterations
- do not make task-specific memory mandatory for execution
- keep retrieval concise and optimizer-friendly
- prefer durable reusable patterns over session noise
- preserve existing state during upgrade

## Expected impact
- better contextual relevance per task
- stronger specialization for debugging, refactoring, testing, and architecture work
- less generic noise in packets
- improved reuse of recurring workflow knowledge

## Relationship with the roadmap
This iteration assumes the reordered official roadmap already fixed for the engine:

| Iteration | Capability |
|-----------|------------|
| 5 | Context Cost Optimizer |
| 6 | Context Planner |
| 7 | Failure Memory |
| 8 | Task-Specific Memory |
| 9 | Memory Graph |

Task-Specific Memory is positioned after Failure Memory because it builds on top of already learned friction patterns, but it broadens the engine beyond failure handling into reusable task-domain intelligence.
