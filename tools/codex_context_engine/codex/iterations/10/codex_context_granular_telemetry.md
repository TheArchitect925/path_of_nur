# Codex Context Engine — Iteration 10 Prompt
## Granular Telemetry

You are implementing **Iteration 10 — Granular Telemetry** for the `codex_context_engine`.

This iteration must extend the existing engine in place.
It comes after:
- persistent memory
- telemetry and savings estimation
- deterministic packet compaction
- global metrics
- cost optimization
- planning
- failure memory
- task-specific memory
- memory graph

Do not redesign those layers.
Do not remove existing telemetry.
Do not break historical `task_logs.jsonl` data.

---

## Primary goal

Upgrade the engine telemetry model so it can measure not only **whole tasks**, but also **subtasks / phases / prompt iterations** inside a task.

The engine should be able to answer questions such as:
- which part of a task consumes the most context
- whether repo scan, debugging, test execution, or follow-up prompts are the expensive phases
- how many tasks have phase-level observability vs task-only observability
- which task types generate the heaviest phase breakdowns

This iteration must preserve the previous savings-report behavior while making telemetry more granular and more operationally useful.

---

## Why this iteration exists

Earlier telemetry support measured savings mainly at the task level.
That is useful for high-level reporting, but it hides important cost patterns:
- repeated short prompt loops
- exploratory repo scans
- code-edit iterations
- test reruns
- validation passes
- follow-up prompts after partial progress

Without phase-level telemetry, the engine can estimate overall savings but cannot explain **where inside the task** context and token cost concentrate.

Iteration 10 adds that missing layer.

---

## Non-negotiable constraints

1. **Maintain the autoincremental engine flow**
   - this is an additive telemetry upgrade
   - it must not invalidate previous iterations

2. **Preserve backward compatibility**
   - existing `task_logs.jsonl` rows that only describe full tasks must remain valid
   - existing weekly summaries must still be producible
   - old repositories must not need an immediate migration to keep working
   - legacy rows without `level` must still be interpreted as task-level telemetry when they carry whole-task fields such as `estimated_full_context_tokens` and `task_packet_tokens`

3. **Do not double count task totals**
   - if a task has both a top-level task row and multiple phase rows, the engine must not sum both into the top-level summary
   - task-level totals should remain the authoritative source when both forms exist

4. **Keep the format inspectable**
   - use plain JSONL and JSON summaries
   - avoid binary or opaque storage

5. **Keep the analyzer dependency-free**
   - continue using simple Node.js tooling unless a repo already has a stronger built-in telemetry framework

6. **Do not create noisy telemetry for its own sake**
   - phase-level logging should be optional but supported
   - reports should remain concise and useful

7. **Do not add instructions about creating iteration folder packaging for this repository**
   - focus on the implementation expected in the target repository

8. **Respect cross-project shared telemetry mode**
   - if the engine runs in cross-project mode, telemetry may live in a shared engine repository instead of only inside each consumer repository
   - per-project savings must remain attributable even when telemetry storage is shared
   - global aggregation must prefer the authoritative shared project telemetry over stale repo-local telemetry snapshots when the runtime state says cross-project mode is active

---

## Conceptual model

The telemetry stack after this iteration should conceptually behave like:

```text
Task execution
  ↓
Task-level telemetry row (optional but preferred)
  ↓
Phase-level telemetry rows (optional, repeatable)
  ↓
Analyzer normalizes rows
  ↓
Per-task aggregation without double counting
  ↓
Task-level savings summary
  ↓
Phase-level breakdowns
  ↓
Global savings / optimization reporting
```

The engine should preserve the old task-level summary as the compatibility baseline and add a new phase-aware lens on top.

In cross-project mode, the conceptual flow is:

```text
Task execution in repo X
  ↓
Shared engine telemetry root
  ↓
Project-scoped shared telemetry mirror for repo X
  ↓
Per-project weekly summary for repo X
  ↓
Global aggregation over shared project telemetry
```

---

## What to implement

Implement the following capabilities in the target repository.

### 1. Extended telemetry schema

Support the original task log schema and extend it with optional fields such as:
- `task_id`
- `level` with values like `task` or `phase`
- `phase_name`
- `parent_task_id` if needed
- `iteration_index`
- `prompt_index`
- `segment_name`
- `segment_type`

Minimum compatibility rule:
- a row without any granular fields must still be treated as a valid task-level row

Minimum recommended behavior:
- `task_id` should group related rows
- `level: "phase"` should mark phase/subtask rows
- `phase_name` should provide a short reusable phase label such as:
  - `repo_scan`
  - `implementation`
  - `test_run`
  - `validation`
  - `followup_prompt`
  - `code_edit`

### 2. Normalization layer

Add analyzer logic that normalizes raw telemetry rows into a consistent internal representation.

Normalization should:
- infer `level = task` when no granular signal exists
- infer `level = task` for legacy rows that omit `level` but include whole-task savings fields
- derive a stable task grouping key when possible
- attach fallback defaults for missing token and reasoning estimates
- keep malformed rows non-fatal when safe

