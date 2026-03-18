# Iteration 7 — Failure Memory

## Objective

Implement **Iteration 7 — Failure Memory** for `codex_context_engine`.

This iteration must add a repository-local layer that records **previous failures, repeated friction points, and known resolutions**, so the engine can avoid repeating ineffective work in future Codex runs.

This must be implemented **without breaking the autoincremental flow of the engine**.  
The engine must remain incremental, state-preserving, and safe to upgrade.

---

## Important Constraints

- Preserve the **autoincremental orchestration model** of the engine.
- Do **not** redesign the root installer philosophy.
- Do **not** remove or bypass previous iterations.
- Do **not** add to this implementation any logic about creating `iterations/<number>/` folders or prompt packaging files.
- Treat this task as **implementing engine capability in the target repository/docs/prompt system**, not packaging this repo.
- Prefer **appenditive and compatible changes** over rewrites.
- Preserve all existing memory, telemetry, optimization, planning, and configuration artifacts whenever possible.

---

## Canonical Position of This Iteration

The roadmap currently follows this practical order:

1. Iteration 5 — Context Cost Optimizer  
2. Iteration 6 — Context Planner  
3. **Iteration 7 — Failure Memory**  
4. Iteration 8 — Task-Specific Memory  
5. Iteration 9 — Memory Graph

Failure Memory comes **after** optimization and planning because the engine should first reduce waste and improve context selection, then begin learning from repeated failures in a structured way.

---

## Iteration Goal

Add a **Failure Memory layer** that allows the engine to:

- record recurring failures and friction points
- store repository-specific troubleshooting knowledge
- associate failures with likely causes, fixes, and involved files
- retrieve high-value failure knowledge during planning / context assembly
- improve future execution quality without bloating context unnecessarily

The engine should now learn not only from repository structure and reusable project context, but also from **negative operational history**.

---

## Required Conceptual Model

Failure Memory should behave as a **specialized, structured sub-layer of persistent context**, not as an unstructured log dump.

It should capture entries such as:

- build failures
- test failures
- import/path mistakes
- migration mistakes
- flaky commands
- repeated configuration pitfalls
- environment-specific breakages
- known dead ends
- misleading file locations
- recurring debugging traps

Each record should aim to answer:

- **what failed**
- **why it failed**
- **how it was resolved**
- **which files or subsystems were involved**
- **how confident the system is that this pattern is reusable**

---

## Expected Artifacts

Implement a coherent Failure Memory subsystem with artifacts such as these (adapt names if needed, but keep them clear and machine-usable):

```text
.codex_failure_memory/
  index.json
  failures/
    <stable-id>.json
  summaries/
    common_patterns.md
```

A minimal metadata / state update may also be needed so the engine can detect that Iteration 7 is installed.

If an existing engine state marker exists, extend it safely rather than replacing it.

---

## Suggested Failure Record Shape

Use a stable and inspectable structure for each failure record. A JSON shape like this is acceptable:

```json
{
  "id": "build_failure_incorrect_import_path",
  "category": "build_failure",
  "title": "Incorrect import path in module loader",
  "symptoms": [
    "build fails during module resolution",
    "cannot find module"
  ],
  "root_cause": "module reference used outdated relative path",
  "solution": "update module reference to the correct import path",
  "files_involved": [
    "build_config",
    "module_loader"
  ],
  "related_commands": [
    "npm run build"
  ],
  "reusability": "high",
  "confidence": 0.87,
  "first_seen_at": "<timestamp>",
  "last_seen_at": "<timestamp>",
  "occurrences": 3,
  "status": "resolved",
  "notes": "Common after refactors that move shared modules."
}
```

The exact fields may vary, but the system must remain:

- structured
- appendable
- machine-readable
- conservative
- easy to inspect manually

---

## Core Capabilities To Implement

### 1. Failure Memory Storage

Add a durable storage model for failure records.

Requirements:

- supports multiple records
- supports repeated occurrences
- can update an existing pattern instead of duplicating it blindly
- uses stable identifiers where possible
- preserves history safely

### 2. Failure Classification

