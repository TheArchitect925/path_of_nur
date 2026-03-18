# Repo hygiene enhancement backlog

Non-blocking follow-ups after the README, lint, and CI hardening pass:

1. Add a lightweight PR template once release workflows stabilize.
2. Add one focused CI job for iOS host-side verification when Apple platform structure is finalized.
3. Add a small script or make-style wrapper for common commands if the team wants shorter local commands.
4. Revisit one or two additional lint rules later:
   - `prefer_final_locals`
   - `directives_ordering`
   only after measuring repo-wide churn.
5. Add a dedicated release engineering doc once watchOS/tvOS platform work is real rather than planned.
