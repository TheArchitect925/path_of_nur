# Iteration 6 — Context Planner

You are implementing **Iteration 6 — Context Planner** for `codex_context_engine` inside the **target repository**.

This iteration must extend the existing engine without breaking the current **autoincremental flow**.
Assume Iterations 1–5 may already be present and that future iterations will continue to extend the engine in ascending order.

## Mission

Introduce a **planning layer** that decides how context retrieval should behave before the engine assembles the final packet.

The planner should help the engine answer questions such as:

- what kind of task is this?
- which memory layers are worth consulting?
- how broad should retrieval be?
- should graph expansion stay shallow or widen?
- should the engine favor a narrow or broader packet strategy?

This iteration is about **routing context intelligently before retrieval**, not about replacing retrieval itself.

---

## Non-negotiable constraints

- Preserve the existing **autoincremental engine flow**.
- Do **not** rewrite the root orchestration model.
- Do **not** remove or invalidate existing memory, telemetry, metrics, or iteration markers.
- Do **not** break deterministic context packet generation from previous iterations.
- Prefer **additive and backward-compatible** changes.
- Migrate existing state conservatively.
- Focus on implementing Iteration 6 capability in the target repository, not on packaging this engine repo.

---

## Iteration 6 goal

Add a **Context Planner** that allows the engine to:

1. infer the likely shape of the active task
2. decide which context layers should be consulted
3. choose an appropriate retrieval breadth/depth
4. produce inspectable planning signals for later stages
5. fall back safely when planner confidence is weak

This iteration should make the engine better at **loading the right context before execution begins**.

---

## Expected planner responsibilities

### 1. Task-shape resolution

Implement a lightweight planning signal that classifies the task at a useful level.

At minimum, the planner should be able to detect signals such as:

- bug fixing / repair
- refactoring / restructuring
- tests / validation
- performance / optimization
- architecture / system design
- general / unknown

The logic must remain:

- deterministic where practical
- simple
- inspectable
- easy to maintain

Do not use opaque or overfit routing logic.

### 2. Context layer selection

The planner should decide which retrieval layers are relevant for the task.

Depending on the task, it may prioritize or de-prioritize:

- general repository memory
- failure memory
- task-specific memory when later iterations exist
- memory graph expansion when later iterations exist
- local file / module context
- broader repository-level context

The planner should not require every layer to exist.
It must degrade gracefully when later iteration layers are absent.

### 3. Retrieval breadth / depth control

The planner should provide a bounded routing signal for retrieval scope.

Examples:

- narrow: local fix, specific files, minimal expansion
- medium: local subsystem, a few related areas
- broad: architecture, cross-cutting refactor, repo-wide decisions

This should remain a planning hint, not an uncontrolled expansion mechanism.

### 4. Packet assembly guidance

The planner should emit structured guidance that downstream stages can use while assembling the final packet.

Examples of useful planning output:

- resolved task shape
- selected context layers
- retrieval scope
- expansion caps
- budget posture hint
- fallback reason if confidence is weak

Keep the output compact, machine-readable, and human-inspectable.

### 5. Fallback compatibility

The system must still work safely when:

- the task cannot be classified confidently
- planner signals are partial
- only legacy memory exists
- later iteration layers are not installed

In those cases, the planner should prefer safe defaults instead of aggressive exploration.

---

## Data model guidance

If no planner artifact exists yet, introduce a minimal structure such as a planner state or plan summary under a repository-local area consistent with current engine conventions.

A planner record may contain fields such as:

- `task_shape`
- `confidence`
- `selected_layers`
- `retrieval_scope`
- `expansion_limit`
- `notes`
- `updated_at`

Keep the format simple and inspectable.

---

## Integration rules

When integrating the Context Planner:

- do not bypass existing engine stages
- place planner output **before retrieval and packet assembly**
- preserve deterministic packet logic from previous iterations
- keep planning concise rather than verbose
- avoid turning the planner into another memory dump

If earlier stages already expose metadata hooks, reuse them rather than creating a disconnected parallel flow.

---

## Metrics and observability

Where coherent with the existing engine, extend observability so the system can report useful planning behavior, such as:

- resolved task shape
- selected retrieval scope
- chosen context layers
- fallback-to-safe-default events
- planner usage count

Do this in the same spirit as earlier telemetry: useful and compact, not noisy.

---

## Migration strategy

If previous engine artifacts exist, perform a safe additive migration.

Possible actions:

- create planner artifacts only if missing
- initialize planner defaults conservatively
- leave ambiguous legacy artifacts untouched
- avoid destructive rewrites

Prefer conservative migration over speculative reclassification.

---

## AGENTS.md / runtime policy updates

If the target repository uses `AGENTS.md` as the runtime policy layer, update it carefully so future runs understand:

- Context Planner exists
- planning happens before retrieval
- retrieval should remain bounded
- safe fallback behavior is mandatory

Do not overwrite unrelated project instructions.
Merge cleanly.

---

## Validation requirements

Before finishing, verify at least:

1. Iteration 6 artifacts are present and coherent
2. the engine still works when planner signals are missing
3. planner output falls back safely for ambiguous tasks
4. retrieval still works with only legacy memory layers
5. existing memory/telemetry/metrics remain preserved
6. any installed iteration marker is updated if the engine uses one

Do not claim validation you did not perform.

---

## Deliverables in the target repository

Implement the necessary code, config, schemas, docs, and policy updates required for **Iteration 6 — Context Planner**.

Also update relevant documentation so maintainers understand:

- what the planner decides
- where planner output is stored
- how it affects retrieval
- how it falls back safely

---

## Final response format

At the end, return a concise summary with:

1. how the planner resolves task shape
2. which files/systems were added or changed
3. how planner output is stored
4. how retrieval now uses planner guidance
5. what migration was performed
6. what validation was completed
7. any limitation or follow-up note
