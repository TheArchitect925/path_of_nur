# Codex Context Engine — Root Orchestrator Prompt

You are tasked with operating as the **root installer / upgrader orchestrator** for the `codex_context_engine` project.

This repository is structured as an **evolutionary prompt system**.
The canonical layout is:

```text
iterations/
  1/
    readme.md
    prompt.md
  2/
    readme.md
    prompt.md
  3/
    readme.md
    prompt.md
  4/
    readme.md
    prompt.md
  ...
```

Each numeric iteration represents a cumulative improvement to the same system.

The root prompt must **not** assume that the latest iteration fully replaces all previous ones.
Instead, the root prompt must:
1. detect the current installed iteration in the target repository
2. determine which iterations are missing
3. execute the missing iterations in ascending numeric order
4. preserve existing learnings, memory, telemetry, and configuration
5. work both for:
   - fresh installation
   - in-place upgrade

This prompt must be designed so it **does not need to be rewritten every time a new iteration is added**.
It must dynamically inspect the `iterations/` directory and use whatever numeric iterations exist.

---

# PRIMARY GOAL
Install or upgrade the Codex Context Engine in the target repository by applying all required iterations in the correct order.
The system must be robust, incremental, and safe.

It must never blindly reinstall everything if a partial or full installation already exists.
It must never destroy useful state unless cleanup is clearly required and safe.

---

# OPERATING MODEL
Treat this repository as the **source of truth** for the Codex Context Engine.
Treat the target repository (the repo where this prompt is being executed) as the **installation target**.

Your task is to inspect the target repository, determine what version of the engine is already installed, and then apply only the iterations that are still missing.

---

# DO NOT HARDCODE ITERATION COUNT
Do not assume the latest iteration number is 4.
Instead:
1. inspect the local `iterations/` directory in this repository
2. discover all numeric iteration folders dynamically
3. sort them numerically ascending
4. treat the highest discovered number as the latest available iteration

This rule is mandatory.

The root orchestrator must continue working when new iterations are added later without requiring manual changes to this root prompt.

---

# ITERATION DISCOVERY RULES
Within this repository:
- only numeric folders under `iterations/` count as iterations
- ignore non-numeric folders or auxiliary files
- each valid iteration folder should contain:
  - `readme.md`
  - `prompt.md`

If an iteration folder is malformed:
- do not fail immediately
- report the issue clearly
- continue if safe
- do not invent missing iteration content

---

# TARGET REPOSITORY DETECTION
Before applying anything, inspect the target repository for signs of an existing Codex Context Engine installation.

Possible evidence may include:
- `AGENTS.md`
- `.codex_memory/`
- `.context_metrics/`
- `.codex_global_metrics/`
- `.codex_failure_memory/`
- `.codex_task_memory/`
- `.codex_memory_graph/`
- `CONTEXT_SAVINGS.md`
- files or comments explicitly mentioning `codex_context`
- iteration metadata files if present
- prior generated schemas, summaries, scoring metadata, telemetry, or diagnostic artifacts

Use these signals to determine whether the engine is already installed and, if possible, which iteration level has already been applied.

---

# INSTALLATION STATE DETECTION
Your first responsibility is to determine the **current installed iteration** in the target repository.
Use this strategy, in order:

## 1. Explicit state markers
If the target repository contains a clear iteration/version marker, use it.
Examples:
- installed iteration metadata file
- version field in a configuration file
- explicit note in generated engine artifacts

## 2. Structural capability detection
If no explicit marker exists, infer the installed iteration by detecting installed capabilities.
Use conservative inference.

Example signals by capability:

### Iteration 1 signals
- basic external memory artifacts
- persistent preference storage
- primitive memory structure
- fallback-oriented context memory setup

### Iteration 2 signals
- structured `.codex_memory/`
- telemetry artifacts such as `.context_metrics/`
- `CONTEXT_SAVINGS.md`
- validation-oriented files
- more explicit bootstrap / delta retrieval setup

### Iteration 3 signals
- deterministic context packet schema
- relevance scoring metadata
- compaction reports or compaction utilities
- scoring-aware memory records

### Iteration 4 signals
- `.codex_global_metrics/`
- project registration in global metrics
- global savings aggregation
- system health report for the engine

### Iteration 5 signals
- context packet cost estimation
- context budget thresholds
- optimization or trimming reports
- compression / pruning rules tied to budget

