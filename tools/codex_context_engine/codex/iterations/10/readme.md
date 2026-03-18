# Iteration 10 — Granular Telemetry

## Goal
Extend `codex_context_engine` telemetry so the system can measure not only whole-task savings, but also **phase-level / subtask-level** context and token behavior.

This iteration preserves the existing savings model and adds a more granular layer for understanding where expensive context usage happens inside a task.

## Why this iteration exists
Task-level telemetry is enough to estimate overall savings, but it is too coarse to explain:
- where the largest context packets occur
- whether repo scan, code edits, test runs, or follow-up prompts drive the cost
- how much of the recorded workload has granular observability

Iteration 10 fills that gap without breaking historical telemetry.

## Core concept

```text
Task rows remain the compatibility baseline
  +
Optional phase rows capture subtasks / iterations
  ↓
Analyzer normalizes both
  ↓
Top-level savings remain task-based
  ↓
Additional phase breakdowns reveal expensive task segments
```

## Minimum capabilities
- support legacy one-row-per-task telemetry
- support optional `task_id` + `level: "phase"` rows
- aggregate phase-only telemetry into synthetic task totals when needed
- avoid double counting when task rows and phase rows coexist
- expose summary fields for granular coverage and top expensive phases
- keep the analyzer lightweight and dependency-free

## Suggested telemetry additions
- `task_id`
- `level`
- `phase_name`
- `task_events_sampled`
- `phase_events_sampled`
- `tasks_with_phase_breakdown`
- `telemetry_granularity`
- `top_task_types_by_packet_tokens`
- `top_phases_by_packet_tokens`

## Design constraints
- preserve backward compatibility with historical telemetry
- keep aggregation deterministic and explainable
- prefer concise operational metrics over noisy tracing
- maintain repo-local, inspectable storage
- do not require immediate migration of old task logs

## Expected impact
- better visibility into where context/tokens are actually consumed
- stronger answers to savings and optimization questions
- easier prioritization of repo-scan, debug-loop, and test-loop optimizations
- better distinction between high-cost task types and high-cost task phases

## Relationship with the roadmap

| Iteration | Capability |
|-----------|------------|
| 8 | Task-Specific Memory |
| 9 | Memory Graph |
| 10 | Granular Telemetry |

Granular Telemetry naturally follows the Memory Graph and task-specific layers because once the engine retrieves richer context, it also needs a better way to observe where the resulting cost concentrates during real work.
