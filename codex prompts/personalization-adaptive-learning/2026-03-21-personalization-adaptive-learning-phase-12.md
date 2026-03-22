# Phase 12 Prompt Archive

Date: 2026-03-21
Feature: Personalization + Adaptive Learning

Goal:
- Build an offline-first personalization and adaptive learning system that adjusts difficulty, content selection, daily challenge composition, and learning focus areas across the Knowledge Games Engine.

Implemented direction:
- shared local `UserLearningProfile`
- deterministic adaptive scoring from existing game progress
- personalized daily target difficulty by game type
- category-aware daily selection bias
- Daily Knowledge Challenge Hub transparency surface

Constraints preserved:
- offline-first only
- no backend dependency
- reused existing rewards, progression, daily routing, and persistence
- no rebuild of existing game logic
