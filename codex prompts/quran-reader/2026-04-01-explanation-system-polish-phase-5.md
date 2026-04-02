# ===== PHASE X PROMPT phase 5 — QURAN EXPLANATION SYSTEM POLISH, ATTRIBUTION METADATA, SCALE-UP, AND QA HARDENING =====

PRIMARY OBJECTIVE === BUILDING QURAN EXPLANATION SYSTEM POLISH, ATTRIBUTION METADATA, SCALE-UP, AND QA HARDENING

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

===== QURAN EXPLANATION SOURCE & VALIDATION RULE =====

All Qur’an explanation content MUST follow authentic tafsir methodology.

When generating explanation content:

1. Determine the meaning using:
   - Qur’an (cross-referenced ayahs)
   - authentic tafsir grounding (e.g., Ibn Kathir-level understanding)
   - widely accepted interpretations from mainstream Sunni scholarship

2. Then simplify into Path of Nūr language:
   - simple
   - standard
   - kids

3. STRICT RULES:
   - Do NOT copy tafsir text directly
   - Do NOT invent interpretations
   - Do NOT introduce speculative or modern reinterpretations without grounding
   - If meaning is unclear or disputed, keep explanation general and safe

4. PRIORITY:
   - accuracy over creativity
   - clarity over depth
   - simplicity without distortion

5. If uncertain:
   - fallback to a safe, widely accepted general meaning
   - never guess or over-interpret

===== END =====

At the very end, audit everything and provide one full summary.

TASK TYPE
Production hardening and scale-up of the Qur’an explanation system across the main reader and kids reader.

GOAL
Take the explanation system from initial implementation to a launch-quality, scalable feature by:
- polishing UI behavior
- improving content fallback and display rules
- adding internal attribution/source metadata support
- expanding seeded explanation coverage beyond the initial pack
- reducing duplication
- validating routing, settings persistence, and performance
- hardening the entire reader explanation experience for production

IMPORTANT PRODUCT DIRECTION
This phase is not about changing the architecture again.
It is about making the current system:
- clean
- trustworthy
- scalable
- stable
- polished
- consistent across adult and kids flows

The final experience should feel deliberate and mature, not like layered patches.

EXECUTION RULES
1. Audit first before editing.
2. Do not rebuild the system from scratch if the architecture is already sound.
3. Reuse the explanation system already added in prior phases.
4. Prioritize cleanup, consistency, polish, and safety.
5. Preserve localization.
6. Preserve adult/kids separation while sharing explanation infrastructure where appropriate.
7. Avoid introducing regressions in reader behavior.
8. Run analyzer on changed files and summarize results.
9. At the end provide one full audit summary and implementation summary.

AUDIT REQUIREMENTS

A. Audit current explanation system end-to-end
Identify and verify:
- explanation domain model ownership
- explanation repository/provider ownership
- reader settings persistence ownership
- main reader explanation rendering
- kids reader explanation rendering
- fallback behavior
- any duplicated logic between adult and kids paths
- any temporary or awkward implementation shortcuts left from earlier phases

B. Audit UX consistency
Review:
- explanation section labels
- show more / show less behavior
- expansion logic
- mode-aware rendering
- kids vs adult presentation differences
- visual hierarchy inside the reader
- whether explanation UI feels too heavy or too sparse in any mode

C. Audit content structure scalability
Review whether current seeded content organization is ready for:
- more surahs
- more ayahs
- future multilingual explanations
- future attribution UI
- future editorial review process

IMPLEMENTATION REQUIREMENTS

D. Polish main reader explanation UX
Refine the main reader explanation experience so it feels finished.

Review and improve:
- spacing
- typography hierarchy
- explanation card/subsection tone
- labels
- expansion affordances
- interaction consistency across different ayah cards
- reflection prompt rendering
- key lesson rendering

Preferred result:
- reading mode remains light
- reflection mode feels calm and reflective
- study mode feels fuller without becoming crowded
- memorization mode stays focused
- theme mode still prioritizes theme relationships without explanation clutter

E. Polish kids reader explanation UX
Refine the kids reader explanation experience so it feels clearly child-friendly and calmer than the adult reader.

Review and improve:
- amount of text shown
- layout softness
- readable font sizing
- control simplicity
- fallback trimming for standard explanations shown in kids mode
- one-teaching-at-a-time behavior

Preferred result:
- simple
- friendly
- very readable
- no academic overload
- no adult-style complexity leaking in

F. Add internal attribution/source metadata support
Add or refine a structured internal attribution system for explanation entries.

