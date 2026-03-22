# Bedtime Family Mode Backlog

## Safe Enhancements

- Add widget tests for family mode creation, switch, archive, and empty-state rendering.
- Add a child-specific bedtime activity log so recent activity uses canonical event records instead of inferred timestamps.
- Add a gentle "move shared bedtime progress to a child profile" migration helper when a household creates its first child after using the legacy single-learner flow.
- Add learner-scoped bedtime queue/session resume widgets so the family mode page can show "continue this story" per child without opening the dashboard first.
- Add settings or family-area entry points to the bedtime family mode and parent dashboard for broader discoverability.
- Add optional bedtime-preference fields per learner, such as preferred story length, preferred narrator language, and favorite prophets.
- Add archive/unarchive coverage to the broader shared family management surface if the product wants archiving to exist outside bedtime stories too.
- Add a family-overview summary card only after child-specific bedtime logs are stable; keep the primary dashboard child-specific.

## Longer-Term Options

- Migrate bedtime learner identity from the current fallback learner to a first-class child profile creation assistant when the product is ready to require profiles for kids learning.
- Introduce learner-scoped reward mirroring into the broader Journey XP/Drops ledger only if the app gains a canonical child-profile-aware global reward architecture.
- Add multi-language learner preferences so bedtime media, transcript defaults, and quizzes can pivot cleanly between English, Urdu, and Arabic by child profile.
