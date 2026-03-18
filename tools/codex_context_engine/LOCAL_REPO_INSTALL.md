# Local Repo Install

This repository contains a local snapshot of `codex_context_engine` from:

- upstream: `https://github.com/oldskultxo/codex_context_engine`
- commit: `93a80266e2917fe9c4b8d541f533cc1837975186`

## Install mode used here

This repo uses a **repo-local install**.

- Upstream engine files live under `tools/codex_context_engine/`.
- Active engine state for this project lives at the repository root:
  - `.codex_context_engine/`
  - `.codex_memory/`
  - `.context_metrics/`
  - `.codex_global_metrics/`
  - `.codex_cost/`
  - `.codex_planner/`
  - `.codex_task_memory/`
  - `.codex_failure_memory/`
  - `.codex_memory_graph/`
  - `.codex_library/`

## Why the cross-project installer was not used

The upstream Ruby installer is designed for shared cross-project deployments and scans a global projects directory. The user requested this repository be self-contained and ready locally with minimal manual work, so the install here keeps all operational state inside this repo.

## Important limitation

The upstream `README.md` references python runtime scripts such as `scripts/boot.py`, `scripts/packet.py`, `scripts/query.py`, and `scripts/global_metrics.py`. Those files are **not present** in the fetched upstream snapshot as of the pinned commit above, so this install operationalizes the engine through the local memory/state artifacts instead of those missing entrypoints.
