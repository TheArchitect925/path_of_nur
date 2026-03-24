# Phase V4 Prompt — Navigation System Stabilization

===== PHASE V4 PROMPT — NAVIGATION SYSTEM STABILIZATION =====

PRIMARY OBJECTIVE === BUILDING NAVIGATION SYSTEM STABILIZATION

You are working in the existing Flutter codebase for Path of Nūr.

This is a navigation architecture cleanup and stabilization phase.

The goal is to make platform navigation cleaner, safer, easier to scale, and easier to audit without breaking existing behavior.

Critical rule:
Do not go haywire deleting or removing routes, screens, or records for no reason.
Preserve current behavior unless a route is clearly obsolete and fully replaced safely.

“And hold firmly to the rope of Allah all together and do not become divided.” — Qur’an 3:103

⸻

TASK TYPE

Navigation architecture cleanup, route normalization, canonical path enforcement, and route ownership refactor.

⸻

PRODUCT GOAL

The app currently has a strong platform structure, but navigation has started to accumulate:
	•	canonical routes
	•	legacy aliases
	•	section redirects
	•	duplicated entry points
	•	oversized route registries

This phase should:
	1.	identify the real route structure,
	2.	preserve working behavior,
	3.	normalize canonical ownership,
	4.	split route definitions into maintainable feature-owned files,
	5.	reduce future routing bugs.

This is not a redesign of the product IA.
This is a stabilization and architecture cleanup pass.

⸻

EXECUTION RULES
	1.	Audit first before editing anything.
	2.	Do not remove working user-facing functionality.
	3.	Do not break deep links, existing route names, or known entry points unless safely redirected.
	4.	Prefer canonical routes over duplicated routes.
	5.	Use redirects or compatibility wrappers where needed instead of destructive removal.
	6.	Preserve localization, shared shell behavior, and current guard behavior.
	7.	Preserve onboarding, profile launch, child restrictions, and shell navigation exactly unless a bug is clearly found.
	8.	Keep implementation production-ready and maintainable.
	9.	At the very end, run an audit summary of what changed, what remains, and any follow-up risks.

⸻

IMPLEMENTATION SCOPE

A. Audit the current navigation system first

Before making changes, audit the navigation architecture and identify:

1. Core app entry flow

Confirm and document the actual flow:
	•	main.dart
	•	PathOfNurApp
	•	MaterialApp.router
	•	GoRouter
	•	redirect/guard layer
	•	ShellRoute
	•	app shell / bottom navigation tabs

2. Canonical tabs

Confirm current canonical tab routes:
	•	/home
	•	/worship
	•	/learn
	•	/journey
	•	/quran

3. Oversized or risky route registries

Audit current route files, especially:
	•	app_router.dart
	•	learn_routes.dart
	•	any related route group files

Identify:
	•	oversized files
	•	mixed ownership
	•	duplicate responsibilities
	•	alias sprawl
	•	compatibility routes
	•	routes that should remain canonical
	•	routes that should remain as redirects only

4. Learn navigation complexity

Audit the Learn surface specifically:
	•	LearningSectionLandingPage
	•	category-based routing
	•	quizzes/games routing
	•	kids routing
	•	Qur’an-related Learn aliases
	•	Prophets aliases
	•	section aliases
	•	legacy browse/explore aliases

Identify what is:
	•	canonical
	•	legacy alias
	•	compatibility redirect
	•	duplicate but still needed temporarily
	•	safe to consolidate

5. Cross-domain route relationships

Identify current navigation links between:
	•	Learn ↔ Qur’an
	•	Learn ↔ Kids
	•	Learn ↔ Quizzes/Games
	•	Qur’an ↔ Hadith / Life / Prophets
	•	Tools/Explore ↔ other modules

Do not redesign cross-domain navigation in this phase, but document where it is currently fragmented.

⸻

B. Define the canonical navigation structure

After the audit, establish a clean canonical navigation model.

Canonical top-level tabs should remain:
	•	/home
	•	/worship
	•	/learn
	•	/journey
	•	/quran

Canonical feature ownership direction

Use these principles:

Qur’an-owned
Prefer canonical Qur’an routes under:
	•	/quran/*

Keep Learn-owned Qur’an aliases only if required for compatibility.

Learn-owned
Keep true Learn content under:
	•	/learn/*

Kids learning
Keep under Learn if that matches the current product model, but organize clearly:
	•	/learn/kids/*

Quizzes / games
Keep current experience working, but make ownership clearer:
	•	/learn/games
	•	/learn/quizzes/*

FAQ / Notes / Tools
Keep current routes stable, but ensure one canonical route per real destination.

⸻

C. Split oversized route definitions into feature-owned route builders

Refactor route definitions into smaller files.

Target direction

If current route files are too large, split them into focused route registries such as:
	•	learn_core_routes.dart
	•	learn_kids_routes.dart
	•	learn_quiz_routes.dart
	•	learn_hadith_routes.dart
	•	learn_world_routes.dart
	•	learn_life_routes.dart
	•	learn_quran_alias_routes.dart

You may adjust filenames if the codebase structure suggests a better naming pattern.

Rules
	•	Keep buildLearnRoutes() as the composition entry point if that is the safest option.
	•	Do not change public behavior unnecessarily.
	•	Do not move files around excessively just for aesthetics.
	•	Keep imports and ownership clean.

⸻

D. Normalize aliases and redirects safely

Audit all duplicate paths and normalize them.

For each non-canonical route, decide:
	•	keep as canonical
	•	keep as redirect
	•	keep temporarily as compatibility alias
	•	remove only if fully unused and fully safe

Examples of likely candidates
	•	/learn/browse vs /learn/explore
	•	/learn/hub/quran vs /quran/*
	•	/learn/hub/prophets vs /learn/prophets
	•	/learn/section/* aliases
	•	other old compatibility paths

Rules
	•	Prefer redirects over duplicated pageBuilder implementations where safe
	•	Keep query parameters preserved across redirects
	•	Keep path parameters preserved
	•	Avoid route loops
	•	Avoid changing route names unless absolutely necessary
	•	If route names are already used widely, preserve them

⸻

E. Preserve and clarify guard behavior

Do not break guard behavior currently enforced in app_router.dart.

Preserve:
	•	onboarding redirects
	•	shared device profile selection flow
	•	child profile learning restrictions
	•	deep link mapping behavior
	•	router error behavior
	•	shell navigation behavior

If possible, extract logic into clearer helper functions or policy helpers without changing behavior.

Possible direction:
	•	onboarding route policy helper
	•	shared device route policy helper
	•	child learning route policy helper
	•	deep link resolver helper

Only do this if it improves clarity safely.
Do not over-refactor for the sake of refactoring.

⸻

F. Improve navigation ownership clarity

Introduce a light navigation ownership layer if helpful.

Goal

Make it easier to know:
	•	which route is canonical
	•	which file owns a route
	•	which routes are aliases only
	•	which areas belong to Learn vs Qur’an vs Kids vs Games

Acceptable implementation options

You may create a lightweight registry/helper such as:
	•	navigation_registry.dart
	•	route comments / route ownership markers
	•	grouped constants
	•	helper methods for canonical route generation

Do not overengineer a whole new routing framework.

⸻

G. Keep Learn taxonomy aligned, but do not rebuild it fully

There is already a Learn taxonomy / category model.

In this phase:
	•	keep it working
	•	keep category → route resolution stable
	•	fix mismatches where taxonomy points to non-canonical or messy routes if safe
	•	preserve existing category IDs and slugs unless there is a very strong reason not to

Do not do a broad IA redesign here.

⸻

H. Make route intent obvious in code

After refactoring, code should make it easy to understand:
	•	app entry flow
	•	shell flow
	•	canonical top-level tabs
	•	Learn route composition
	•	compatibility aliases
	•	route ownership

Use clear comments where useful, especially around:
	•	compatibility routes
	•	alias redirects
	•	canonical route policy
	•	child-learning restrictions
	•	legacy route preservation

⸻

I. Do not break deep links or in-app linking

Be careful with:
	•	pushNamed
	•	route names
	•	pathParameters
	•	queryParameters
	•	deep link mapping helpers
	•	chips/cards/buttons linking between domains

If consolidating routes:
	•	preserve existing route names where possible
	•	preserve expected navigation targets
	•	preserve query parameter forwarding
	•	preserve old external/internal links by redirect if needed

⸻

J. Add a route audit summary artifact in code comments or docs if helpful

If useful, create a concise internal doc or code comment summary that explains:
	•	canonical route groups
	•	compatibility route groups
	•	major aliases retained
	•	follow-up cleanup candidates for later phases

Keep it concise and maintainable.

⸻

VALIDATION

After implementation, validate all of the following:

Core app structure
	1.	App still boots correctly
	2.	MaterialApp.router still uses the correct router
	3.	guards still work

Top-level tabs
	4.	/home, /worship, /learn, /journey, /quran still work
	5.	shell navigation still works
	6.	current tab detection still works

Learn flows
	7.	Learn landing still works
	8.	category routes still work
	9.	kids routes still work
	10.	quizzes/games routes still work
	11.	FAQ / notes / tools routes still work

Qur’an flows
	12.	canonical /quran/* flows still work
	13.	retained Learn aliases still redirect or resolve correctly

Redirect behavior
	14.	alias routes preserve path/query behavior correctly
	15.	no redirect loops
	16.	no broken named-route calls introduced

Code health
	17.	route ownership is clearer than before
	18.	route files are smaller / more maintainable where possible
	19.	analyzer passes on changed files

⸻

DELIVERABLES

Implement the navigation stabilization refactor.

Then provide a concise summary with:
	1.	Audit findings before changes
	•	biggest issues found
	•	duplicated route groups
	•	oversized files
	•	canonical vs alias findings
	2.	Files changed
	•	list all changed files
	•	list any new route registry files created
	3.	Canonical routing decisions
	•	which routes remain canonical
	•	which routes are now redirects
	•	which compatibility aliases were retained
	4.	Guard behavior
	•	confirm what was preserved
	•	mention if any policy helpers were extracted
	5.	Risk check
	•	anything still intentionally deferred
	•	any alias cleanup left for a future phase
	6.	Validation
	•	analyzer results
	•	route behavior confirmation
	7.	Final audit
	•	summarize whether platform navigation is now cleaner, safer, and easier to scale

⸻

IMPORTANT SAFETY / PRODUCT RULE

This is a stabilization phase.
Do not turn it into a redesign.
Do not remove routes aggressively.
Do not delete code just because it looks legacy if it is still serving compatibility or deep-link stability.

Build on top of what exists. Normalize carefully. Preserve behavior.