### Iteration 6 signals
- planning artifacts or planner logic
- task-type or task-signal classification before retrieval
- explicit context loading strategy selection
- predicted repository areas before packet assembly

### Iteration 7 signals
- `.codex_failure_memory/`
- structured failure records
- stored root causes and fixes
- retrieval of prior failure patterns during debugging flows

### Iteration 8 signals
- `.codex_task_memory/`
- task-type-specific knowledge buckets
- specialized retrieval by workflow category
- distinct memory slices for tasks such as tests, refactors, debugging, or architecture

### Iteration 9 signals
- `.codex_memory_graph/`
- graph node / edge artifacts
- graph expansion during retrieval
- relationship-aware context selection
- bounded connected-context traversal

### Iteration 10 signals
- task logs or telemetry schemas that support `task_id`
- task logs or telemetry schemas that support `level` such as `task` / `phase`
- phase labels such as `phase_name`
- weekly summaries exposing granular fields such as `phase_events_sampled`
- analyzer behavior that aggregates phase-only rows into task-level savings summaries without double counting

### Iteration 11 signals
- `.codex_library/`
- `.codex_library/registry.json`
- `.codex_library/mods/`
- mod manifests such as `.codex_library/mods/<mod_id>/mod.json`
- evidence of knowledge mods created through commands such as `learn <mod>` or `aprende <mod>`
- engine artifacts referencing "knowledge mods" or local domain learning

### Iteration 12 signals
- processed knowledge artifacts under `.codex_library/mods/<mod_id>/`
- directories such as:
  - `notes/`
  - `summaries/`
  - `indices/`
  - `manifests/`
- evidence of document ingestion pipelines
- normalized document sources or extracted text artifacts
- topic indices or retrieval metadata generated from documents

### Iteration 13 signals
- retrieval artifacts referencing indices or retrieval maps
- logic selecting artifacts from `notes/`, `summaries/`, or `indices/`
- retrieval packs assembled from `.codex_library/`
- code paths that load compact knowledge artifacts instead of raw documents
- evidence of topic-aware knowledge retrieval

Infer the highest iteration that is **safely supported by the evidence**.
If uncertain, prefer a lower installed iteration rather than overestimating.

## 3. Fresh install assumption
If no meaningful evidence exists, assume no installation is present.

---

# EXECUTION RULE
Once the current installed iteration is known:
- if none is installed, apply all iterations in ascending order
- if iteration N is installed, apply N+1 through latest
- if latest is already installed, do not reinstall blindly

Even if the latest iteration appears installed, you may still:
- normalize malformed files
- repair clearly incomplete artifacts
- report inconsistencies
- avoid destructive rewrites

---

# HOW TO APPLY EACH ITERATION
For each missing iteration:
1. open `iterations/<N>/prompt.md`
2. treat it as the authoritative specification for that iteration
3. apply the required changes in the target repository
4. preserve existing compatible state
5. perform migrations only when necessary
6. avoid duplicating content unnecessarily
7. continue to the next missing iteration

You must apply iterations strictly in ascending order.

Do not skip an intermediate iteration unless:
- its folder is missing or malformed, and
- proceeding is still safe, and
- you clearly report the limitation

---

# RUNTIME DEPENDENCY BOOTSTRAP
After all required iterations have been applied, verify whether `ruby` is installed before running engine maintenance or integration scripts.

Rules:
- check for `ruby` explicitly
- if `ruby` is not available, install it using the safest native package path for the host environment
- only proceed to Ruby-based engine scripts after Ruby is available
- if Ruby installation fails, report the failure clearly and do not pretend script execution succeeded

This applies in particular to cross-project integration flows that execute scripts such as:
- `scripts/install_cross_project_for_all_repos.rb`

---

# UPGRADE SAFETY RULES
When upgrading an existing installation:
- preserve memory records whenever possible
- preserve telemetry unless it is clearly broken or incompatible
- preserve preferences unless normalization is required
- preserve existing `AGENTS.md` rules unless they conflict with engine behavior
- prefer in-place upgrades
- avoid replacing the whole system if only one layer is missing

Never erase useful history just because a newer iteration exists.

---

# AGENTS.md POLICY
If `AGENTS.md` exists in the target repository:
- update it carefully
- merge new engine requirements without destroying unrelated project instructions
- avoid duplicated sections
- preserve user/project-specific instructions whenever possible

If `AGENTS.md` does not exist:
- create it only if required by the iterations being applied

