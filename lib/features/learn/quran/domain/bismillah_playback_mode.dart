enum BismillahPlaybackMode { alwaysPrepend, sourceAware, disabled }

// Product setting: Qur'an playback should prepend the canonical Bismillah
// before entering the requested recitation target unless a caller explicitly
// opts into another policy mode.
const bool alwaysPrependBismillahAtSurahStart = true;

// Backward-compatible alias for older call sites while the repo migrates to
// the more explicit product-setting name above.
const bool alwaysPrependBismillah = alwaysPrependBismillahAtSurahStart;

const BismillahPlaybackMode defaultBismillahPlaybackMode =
    alwaysPrependBismillahAtSurahStart
    ? BismillahPlaybackMode.alwaysPrepend
    : BismillahPlaybackMode.disabled;
