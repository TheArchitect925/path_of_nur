
# Codex Context External Memory — Iteration Three
## Deterministic Context, Relevance Scoring, and Memory Compaction

This prompt implements **Iteration Three** of the Codex Context External Memory system.

It upgrades the existing system if present, or installs it from scratch if not.

Main improvements introduced in this iteration:

1. Deterministic Context Packets
2. Context Relevance Scoring
3. Memory Compaction Engine

The goal is to make context injection predictable, reduce irrelevant memory retrieval, and keep the memory layer healthy over time.

---

# TASK

Upgrade or install the Codex Context system with the following capabilities:

• Deterministic context packet generation  
• Memory relevance scoring  
• Automatic memory compaction  
• Compatibility with existing installations  
• Graceful fallback to normal Codex behavior  

The system must **complement existing installations** if they exist.

If the system does not exist, install it from scratch.

---

# SYSTEM DETECTION

Before installing anything, inspect the repository for an existing system.

Possible indicators:

AGENTS.md  
.codex_memory/  
.context_metrics/  
CONTEXT_SAVINGS.md  
existing memory JSONL files  
existing telemetry scripts  

Behavior:

If the system exists → upgrade in place  
If the system does not exist → install full system

Never destroy useful existing memory.

---

# FEATURE 1 — DETERMINISTIC CONTEXT PACKETS

Replace loosely assembled context injection with deterministic context packets.

Every task should generate a structured packet similar to:

{
  "task_summary": "",
  "task_type": "",
  "repo_scope": [],
  "user_preferences": [],
  "constraints": [],
  "architecture_rules": [],
  "relevant_memory": [],
  "known_patterns": [],
  "fallback_mode": ""
}

Requirements:

• Stable schema  
• Compact structure  
• Deterministic fields  
• Graceful degradation when fields are missing  

Context packets must remain small.

---

# FEATURE 2 — CONTEXT RELEVANCE SCORING

Upgrade memory records to include scoring metadata.

Suggested fields:

relevance_score  
last_used_at  
times_used  
success_rate  
context_cost  
source_type  
staleness_score  

Retrieval should prefer:

• highly relevant records  
• recent records  
• historically successful records  
• low context cost records

Prefer **few high‑quality entries** over large memory dumps.

Older records missing fields should receive safe defaults.

---

# FEATURE 3 — MEMORY COMPACTION ENGINE

Introduce a compaction system to keep memory clean.

The engine should detect:

• duplicate records  
• near‑duplicate records  
• stale records  
• overly verbose entries  
• fragmented learnings

Compaction operations:

detect duplicates  
merge compatible records  
prune low‑value entries  
rebuild boot summaries  
generate compaction reports

Compaction must be conservative.

Never delete clearly valuable memory.

Dry‑run mode is preferred when possible.

---

# AUTHORITATIVE POLICY LAYER

AGENTS.md must remain the runtime instruction layer.

Ensure AGENTS.md contains:

Session Bootstrap rules
User preference rules
Context engine rules
Fallback behavior

Bootstrap rule example:

At the start of every Codex session:

1 load user preferences  
2 load compact boot summary  
3 load deterministic context packet logic  
4 apply default interaction preferences  
5 fallback if memory unavailable

---

# MEMORY STRUCTURE

If not present, create:

.codex_memory/

Suggested structure:

.codex_memory/
  user_preferences.json
  architecture_learnings.jsonl
  technical_patterns.jsonl
  workflow_learnings.jsonl
  memory_index.json
  derived_boot_summary.json
  context_packet_schema.json
  compaction_report.json

---

# RETRIEVAL FLOW

classify_task  
detect_repo_scope  
retrieve_candidate_memory  
score_memory_records  
select_top_records  
build_context_packet  
fallback_if_needed

Keep retrieval lightweight.

---

# BOOT SUMMARY

Maintain a compact boot summary containing:

• user preferences
• key architecture decisions
• repository conventions
• workflow guidance
• context packet rules

File:

derived_boot_summary.json

This file must stay small.

---

# USER PREFERENCES

Preferences should influence:

verbosity  
explanation style  
workflow behavior  
coding conventions  
output density  
collaboration style  

Rules:

• applied automatically  
• overridable per task  
• persistent across sessions  
• never block task completion

Preferences may exist in both:

AGENTS.md (policy)  
.codex_memory/user_preferences.json (data)

---

# MEMORY MIGRATION

If earlier systems exist:

preserve useful learnings  
normalize metadata  
add scoring defaults  
avoid data loss

Possible legacy sources:

codex_content  
older .codex_memory formats  
prompt‑generated artifacts

---

# TELEMETRY COMPATIBILITY

If telemetry exists:

.context_metrics/

Maintain compatibility.

Optional telemetry improvements:

packet size estimation  
memory selection counts  
compaction events  
scoring impact

Telemetry must stay lightweight.

---

# GIT SAFETY

If the repository uses Git:

ensure these are ignored unless intentionally tracked:

.codex_memory/
.context_metrics/

Do not accidentally ignore real project files.

---

# VALIDATION

After implementation verify:

• system works with existing installation  
• system installs correctly from scratch  
• context packets are deterministic  
• relevance scoring filters memory correctly  
• compaction runs safely  
• preferences still apply automatically  
• fallback behavior works  

---

# SUCCESS CRITERIA

The iteration succeeds if:

• context injection becomes deterministic  
• memory retrieval becomes selective  
• memory remains compact over time  
• existing installations remain compatible  
• the system remains simple and maintainable
