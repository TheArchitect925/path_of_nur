
# codex_context_global_metrics_prompt.md
## Codex Context External Memory — Iteration Four
### Global Metrics, Cross‑Project Telemetry and System Health

This prompt installs **Iteration Four** of the Codex Context External Memory system.

Iteration Four introduces a **global metrics and telemetry layer** that can aggregate savings
across multiple repositories using the Codex Context system.

This prompt must work in **two modes**:

1. Upgrade mode — If an existing Codex Context system is already installed (iteration 1–3).
2. Fresh install mode — If the repository has no context system yet.

The implementation must never break an existing installation.

---

# OBJECTIVE

Iteration Four introduces a global reporting layer so users can obtain:

- total context savings across projects
- token reduction across projects
- latency improvements across projects
- adoption statistics of iterations
- health diagnostics of the context system

The system should allow a prompt such as:

"Generate a global savings report for the Codex Context system."

to produce a report across all repositories using the system.

---

# SYSTEM DETECTION

Before installing anything, inspect the repository for existing components.

Possible indicators:

AGENTS.md
.codex_memory/
.context_metrics/
context telemetry logs
iteration prompts
memory JSONL files

Behavior:

If an existing installation is detected → upgrade in place  
If no installation exists → install full system

Never delete existing learnings or telemetry.

---

# GLOBAL METRICS LAYER

Introduce a global telemetry structure that can aggregate metrics across repositories.

Create the directory:

.codex_global_metrics/

Suggested structure:

.codex_global_metrics/
  projects_index.json
  global_context_savings.json
  global_token_savings.json
  global_latency_metrics.json
  system_health_report.json
  telemetry_sources.json

---

# PROJECT REGISTRATION

Each repository using the system should register itself in the global index.

Example entry in projects_index.json:

{
  "projects": [
    {
      "name": "example_project",
      "repo_path": ".",
      "telemetry_dir": ".context_metrics/",
      "memory_dir": ".codex_memory/",
      "installed_iteration": "4"
    }
  ]
}

If the project already exists in the index, update the iteration number if needed.

---

# TELEMETRY AGGREGATION

Aggregate telemetry data from:

.context_metrics/
.codex_memory/
CONTEXT_SAVINGS.md

Aggregation tasks:

- sum total context savings
- estimate token reduction
- estimate latency improvement
- track iteration distribution
- detect missing telemetry

If telemetry is missing for some repositories, mark them as "unknown".

---

# GLOBAL REPORT GENERATION

Allow Codex to answer:

"Generate a global savings report for the Codex Context system."

Report must include:

Total projects detected  
Projects by iteration version  
Estimated context reduction  
Estimated token reduction  
Estimated latency improvement  
Confidence level of estimates  

Explain any missing data clearly.

---

# SYSTEM HEALTH CHECK

Support the command:

"Run a Codex Context system health check."

Checks should verify:

bootstrap behavior
memory availability
telemetry activity
compaction availability
global metrics consistency

Output should populate:

system_health_report.json

Health states:

healthy  
warning  
needs_attention  

---

# AGENTS POLICY UPDATE

Update AGENTS.md to include rules for:

global metrics awareness
project registration
global reporting capability
health checks

Do not remove rules from earlier iterations.

---

# MEMORY COMPATIBILITY

If previous iterations created .codex_memory/, preserve all records.

Add metadata only when needed.

Missing metadata should receive default values.

---

# GIT SAFETY

Ensure generated directories are ignored unless intentionally tracked.

Recommended entries:

.codex_memory/
.context_metrics/
.codex_global_metrics/

---

# VALIDATION

After installation verify:

system upgrades safely from earlier iterations  
system installs correctly from scratch  
projects register in the global index  
telemetry aggregation works  
global reports can be generated  
health checks run successfully  

---

# SUCCESS CRITERIA

Iteration Four is successful if:

multiple repositories contribute telemetry  
global context savings can be estimated  
system health diagnostics work  
existing installations remain compatible  
the system remains lightweight
