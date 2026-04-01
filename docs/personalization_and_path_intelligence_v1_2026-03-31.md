# Personalization and Path Intelligence V1

Date: 2026-03-31

## Executive summary

Path of Nūr now has a production-safe Learn personalization layer that stays rule-based, local-first, and explainable.

This phase adds:
- a lightweight user learning profile derived from existing app signals
- a deterministic recommendation engine for Learn
- a new `Your Next Step` surface on `/learn`
- path sequencing logic for safer next-best-path suggestions
- lightweight Friday / Ramadan / inactivity / momentum context handling

This pass does not replace canonical content owners. It orchestrates them.

## Signals used

Reusable safe signals:
- guided path active path + next step
- guided path started/completed sets
- guided path last-updated / completed timestamps
- unified Learn progress counts and recent updated Learn domains
- Qur'an recent readings
- Qur'an reading time today
- Qur'an learning personalization state
- Dhikr recent session count
- child-profile visibility policy
- Ramadan mode setting

Signals intentionally not used yet:
- deep per-page analytics ranking
- opaque engagement scoring
- aggressive cross-domain heuristics
- any external AI or remote recommendation service

## User learning profile model

Core types live under `lib/features/learn/personalization/domain/learning_personalization_models.dart`.

Main concepts:
- `LearningSignals`
- `UserLearningProfile`
- `LearningIntentSignal`
- `LearningEngagementState`
- `PersonalizedLearnRecommendation`
- `PathSuggestion`
- `LearningPathSequenceDefinition`

The profile stays lightweight and explainable:
- primary learning intent
- secondary intents
- engagement state
- history presence
- child-profile safety
- last learn activity timestamp

## Recommendation engine overview

The engine lives in:
- `lib/features/learn/personalization/application/learning_recommendation_engine.dart`

It answers:
1. what is the best next action now
2. which path should be recommended next
3. what secondary suggestions are reasonable
4. why the recommendation was chosen

## Primary recommendation logic

Priority order:
1. active guided path next step
2. next sequenced path after a recent completion
3. kids-safe starter for child profiles
4. Ramadan-aware Qur'an or Dhikr recommendation
5. Friday Qur'an rhythm suggestion
6. resume a recently started incomplete path
7. Qur'an momentum recommendation
8. Dhikr momentum recommendation
9. Salah momentum recommendation
10. no-history beginner recommendation
11. dormant re-entry recommendation
12. intent-based fallback
13. safe final fallback

Each recommendation includes:
- kind
- reason
- route target
- optional path id
- optional step id
- optional context badge

## Next-best-path sequencing model

Sequence registry:
- `lib/features/learn/personalization/data/learning_path_sequence_registry.dart`

V1 sequencing:
- Foundations -> Salah / Qur'an Beginner / Daily Dhikr
- Salah -> Daily Dhikr / Character
- Qur'an Beginner -> Character / Daily Dhikr
- Daily Dhikr -> Character / Qur'an Beginner
- Character -> Qur'an Beginner / Daily Dhikr
- Kids Starter -> Kids Starter follow-through lane

This is intentionally data-driven instead of widget-local.

## Learn landing behavior

`/learn` now shows a personalized top action:
- section title: `Your Next Step`
- one strong primary recommendation
- a short explanation
- optional progress bar
- optional contextual badge
- optional secondary suggestions

This does not replace:
- Continue Your Journey
- Daily Learning
- visible main islands

It sits above them as the clearest guided nudge.

## Seasonal and contextual logic

V1 contextual support includes:
- Friday Qur'an encouragement when Qur'an signals already exist
- Ramadan-aware lighter recommendation choice using existing setting state
- dormant-user re-entry suggestion
- momentum badge for in-progress or active guidance

This is intentionally lightweight and does not introduce a calendar engine.

## Qur'an ownership notes

`/quran/*` remains canonical.

If the engine recommends Qur'an learning, it still recommends guided paths that point into canonical Qur'an owners where appropriate. This phase does not create a second Learn-owned Qur'an system.

## Kids safety notes

Kids recommendations are only prioritized when:
- the profile is a child profile
- or kids-safe path visibility already applies

This keeps kids recommendations explainable and avoids surfacing them broadly to adult users without relevant context.

## Reward integration notes

This phase does not add a new reward ledger.

It reuses existing guided-path progression and reward behavior indirectly by prioritizing meaningful next actions. Recommendation display itself does not create new XP or Ocean Drop loops.

## Localization impact

New `learnPersonalization*` keys were added for:
- section title/subtitle
- primary action titles
- action buttons
- secondary suggestion heading
- recommendation reason text
- context badges

Locale files updated:
- all `lib/l10n/app_*.arb`
- generated localization outputs under `lib/l10n/`

Non-English locale entries currently use the repo's existing English-first fallback pattern for the new keys.

## Performance considerations

The personalization layer is local and lightweight:
- recommendations are derived from existing provider state
- no external calls
- no heavy ranking pass
- no frame-by-frame computation
- progress lookup in the localized summary uses the existing guided-path controller state directly instead of extra family-provider churn

## Risks

Known V1 limitations:
- recommendations are only as strong as current local signals
- deeper automatic completion signals are still limited
- seasonal logic is intentionally small
- stories/games intent mapping is still broad because the starter path set is small

## Future extension opportunities

- richer domain-specific starter paths
- stronger inactivity recovery flows
- adaptive sequencing by confidence level
- seasonal path packs
- more granular intent derivation
- family/multi-profile recommendation boundaries