Add a lightweight classification approach for failures.

Possible categories:

- `build_failure`
- `test_failure`
- `runtime_failure`
- `config_failure`
- `environment_failure`
- `migration_failure`
- `refactor_regression`
- `tooling_failure`
- `unknown`

Classification can be heuristic. It does **not** need to be perfect, but it should be consistent and useful.

### 3. Resolution Capture

The system must be able to store:

- root cause
- solution
- involved files
- commands or workflows related to the failure
- confidence / usefulness level

### 4. Retrieval Integration

Integrate Failure Memory into the engine flow so that relevant failure records can be consulted during execution.

This must fit the existing autoincremental model.

At minimum, integrate it into:

- context planning
- context retrieval
- packet assembly / optimization path when relevant

The key rule is:

> only inject failure knowledge when it is likely to help with the current task.

### 5. Anti-Bloat Behavior

Do not let Failure Memory become a context dump.

Implement lightweight mechanisms such as:

- relevance filtering
- confidence thresholds
- occurrence-based prioritization
- compact summaries
- deduplication / merge behavior

### 6. Human-Inspectable Summary

Generate a concise summary artifact of common known failures and patterns, useful for inspection and debugging.

For example:

```text
.codex_failure_memory/summaries/common_patterns.md
```

This summary should not replace the structured records. It complements them.

---

## Integration Expectations

You must integrate Failure Memory into the engine **as a layer**, not as an isolated folder.

That means updating the engine documentation / orchestration language so the system now conceptually behaves like:

```text
User Task
  ↓
Context Planner
  ↓
Context Retrieval
  ├─ persistent repository memory
  ├─ telemetry-aware selection
  ├─ failure memory lookup
  ↓
Context Cost Optimizer
  ↓
Deterministic Context Packet
  ↓
Codex Execution
```

The engine should remain understandable and deterministic.

Failure Memory must enrich execution, not make it opaque.

---

## State Detection / Upgrade Compatibility

Because the engine is autoincremental, make Iteration 7 detectable.

Requirements:

- update the installed iteration marker if one exists
- if no clear marker exists, extend the engine so future runs can conservatively detect Failure Memory capability
- do not destroy older state
- do not assume clean installation

If partial prior artifacts exist, normalize them safely.

---

## README / Docs Updates

Update the root documentation so that it reflects the current engine state after Iteration 7.

Expected doc changes:

### Root `README.md`
- include **Iteration 7 — Failure Memory**
- explain its purpose
- keep the roadmap aligned with the current practical order:
  - 5 Context Cost Optimizer
  - 6 Context Planner
  - 7 Failure Memory
  - 8 Task-Specific Memory
  - 9 Memory Graph

### `codex_context_engine.md`
Keep the document conceptually stable, but update it so it reflects the evolved engine layers.

At minimum:
- preserve the root orchestrator behavior
- do not hardcode the latest iteration
- reflect that the engine now evolves through optimization, planning, and failure-learning layers
- mention Failure Memory in the forward evolution section / capability detection guidance when appropriate

Do not rewrite the philosophy of the engine. Extend it carefully.

---

## Quality Bar

The implementation should feel like a real continuation of the existing engine, not an unrelated add-on.

It should be:

- incremental
- deterministic where possible
- cheap to maintain
- safe for repeated upgrades
- repository-local
- compatible with previous iteration artifacts

---

## Validation Requirements

After implementing the iteration, validate at least the following conceptually:

1. Failure Memory artifacts can be discovered and read
2. A known failure pattern can be added without corrupting existing state
3. Repeated failures update or reinforce records instead of exploding duplicates
4. Relevant failure memory can be selected for a matching task
5. Irrelevant failure memory is not injected by default
6. Installed iteration state reflects that Iteration 7 is now available

If something cannot be fully validated, say so explicitly.

---

## Deliverable Style

Apply the iteration as if you were upgrading a real repository with an existing Codex Context Engine installation.

Be practical and conservative.

Return a concise summary including:
- what was added
- what was updated
- how Failure Memory integrates with the engine
- how installation state is now detected
- any limitation or assumption
