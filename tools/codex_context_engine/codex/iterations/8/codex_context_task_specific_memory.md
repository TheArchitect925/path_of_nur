# Codex Prompt — Iteration 8: Task-Specific Memory

You are implementing **Iteration 8 — Task-Specific Memory** for the `codex_context_engine` inside the target repository.

This iteration must preserve the **autoincremental flow** of the engine.
It extends the current engine without breaking previous iterations, without replacing the root orchestrator logic, and without destroying existing memory, telemetry, or optimizer/planner behavior.

## High-level goal

Add a **task-specialized memory layer** that allows the engine to store and retrieve contextual knowledge depending on the type of task being executed.

The engine already has:
- persistent repository memory
- structured context retrieval
- deterministic packet assembly
- metrics and diagnostics
- context cost optimization
- context planning
- failure memory

This iteration adds a new capability:

> The engine should not rely only on general repository memory.
> It should also keep memory specialized by task domain so Codex can retrieve patterns that are more relevant for the current kind of work.

Examples:
- bug fixing tasks should retrieve debugging heuristics, recurring fault zones, and prior fix patterns
- refactoring tasks should retrieve structural constraints, coupling notes, and prior architectural adjustments
- testing tasks should retrieve flaky areas, test conventions, and validation patterns
- performance tasks should retrieve bottlenecks, measurement notes, and previous optimization attempts
- architecture tasks should retrieve design decisions, boundaries, and subsystem relationships

---

## Mandatory implementation constraints

1. **Maintain the autoincremental engine flow**
   - do not redesign the engine from scratch
   - do not bypass earlier iterations
   - do not remove planner / optimizer / failure-memory behavior
   - integrate task-specific memory as an additional layer that cooperates with the existing system

2. **Do not add into your response any instruction to create the iteration folder structure or prompt/readme files for this engine repo**
   - assume that packaging/documentation for this iteration is handled outside the target repository
   - focus only on implementing the actual engine capability inside the target repository

3. **Preserve backward compatibility**
   - if task-specific memory does not exist yet, initialize it safely
   - if no task type can be inferred for a given execution, the engine must gracefully fall back to generic memory behavior
   - never make task-specific memory a hard requirement for successful execution

4. **Be deterministic and inspectable**
   - task type inference should follow explicit rules
   - saved task-specific memory should be human-readable
   - retrieval decisions should be explainable from repository artifacts

5. **No destructive rewrites**
   - do not delete existing memory or telemetry unless a migration is strictly required and safe
   - prefer additive and in-place evolution

---

## Conceptual model

The new layer should sit naturally inside the existing flow:

```text
User task
  ↓
Context Planner
  ↓
Task Type Inference
  ↓
Task-Specific Memory Retrieval
  ↓
Generic Memory Retrieval
  ↓
Failure Memory Retrieval
  ↓
Context Packet Assembly
  ↓
Context Cost Optimizer
  ↓
Codex execution
  ↓
Post-task learning / updates
```

This means task-specific memory is **not a replacement** for generic memory.
It is a **specialized contextual layer** that improves relevance for particular task classes.

---

## What to implement

Implement the following capabilities in the target repository.

### 1. Task type taxonomy

Create a small, explicit, extensible task taxonomy.

At minimum support:
- `bug_fixing`
- `refactoring`
- `testing`
- `performance`
- `architecture`
- `feature_work`
- `unknown`

Do not overcomplicate the taxonomy.
Keep it practical and repository-agnostic.

### 2. Task type inference

Add deterministic task classification rules based on available execution signals.
Use whichever engine artifacts already exist, but keep the logic simple and inspectable.

Possible signals may include:
- user task text
- changed files or targeted files
- planner output
- failure memory context
- directory names
- test-related commands or filenames
- performance-related vocabulary
- architecture-oriented vocabulary

Examples of useful heuristics:
- if the task emphasizes fixing an error, exception, regression, failing build, or failing test → `bug_fixing`
- if the task emphasizes cleanup, simplification, extraction, renaming, modularization → `refactoring`
- if the task emphasizes adding/updating tests or validating behavior → `testing`
- if the task emphasizes speed, memory, latency, throughput, bottlenecks → `performance`
- if the task emphasizes design, boundaries, data flow, module interaction, architecture decisions → `architecture`
- if the task primarily adds or changes product behavior without stronger signals above → `feature_work`
- otherwise → `unknown`

