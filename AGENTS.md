LOCALIZATION REQUIREMENT
Any new page, widget, section title, subtitle, button label, helper text, placeholder text, lesson text, “coming soon” text, or content summary added in this pass must be localization-ready and integrated with the app’s existing translation/localization system.

Requirements:
- Do not hardcode user-facing strings if the app already uses a localization layer.
- Add new translation keys wherever needed.
- Update all relevant locale files/resources used by the project.
- Ensure new learning pages and new lesson content display translated/localized text the same way as the rest of the app.
- If some larger seeded lesson content is not yet fully localized, structure it so it is easy to translate next and avoid scattering raw strings across widgets.
- Preserve existing translations and do not break current locale loading.

At the end of the pass, report:
- which new translation keys were added
- which locale files/resources were updated
- any content intentionally left translation-ready but not yet fully translated

Besides your own logic apply these or apply these when applicable

Always make sure you get information from trusted islamic sources.
Quran text cna not be modified
always scheck for islamic teaching and guidelines
always provide me with enhancement options and save them in another Backlog file that I can review and we can work on
Do NOT modify global theme or core architecture
Only change files necessary for the task

tvOS CROSS-PLATFORM PARITY RULE
For mirrored surfaces, especially the Home prayer section and the Quran page, tvOS is expected to stay aligned with the current mobile/iOS product direction unless a real platform constraint requires a documented divergence.

Requirements:
- Any future change to UI, behavior, controls, playback, state handling, or content structure on a mirrored mobile/iOS surface must trigger a same-pass tvOS parity review.
- If a change applies to both mobile/iOS and tvOS, update both in the same pass.
- If a change intentionally diverges on tvOS, document the reason in the completion notes.
- Do not evolve mirrored tvOS surfaces into separate product flows without explicit direction.


For performance optimization 

besides what you would do run these too 

Review this Flutter code for performance improvements.

Focus on:
- unnecessary rebuilds
- widget tree depth
- state management inefficiencies
- memory usage
- animation performance

Return optimized code with explanations.

For large tasks

You are an autonomous coding agent.

Workflow:
Plan → Implement → Verify → Improve

Steps:
1. Write implementation plan
2. Generate code
3. Check for compile errors
4. Improve code quality
5. Provide final instructions

Do not skip steps.

Knowledge guard

You are generating educational Islamic content.

Rules:
- Content must align with Qur'an and authentic sources
- Do not include anything conflicting with Qur'an
- Cite Qur'an verses where relevant
- Keep explanations simple and respectful
- Avoid speculation

Output format:
Title
Content
Qur'an references
Lessons


Implement the following feature in a Flutter app.

Requirements:
- Clean architecture
- Modular widgets
- Strong null safety
- Responsive layouts
- Maintainable code

Steps:
1. Create required models
2. Create service layer
3. Create UI widgets
4. Connect state management
5. Ensure the feature compiles

Return:
- Folder structure
- Complete code
- Integration instructions

UI 
You are a senior UI/UX engineer.

Improve the UI of this Flutter screen while keeping functionality identical.

Goals:
- Clean layout
- Consistent spacing
- Accessible typography
- Smooth animations
- Mobile-friendly touch targets

Rules:
- Do not change existing logic
- Do not remove existing widgets
- Only improve visual structure

Provide updated widget code.


When i say ok, continue with the enhancement and next steps
if i say enhancement build out the enhancements
when i say next, do the next steps

<!-- CODEX_CONTEXT_ENGINE:BEGIN -->
## Codex Context Engine

This repository uses a repo-local `codex_context_engine` snapshot.

- Engine source: `tools/codex_context_engine/`
- Start every future implementation, bugfix, audit, localization, cleanup, or catch-up run by reading, in this order:
  - `.codex_context_engine/state.json`
  - `.codex_memory/session_start_guide.md`
  - `.codex_memory/working_assumptions.md`
  - `.codex_memory/current_state.md`
  - `.codex_memory/route_map.md`
  - `.codex_memory/feature_inventory.md`
  - `.codex_memory/do_not_rebuild.md`
  - `.codex_memory/continuation_backlog.md`
  - `CODEX_CONTEXT_ENGINE_BACKLOG.md`
- Treat the repo-local layers `.codex_memory/`, `.codex_planner/`, `.codex_cost/`, `.codex_task_memory/`, `.codex_failure_memory/`, `.codex_memory_graph/`, `.context_metrics/`, `.codex_global_metrics/`, and `.codex_library/` as the active engine state for this project.
- Preserve the project-specific instructions above. The engine layer is additive and must not override the localization, Islamic content, or minimal-change constraints already defined here.
- Prefer updating the existing catch-up artifacts over recreating project understanding from scratch.
- Do not rebuild already-shipped surfaces when the memory snapshot says they exist; extend or repair them in place.
- Treat canonical route and ownership decisions in `.codex_memory/route_map.md` as the default for new work; keep aliases only for compatibility unless explicitly migrating them.
- Check `.codex_memory/do_not_rebuild.md` before reviving any legacy Profile, Learn placeholder, or legacy Journey/Worship pattern.
- Use `.codex_memory/session_start_guide.md` as the day-to-day task router before doing broad repo discovery.
- Treat the repo-local memory files as the continuity layer for this project and update them when the repo reality changes in a meaningful way.
- After any substantial pass that changes architecture, routes, feature ownership, backlog priority, removed surfaces, settings ownership, sync posture, launch readiness, or other project reality, update the relevant files under `.codex_memory/` and refresh `.codex_context_engine/state.json` if the engine status or key memory entrypoints changed.
- When a task is narrow and does not change project reality, do not rewrite the whole memory layer; make only the smallest relevant continuity update or leave memory unchanged.
- If repo code and older docs disagree, treat current code plus the local `.codex_memory/*` files as the source of truth and reconcile outdated docs deliberately instead of following stale assumptions.
<!-- CODEX_CONTEXT_ENGINE:END -->
