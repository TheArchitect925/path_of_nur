
# Codex Ultra Context System — Installation Prompt (Optimized)

This prompt installs a **persistent context memory and preference system for Codex** that guarantees:

- automatic initialization in every new session and chat
- consistent application of user preferences
- context memory retrieval with graceful fallback
- optional telemetry for measuring improvements

The system must rely on **repository-level instructions** so that Codex automatically applies them whenever it operates in the repository.

The installation must modify or create all required files automatically.

The system must never break existing project behavior.

---

# TASK

Implement a **Codex Ultra Context Engine** with:

1. automatic session bootstrap
2. persistent user preferences
3. structured project memory
4. delta context retrieval
5. graceful fallback behavior
6. optional telemetry support

The system must rely on **AGENTS.md as the authoritative runtime instruction layer**.

---

# HIGH LEVEL GOAL

The objective is to improve Codex performance by:

- reducing unnecessary context loading
- preserving reusable project knowledge
- ensuring consistent user interaction preferences
- enabling automatic context reuse between sessions

The system must function automatically without the user having to explicitly activate it.

---

# SESSION BOOTSTRAP GUARANTEE

The most important requirement:

**Codex must initialize the context engine at the beginning of every new session or chat.**

This behavior must be enforced via instructions inside `AGENTS.md`.

---

# MODIFY OR CREATE AGENTS.md

Locate an existing `AGENTS.md`.

If it exists:
append the following sections.

If it does not exist:
create it.

Add:

## Session Bootstrap

At the start of every new Codex session or chat operating in this repository, Codex must automatically:

1. Load persistent user preferences.
2. Load project context memory summaries.
3. Load architecture and technical learnings.
4. Apply user interaction preferences.
5. Use these as default operating constraints for the session.

This bootstrap must run automatically for every session.

If any memory artifact is missing or unavailable, Codex must gracefully fall back to normal repository analysis.

---

## User Interaction Preferences

User preferences define the **default interaction style and workflow expectations**.

Codex must apply these preferences automatically in every session.

Preferences may include:

- response verbosity
- explanation style
- preferred level of detail
- coding style conventions
- workflow preferences
- collaboration mode with AI tools

Rules:

1. Preferences apply by default in all tasks.
2. The user may override preferences explicitly for a specific task.
3. Overrides apply only to that task.
4. Preferences must not block task completion.

---

## Context Memory System

Codex must use a lightweight external memory structure to retain reusable knowledge about the project.

The memory system should store:

- architecture decisions
- debugging patterns
- reusable solutions
- repository conventions
- tool workflows
- technical learnings

The memory system must:

- store structured records
- avoid storing raw conversation transcripts
- keep entries compact and reusable

---

# CREATE MEMORY DIRECTORY

Create directory:

.codex_memory/

Structure:

.codex_memory/
    user_preferences.json
    architecture_learnings.jsonl
    technical_patterns.jsonl
    workflow_learnings.jsonl
    derived_boot_summary.json

Purpose:

user_preferences.json
stores durable user interaction preferences.

architecture_learnings.jsonl
stores architecture decisions and system structure knowledge.

technical_patterns.jsonl
stores debugging or implementation patterns.

workflow_learnings.jsonl
stores effective workflows discovered during development.

derived_boot_summary.json
stores a compact summary used during session bootstrap.

---

# DELTA CONTEXT RETRIEVAL

Codex must avoid loading full memory.

Instead it should retrieve only relevant entries.

Pseudo process:

classify_task(task)

retrieve_relevant_memory(task_type)

build_context_packet()

inject_context_packet()

The context packet must remain small.

---

# LEARNING EXTRACTION

After completing tasks, Codex may store reusable knowledge.

Examples of valid learnings:

- repeated bug fixes
- architecture insights
- build system fixes
- workflow optimizations

Examples of invalid learnings:

- conversation text
- temporary reasoning
- trivial edits

---

# FALLBACK BEHAVIOR

If the memory system fails or produces no relevant results:

Codex must proceed with normal repository inspection.

The context system must never block task completion.

---

# OPTIONAL TELEMETRY SUPPORT

If telemetry is desired, create:

.context_metrics/

Files:

.context_metrics/
    task_logs.jsonl
    weekly_summary.json

Telemetry should record:

- task type
- estimated context size
- task packet size
- model used
- reasoning complexity

Telemetry must remain lightweight.

---

# GIT SAFETY

If the repository uses Git:

Add to `.gitignore` if not present:

.codex_memory/
.context_metrics/

Ask the user before tracking them.

---

# SUCCESS CRITERIA

The system is correctly installed if:

- Codex automatically initializes the context engine in every session.
- User preferences apply without being re-stated.
- Memory retrieval works but does not inflate context.
- The system falls back gracefully when memory is unavailable.
- The installation does not break repository functionality.
