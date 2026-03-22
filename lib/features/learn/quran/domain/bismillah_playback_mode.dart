enum BismillahPlaybackMode { alwaysPrepend, sourceAware, disabled }

// Temporary playback recovery posture: keep automatic Bismillah pre-roll
// disabled until the dedicated Bismillah playback design is revisited in a
// focused follow-up pass.
const bool alwaysPrependBismillahAtSurahStart = false;

// Backward-compatible alias for older call sites while the repo migrates to
// the more explicit product-setting name above.
const bool alwaysPrependBismillah = alwaysPrependBismillahAtSurahStart;

const BismillahPlaybackMode defaultBismillahPlaybackMode =
    alwaysPrependBismillahAtSurahStart
    ? BismillahPlaybackMode.alwaysPrepend
    : BismillahPlaybackMode.disabled;
