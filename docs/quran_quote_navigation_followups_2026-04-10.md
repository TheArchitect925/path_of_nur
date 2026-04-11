# Qur'an Quote Navigation Follow-ups

Date: 2026-04-10

Possible next enhancements after disabling autoplay on shared Qur'an quote card taps:

- Audit whether any remaining verse deep links should still intentionally autoplay, and keep those limited to clearly recitation-focused flows only.
- Add a small regression test around shared quote-card navigation so future route helper edits do not silently restore autoplay.
- If product wants quicker listening later, prefer an explicit reader play action after navigation rather than implicit autoplay on informational cards.
