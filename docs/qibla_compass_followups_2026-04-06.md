# Qibla Compass Follow-ups

Date: 2026-04-06
Feature: Qibla compass behavior and layout rework

## Enhancement Options

1. Add a small haptic pulse when the user first enters the aligned range, gated behind reduced-motion and platform support.
2. Promote the compass colors into a tiny shared worship compass palette helper if another compass-like surface is added later.
3. Add a manual location picker entrypoint so the Qibla finder can still work when device location is unavailable but a city is known.
4. If device testing shows the heading stream is still noisy on specific phones, replace the simple wrap-aware lerp with a tiny ring buffer average on the shortest-angle delta.
5. Add a lightweight widget test around the math helper to lock in normalization, shortest-angle, and Qibla-bearing behavior.
