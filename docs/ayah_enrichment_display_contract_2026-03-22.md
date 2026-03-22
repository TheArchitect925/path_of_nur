# Ayah Enrichment Display Contract

Date: 2026-03-22

## Purpose

This contract defines the canonical structure for ayah enrichment so the Qur'an reader and ayah detail surfaces can show multiple intentional knowledge items under one ayah without relying on weak associations or page-local logic.

## Canonical domains

The fixed enrichment domains are:

- `tawhidBelief`
- `worshipRemembrance`
- `characterAdab`
- `akhirahAccountability`
- `signsInCreation`
- `worldNature`
- `prophetsLessons`
- `guidanceDailyLife`

These map to Learning Hub ownership as follows:

- `tawhidBelief` -> Qur'an Learning
- `worshipRemembrance` -> Qur'an Learning, Worship & Practice
- `characterAdab` -> Divine Life Lessons, Character & Adab
- `akhirahAccountability` -> Qur'an Learning, Divine Life Lessons
- `signsInCreation` -> Qur'an Learning, World & Creation
- `worldNature` -> World & Creation
- `prophetsLessons` -> Prophets & Stories, Qur'an Learning
- `guidanceDailyLife` -> Divine Life Lessons, Qur'an Learning

## Lesson types

The fixed lesson types are:

- `coreLesson`
- `reflection`
- `practicalTakeaway`
- `warning`
- `reminder`
- `connection`

Usage rules:

- `coreLesson`: direct, stable teaching drawn clearly from the ayah
- `reflection`: reflective prompt or contemplative takeaway
- `practicalTakeaway`: real-life application grounded in the ayah
- `warning`: accountability, caution, or moral warning
- `reminder`: hopeful or corrective reminder
- `connection`: a valid supporting bridge into another learning surface

## Tag system

Normalized reusable tags:

- `sabr`
- `shukr`
- `tawakkul`
- `mercy`
- `repentance`
- `justice`
- `sincerity`
- `guidance`
- `signs`
- `creation`
- `prophets`
- `worship`

Rules:

- tags are for discoverability and filtering
- tags do not replace domain assignment
- tags must be semantically stable and reusable across multiple ayahs

## Linking rules

Allowed link strengths:

- `direct`
- `strongThematic`
- `contextual`

Definitions:

- `direct`: the ayah explicitly supports the lesson or theme
- `strongThematic`: the ayah clearly and responsibly supports the theme, even if the exact wording is broader than the lesson title
- `contextual`: useful supporting context, but not the primary ayah teaching

Weak/unacceptable links are not valid canonical enrichment and should not be added.

Unacceptable examples:

- linking an ayah only because a broad Islamic concept appears elsewhere
- stretching a creation ayah into a hard scientific claim without caution metadata
- using a verse as a prophet/story link when the connection is only distant or inferred

## Caution and interpretation system

Structured fields:

- `interpretationNote`
- `cautionNote`
- `cautionLevel`

Allowed caution levels:

- `none`
- `interpretationSensitive`
- `scientificCare`

Use these especially for:

- scientific-signs content
- cosmology and nature interpretations
- contextual readings where multiple legitimate understandings exist

## Display item types

Canonical ayah-detail item types:

- `hadithReference`
- `ayahInsight`
- `signsInCreation`
- `scientificReflection`
- `worldCreationLesson`
- `worshipLesson`
- `characterLesson`
- `prophetConnection`
- `relatedAyah`
- `reflectionPrompt`
- `interpretationNote`

Rules:

- item type describes how something is rendered and understood on the ayah detail surface
- item type must be intentional, not inferred loosely from display text

## Display contract

Ayah detail surfaces should:

- show multiple relevant items when justified
- surface the strongest, most useful items first
- allow mixed item families when they are genuinely relevant
- avoid duplication and clutter
- keep caution-sensitive items visually distinguishable

Each display item supports:

- typed item family
- title
- summary
- optional route/action target
- optional caution state
- optional source enrichment id
- optional related ayah reference
- explicit link strength
- explicit display priority

## Display priority rules

V1 priority rules:

1. direct linked primary lessons first
2. strong practical/worship/character lessons next
3. signs/world creation items after direct core lessons
4. interpretation notes after primary content
5. related ayahs and reflection prompts lower

V1 visible cap:

- show up to `6` mixed display items per ayah/range surface

This prevents flooding while still allowing one ayah to show multiple meaningful items.

## Data contract rules

Canonical enrichment entries must include:

- ayah reference
- domain
- lesson type
- link strength
- title
- summary
- body
- normalized tags

Optional but structured:

- reflection prompts
- interpretation note
- caution note
- caution level
- display item type
- route/source handoff
- related ayahs
- display priority

Entries should not be admitted into canonical structured enrichment if they are weakly linked, vague, or too incomplete to justify display.