### 3. Task aggregation rules

The analyzer must be able to aggregate multiple telemetry rows into one task result.

Rules:
- if task-level rows exist for a task, use them as the top-level summary source
- if only phase rows exist, aggregate those phases into a synthetic task total
- count phase rows separately for phase analytics
- avoid counting both task totals and their child phases into the same top-level totals

This behavior is mandatory.

### 4. Phase-level reporting

Extend weekly summary outputs so they can answer:
- how many phase events were sampled
- how many tasks include phase breakdowns
- what fraction of sampled tasks have granular coverage
- which phases consume the most packet tokens on average
- which task types are currently the most expensive by packet tokens

Recommended output fields include:
- `task_events_sampled`
- `phase_events_sampled`
- `tasks_with_phase_breakdown`
- `tasks_without_phase_breakdown`
- `telemetry_granularity`
- `top_task_types_by_packet_tokens`
- `top_phases_by_packet_tokens`

Keep the original summary fields intact.

### 5. CLI / analyzer flexibility

Improve the analyzer so it can run against:
- the default repo-local telemetry location
- a shared engine telemetry root in cross-project mode
- a project-scoped shared telemetry directory such as `.context_metrics/projects/<repo>/`
- an alternate telemetry directory for tests or migration checks
- an alternate ledger path when validating in temporary directories
- a configurable reporting period if practical

Prefer lightweight CLI flags over introducing dependencies.

### 6. Documentation

Update telemetry documentation so future users know:
- the old task-level format is still valid
- legacy rows without `level` are still valid task rows if they include whole-task token fields
- phase-level rows are now supported
- how aggregation behaves when task and phase rows coexist
- how cross-project shared telemetry is laid out and which path is authoritative
- what fields are recommended for granular logging

The documentation should remain concise and operational.

### 7. Memory / protocol integration

If the engine maintains protocol or memory notes describing telemetry behavior, update them to mention:
- layered telemetry
- backward-compatible task summaries
- optional phase-level instrumentation

This keeps future upgrades from accidentally assuming task-only telemetry.

### 8. Validation expectations

Conceptually validate at least these scenarios:

1. old-style telemetry with one row per task still produces a weekly summary
2. mixed telemetry with both task and phase rows does not double count
3. telemetry with phase-only rows still produces coherent task-level savings estimates
4. phase-level fields appear in the generated summary
5. the analyzer remains resilient to missing optional fields
6. shared cross-project telemetry still produces a correct per-project summary
7. global aggregation prefers shared authoritative telemetry over stale repo-local copies when cross-project mode is active

---

## Design principles

### Compatibility first
Historical telemetry must remain readable and useful.
This includes imported legacy rows and cross-project shared telemetry layouts.

### Granularity without complexity explosion
The goal is not full tracing of every token event.
The goal is useful observability at the phase/subtask level.

### Explainable aggregation
A human should be able to read a few JSONL rows and predict how the summary will treat them.

### Actionable metrics
The resulting summaries should help answer where optimization effort belongs, not just report one global percentage.

### Shared storage without attribution loss
Cross-project shared telemetry must reduce duplication without collapsing repository attribution.

---

## Examples

### Legacy task-level row

```json
{
  "timestamp": "2026-03-11T10:00:00Z",
  "task_type": "testing",
  "estimated_full_context_tokens": 9800,
  "task_packet_tokens": 2700,
  "model_used": "medium",
  "estimated_reasoning_cycles": 5,
  "notes": "Whole-task estimate"
}
```

### Granular task + phase rows

```json
{
  "timestamp": "2026-03-11T10:00:00Z",
  "task_id": "fix-onboarding-tests",
  "level": "task",
  "task_type": "testing",
  "estimated_full_context_tokens": 9000,
  "task_packet_tokens": 2600,
  "model_used": "medium",
  "estimated_reasoning_cycles": 5
}
{
  "timestamp": "2026-03-11T10:00:01Z",
  "task_id": "fix-onboarding-tests",
  "level": "phase",
  "phase_name": "repo_scan",
  "task_type": "testing",
  "estimated_full_context_tokens": 1500,
  "task_packet_tokens": 500,
  "estimated_reasoning_cycles": 1
}
{
  "timestamp": "2026-03-11T10:00:02Z",
  "task_id": "fix-onboarding-tests",
  "level": "phase",
  "phase_name": "test_run",
  "task_type": "testing",
  "estimated_full_context_tokens": 1800,
  "task_packet_tokens": 700,
  "estimated_reasoning_cycles": 2
}
```

Expected interpretation:
- the task row drives the top-level weekly savings totals for that task
- the phase rows feed phase-level breakdown analytics
- no double counting occurs

---

## Expected outcome

After this iteration, the engine should be able to produce savings reports that remain compatible with earlier telemetry while also surfacing:
- which phases are expensive
- how much telemetry is granular vs task-only
- which task types carry the highest packet burden

Iteration 10 turns telemetry from a coarse savings estimate into a more operational profiling layer for context usage.
