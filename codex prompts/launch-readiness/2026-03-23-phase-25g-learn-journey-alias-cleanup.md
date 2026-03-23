# Phase 25G Prompt — Learn / Journey Alias Cleanup

PRIMARY OBJECTIVE === BUILDING LEARN / JOURNEY ALIAS CLEANUP FOR PATH OF NŪR WITHOUT BREAKING COMPATIBILITY

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED ROUTING / DISCOVERY CLEANUP phase.
This is NOT a broad rebuild.
This is NOT a feature expansion phase.
This is NOT a generic cleanup sweep.

Previous phases already improved:
- route integrity
- regression trust
- live localization
- Qur’an ownership clarity
- writing-system cohesion

This phase must now reduce alias-heavy surface ambiguity across Learn and Journey while preserving backward compatibility.

========================================================
CORE GOAL
========================================================

Make canonical Learn and Journey destinations clearer in discovery, product framing, and routing behavior, while keeping compatibility paths functional and avoiding abrupt removal of legacy routes.

========================================================
CURRENT PROBLEM TO SOLVE
========================================================

The app still carries compatibility-heavy route families and secondary entry points that dilute clarity, especially around:

- Learn legacy/front-door overlap
- Journey vs Growth alias families
- compatibility routes that still feel primary in discovery
- secondary discovery paths that should behave more like redirects or hidden compatibility paths

This phase is about reducing ambiguity, not deleting useful functionality.

========================================================
APPROVED DIRECTION
========================================================

Unless code evidence strongly proves otherwise, treat this as the intended direction:

1. `/learn*` remains the canonical Learn family.
2. `/journey*` remains the canonical Journey family.
3. `/growth*` should behave as compatibility, not co-equal ownership.
4. legacy Learn aliases should not behave like primary discovery unless explicitly justified.
5. compatibility routes may remain, but surfaced discovery should favor canonical owners.
6. redirects/demotion are preferred over abrupt removal.

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- delete pages, routes, or user data for no reason
- break existing callers
- remove compatibility aliases entirely unless clearly safe and explicitly justified
- redesign the entire Learn IA
- redesign Journey IA
- redo Qur’an ownership cleanup
- reopen writing-system architecture
- broaden scope into unrelated polish
- go haywire and remove/delete records or functionality for no reason

========================================================
PHASE SCOPE
========================================================

This phase should focus on:

1. Learn alias families and discovery entry points
2. Journey/Growth alias families and discovery entry points
3. canonical-vs-compatibility route surfacing
4. demotion of compatibility-only discovery paths
5. redirect behavior where clearly safe
6. reducing duplicate product framing between canonical and compatibility routes
