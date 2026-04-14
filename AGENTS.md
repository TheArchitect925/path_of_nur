# AGENTS.md

## 🧠 Core Operating Rules

- Work in the existing Flutter codebase.
- Make the smallest production-ready change that fully solves the task.
- Audit briefly → implement directly.
- Do not create logs, markdown files, archives, prompt files, or backlog files unless explicitly requested.
- Do not refactor unrelated code.
- Preserve:
  - routing
  - localization
  - theme
  - architecture
- Reuse existing services, providers, and widgets before creating new ones.
- No placeholder or fake implementations.

---

## 🌍 Localization (STRICT)

- Do not hardcode user-facing strings.
- Add translation keys when needed.
- Update existing locale files only.
- Do not break current localization.

Report only if changes were made:
- new translation keys
- updated locale files

---

## ☪️ Islamic Content Guard

- Content must align with Qur’an and authentic sources.
- Qur’an text must not be modified.
- Avoid speculation.
- Keep explanations simple and respectful.

---

## 🎨 UI + Theme Rules

- Use existing shared UI system.
- Do not create page-specific themes.
- Follow:
  - kids theme
  - main theme
- Do not redesign UI unless explicitly requested.

---

## 🔍 Search + Discoverability

- Reuse existing search/indexing systems.
- Do not create new search logic.
- Add searchable metadata only if needed.

---

## 📖 Qur’an Interaction

- All structured Qur’anic references must be tappable.
- Use shared Qur’an navigation and link helpers.
- Do not create custom implementations.

---

## ⚡ Performance (ONLY WHEN REQUESTED)

Focus on:
- unnecessary rebuilds
- widget tree depth
- state management efficiency
- memory usage

---

## 🧩 Large Task Mode (ONLY WHEN NEEDED)

For complex features only:

1. Plan (brief)
2. Implement
3. Verify (compile/analyze)
4. Improve (if needed)

---

## 📦 Delivery Format (STRICT)

Return only:

1. What changed  
2. Files changed  
3. Validation (analyze/compile)  
4. Risks (only if important)

---

## 🚫 Explicitly Forbidden

- No prompt archive files
- No cleanup archive folders
- No codex logs
- No backlog files unless explicitly requested
- No long explanations
- No duplicate systems
- No speculative improvements