This does NOT need to become a full public-facing citation UI yet.
But the data model should support internal grounding metadata such as:
- source type
- source label
- optional note
- optional confidence / editorial flag if useful
- optional internal reference grouping

Examples of source types:
- quran_cross_reference
- hadith_grounding
- classical_tafsir
- simplified_summary
- kids_simplification

Requirements:
- keep it lightweight
- do not overcomplicate the UI
- structure it so a future “based on trusted tafsir sources” UI can be added safely
- do not expose internal technical clutter in the reader unless it is subtle and helpful

G. Add subtle attribution-ready UI support if appropriate
Optionally add a very subtle line or badge for adult/main reader only if it improves trust and does not clutter the UI.
Examples:
- “Based on trusted tafsir sources”
- “Simplified explanation”

This must remain:
- optional
- subtle
- not noisy
- not shown in kids reader unless there is a very strong reason

If this UI makes the page noisier, skip it and keep metadata internal only.

H. Expand seeded explanation coverage
Expand beyond the initial explanation pack in a controlled and high-quality way.

Preferred scale-up order:
1. foundational beginner ayahs
2. more short surahs
3. high-frequency recitation surahs
4. commonly memorized ayahs
5. selected core study ayahs

Do NOT try to force full Qur’an coverage in one unsafe pass unless the repo already has an editorially safe structure and the content quality can be maintained.

The expansion should remain:
- curated
- clean
- scalable
- safe

If full coverage is not realistic in one pass, structure the content system cleanly for staged growth.

I. Add editorial scalability hooks
Prepare the system for future editorial review by making it easier to:
- see which ayahs have explanation coverage
- identify which detail levels are missing
- add more content later without messy edits
- track partial rollout safely

This can be done through:
- clean indices
- grouped files
- light metadata
- coverage maps
- content organization helpers

Do not build an entire CMS.
Just make the local data maintainable.

J. Harden fallback behavior
Review all adult and kids explanation fallback paths.

Ensure:
- no broken empty sections
- no accidental deep/adult leakage into kids mode unless absolutely needed
- no null/empty strings treated as valid content
- consistent fallback ordering everywhere
- consistent handling of missing reflection prompts / key lessons / source refs

K. Remove duplication and cleanup
If the current implementation duplicated:
- explanation selection logic
- display mapping logic
- fallback trimming logic
- expansion logic
- content adaptation logic

refactor it into shared helpers/services where appropriate.

Keep final ownership clean:
- shared data logic
- shared fallback logic
- shared content adaptation helpers where useful
- adult UI specific logic
- kids UI specific logic

L. Localization hardening
Audit all new explanation-related user-facing strings:
- labels
- control names
- fallback messages if any
- badges
- show more / show less
- kids-specific wording

Ensure localization coverage is complete and naming is consistent.

M. Reader route and settings hardening
Verify:
- explanation preferences survive navigation
- mode switching does not break explanation rendering
- deep links / route parameters do not break explanation sections
- kids/adult defaults remain separate
- settings persistence remains stable

N. Performance and rendering hardening
Audit and improve performance where needed.

Pay attention to:
- long surah rendering
- per-ayah provider lookups
- repeated explanation resolution work
- expansion state management
- rebuild hotspots

Avoid heavy work inside item builders if it can be resolved more cleanly.

O. QA pass
Perform a final QA-oriented audit for:
- reading mode
- reflection mode
- study mode
- memorization mode
- theme mode
- kids reader
- explanation off/simple/standard/deep/kids states
- missing content
- seeded content edge cases
- playback coexistence
- notes/bookmarks coexistence

P. Safety / integrity
Do not regress:
- main reader audio/playback
- follow ayah behavior
- memorization review
- notes
- bookmarks
- existing insights / theme chips / related reference systems
- kids-safe reading flow
- current theme/study routing

Q. Cleanup and final production shaping
Remove dead code, temporary adapters, awkward naming, or placeholder wiring left from earlier phases.
The final explanation system should feel like it belongs in the codebase permanently.

VALIDATION
1. Confirm the explanation system works cleanly in main reader and kids reader.
2. Confirm adult and kids defaults remain separate.
3. Confirm internal attribution metadata exists and is usable for future UI.
4. Confirm fallback behavior is consistent everywhere.
5. Confirm seeded explanation coverage expanded safely.
6. Confirm no reader regressions.
7. Confirm localization is complete.
8. Confirm analyzer passes on changed files.

DELIVERABLES
After implementation, provide:
- full audit summary
- files changed
- cleanup/refactor summary
- attribution metadata design
- expanded coverage summary
- fallback hardening summary
- performance/QA notes
- analyzer results
- follow-up recommendations for future full-Qur’an coverage strategy

===== END =====