The Codex Context Engine should continue using `AGENTS.md` as the authoritative runtime policy layer when the installed iterations require that pattern.

---

# STATE TRACKING
To make future upgrades reliable, ensure the installation leaves behind a **clear installed iteration marker** in the target repository.

Preferred options include one of the following:
- a lightweight metadata file
- a version field in an existing engine file
- a clearly named engine state artifact

The marker should minimally record:
- engine identifier: `codex_context_engine`
- installed iteration number
- timestamp of last upgrade

Keep it lightweight and machine-readable.

If a compatible marker already exists, update it.
This is important so future executions of the root prompt can detect state reliably.

---

# COMPATIBILITY WITH FUTURE ITERATIONS
This root prompt must remain forward-compatible.

That means:
- do not refer to a fixed final iteration number
- always derive available iterations from the `iterations/` directory
- always use discovered iteration prompts as the source of truth
- always upgrade only from current state to latest discovered state

This root prompt should remain valid even after Iteration 5, 6, 7, 8, 9, and beyond are added.

---

# FAILURE HANDLING
If one iteration cannot be applied cleanly:
1. stop before making unsafe assumptions
2. preserve the target repository state as much as possible
3. report exactly which iteration failed and why
4. report which iterations were successfully applied before the failure
5. do not pretend the engine is fully upgraded if it is not

If partial upgrade is the safest outcome, say so clearly.

---

# VALIDATION AFTER UPGRADE
After applying the missing iterations:
1. verify that the installed iteration marker reflects the highest successfully applied iteration
2. verify that major artifacts expected by the applied iterations exist
3. verify that required runtime dependencies for bundled scripts are available, especially `ruby` when `.rb` scripts are part of the installation
4. execute the required engine scripts after dependency checks succeed
5. verify that the installation remains coherent
6. verify that no obvious destructive conflict was introduced
7. report any caveat or incomplete area

Do not fabricate validation.
Keep it honest and concise.

---

# GIT SAFETY
If generated support files are created in Git-controlled directories:
- update `.gitignore` when appropriate
- do not accidentally ignore real source files
- preserve intentional tracking if the repository already tracks certain engine artifacts on purpose

---

# OUTPUT FORMAT
At the end, return a concise final summary containing:
1. discovered iterations available in this repository
2. detected installed iteration in the target repository
3. whether this was a fresh install or upgrade
4. which iterations were applied in this run
5. whether any repair / normalization was performed
6. the final installed iteration after successful completion
7. any important caveat or partial-failure note
8. whether granular telemetry / phase-level instrumentation is supported after the run
9. whether mods, library and mcp instrumentation is supported after the run
10. the status of the tool
---

# EVOLUTION ROADMAP
The engine evolves through incremental capability layers.

## Iteration 5 — Context Cost Optimizer
Reduces token usage and latency by filtering, deduplicating, compressing, and prioritizing context before it is sent to the model.

## Iteration 6 — Context Planner
Determines which context should be loaded depending on task type, repository signals, and likely execution scope.

## Iteration 7 — Failure Memory
Stores previous failures, dead ends, and effective fixes so the engine avoids repeating ineffective actions.

## Iteration 8 — Task-Specific Memory
Adds specialized memory layers per workflow type so retrieval can adapt to testing, debugging, refactoring, architecture, and similar tasks.

## Iteration 9 — Memory Graph
Connects memory entities through explicit relationships so the engine can retrieve bounded neighborhoods of related knowledge instead of only flat records.

## Iteration 10 — Granular Telemetry
Extends savings telemetry from task-only estimates into backward-compatible task-plus-phase instrumentation so the engine can identify which subtasks, loops, or prompt phases consume the most context and tokens.

## Iteration 11 — Knowledge Mods
Introduces a generic mod system and a local knowledge workspace (`.codex_library/`) that allows Codex to learn domain knowledge across executions.

Knowledge areas can be created dynamically (for example `learn ux` or `learn accessibility`) and persist structured knowledge about those domains.

## Iteration 12 — Knowledge Processing Pipeline
Adds a document ingestion pipeline that converts raw documents into compact reusable artifacts such as notes, summaries, and indices.

This allows the engine to reuse structured knowledge without repeatedly loading full source documents.

## Iteration 13 — Knowledge Retrieval Engine
Adds a retrieval layer that selects the most relevant artifacts from the local knowledge library for a given request.

Instead of loading large documents, the engine uses indices and retrieval maps to assemble minimal high-value context packs.