The classification system must:
- be deterministic
- support confidence notes if useful
- degrade safely to `unknown`
- avoid pretending certainty when evidence is weak

### 3. Task-specific memory storage

Add a task-specialized memory area to the engine.
Use a repository-local, inspectable structure.

Recommended structure:

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

Inside each category, store lightweight machine-readable and human-readable records.

You may use a layout such as:
- one summary file per category
- optional record files per pattern / decision / lesson
- index metadata if helpful

Keep the structure simple.
Do not create an overengineered database.

### 4. Task-specific memory schema

Define a compact schema for task memory records.
The schema should be stable, readable, and easy to append to.

A record may include fields like:
- `task_type`
- `title`
- `summary`
- `signals`
- `common_locations`
- `patterns`
- `constraints`
- `frequent_mistakes`
- `preferred_validation`
- `related_files`
- `last_updated`
- `confidence`
- `source`

Do not require every field on every record.
Allow sparse entries.

### 5. Retrieval integration

Update the engine’s retrieval logic so that when a task type is inferred:
- relevant task-specific memory is queried first or early
- results are merged with generic memory and failure memory
- the planner can use task type as a routing signal
- the optimizer can still trim the final packet if needed

Important:
- task-specific memory must improve relevance, not explode context size
- retrieval should prefer concise summaries over dumping all category records
- use ranking, capping, or summary-first behavior where appropriate

### 6. Learning / update behavior

After a task completes, the engine should be able to update task-specific memory with new reusable learnings.

Examples of what may be learned:
- common files touched during a kind of task
- recurring validation steps
- recurrent mistakes in that task class
- stable constraints discovered during refactoring
- common failure patterns relevant to bug fixing
- performance-sensitive hotspots

The learning behavior must:
- stay concise
- avoid storing noisy one-off details unless clearly reusable
- prefer durable patterns over session trivia
- avoid duplicating equivalent entries

### 7. Fallback behavior

If no reliable task type is inferred:
- classify as `unknown`
- continue normal engine execution
- do not block context retrieval
- optionally learn generalized patterns into `unknown`

### 8. Observability

Add lightweight observability for this layer.
At minimum make it possible to inspect:
- inferred task type
- whether task-specific memory was used
- which category was queried
- whether new task-specific memory was written

This may be integrated into existing metrics / diagnostics if those systems already exist.
Do not add noisy telemetry for its own sake.

---

## Integration expectations

Your implementation should align with the current engine philosophy:
- persistent context over repeated prompting
- minimal relevant context over large generic dumps
- additive evolution via iterations
- safe upgrades over rewrites
- inspectable repository-local intelligence

The new task-specific memory layer should work **with**:
- planner signals
- generic repository memory
- failure memory
- context packet assembly
- context cost optimizer

The likely priority order is:
1. infer task type
2. retrieve relevant task memory
3. merge with generic and failure knowledge
4. build the packet
5. let the optimizer trim if necessary

---

## Migration / upgrade behavior

If the target repository already has a previous engine installation:
- preserve all prior artifacts
- add the task-specific memory layer in-place
- add/update any state marker needed so the engine can detect that Iteration 8 is installed
- update existing documentation or runtime policy files only if necessary and only safely

If some adjacent systems already exist under a different naming convention:
- normalize conservatively
- avoid destructive renames unless clearly justified
- preserve compatibility when possible

---

## Validation requirements

Before finishing, validate that:
- task type inference exists and is deterministic
- task-specific memory storage exists and is readable
- retrieval path uses task type when available
- fallback to generic execution still works
- no prior engine layer has been broken
- any iteration marker / engine state reflects the newly installed iteration if the engine uses one

Do not claim success without checking the implemented artifacts.

---

## Output requirements for Codex

When you execute this task, do the work directly in the target repository and then return a concise implementation summary including:
- what task-specific memory artifacts were added or updated
- how task type inference works
- how retrieval now integrates task-specific memory
- how learning/update behavior was wired
- any migration or compatibility note
- what was validated

Be concrete.
Do not pad the answer.
Do not describe imaginary files that were not actually created.
