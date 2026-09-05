#!/usr/bin/env python3
"""Turn raw story readings into the kids stories' narration slots.

Usage:
  python3 tools/import_kids_narration.py --script            print the reading sheets
  python3 tools/import_kids_narration.py <raw_dir>           convert every take found
  python3 tools/import_kids_narration.py --check             validate what is bundled

Every story has one narration slot: a single mp3 named the way the app's
media manifest resolves it (see bedtimeStoryAudioManifestEntryFor in
lib/features/kids/bedtime_stories/data/bedtime_story_media_manifest.dart).
Until a slot is filled the reader falls back to the device voice (K1).

Recording: run --script, and for each story record one take, reading the
sheet top to bottom with a natural pause at every blank line (the pauses
are what the page split follows). Save the take as <slot>.<ext> where
<slot> is the mp3 name without its extension, or as <story id>.<ext>; Voice
Memos m4a, wav, aiff, mp3 and ogg all work.

Import: each take is trimmed of leading and trailing silence, loudness
normalised, and written as a mono 44.1 kHz 96 kbps mp3 into the folder
for its collection:

  prophets      assets/audio/bedtime_stories/prophets/en/path_of_nur/
  other stories assets/audio/kids_stories/en/path_of_nur/

Nothing else has to change: both folders are already declared in
pubspec.yaml and the app checks the asset manifest at runtime.
"""

from __future__ import annotations

import pathlib
import re
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "lib" / "features" / "kids" / "bedtime_stories" / "data"
PROPHETS_DIR = ROOT / "assets/audio/bedtime_stories/prophets/en/path_of_nur"
KIDS_DIR = ROOT / "assets/audio/kids_stories/en/path_of_nur"
LANGUAGE = "en"
VERSION = "v1"
AUDIO_EXTS = {".m4a", ".wav", ".aiff", ".aif", ".mp3", ".ogg", ".flac", ".caf"}


class Story:
    def __init__(self, story_id: str, title: str, prophets: bool, audio_name: str, text: str):
        self.id = story_id
        self.title = title
        self.prophets = prophets
        self.text = text
        # The manifest rule: prophet stories always use the canonical name;
        # the others use their declared file name when they have one.
        base = story_id.replace("story_", "", 1).replace("_v1", "", 1)
        canonical = f"{base}_{LANGUAGE}_{VERSION}.mp3"
        self.slot = canonical if prophets or not audio_name else audio_name

    @property
    def folder(self) -> pathlib.Path:
        return PROPHETS_DIR if self.prophets else KIDS_DIR

    @property
    def target(self) -> pathlib.Path:
        return self.folder / self.slot


def _story_blocks() -> list[tuple[str, str]]:
    """(story id, the Dart that follows it up to the next story) per file,
    so the last story in a file never borrows the next file's fields."""
    blocks: list[tuple[str, str]] = []
    for path in sorted(DATA_DIR.rglob("*.dart")):
        parts = re.split(r"(?m)^\s+id: '(story_[a-z0-9_]+)',\n", path.read_text())
        # parts = [prefix, id1, body1, id2, body2, ...]
        for i in range(1, len(parts), 2):
            blocks.append((parts[i], parts[i + 1]))
    return blocks


def stories() -> list[Story]:
    """Every story the seeds declare, read straight from the Dart."""
    found: list[Story] = []
    for story_id, body in _story_blocks():
        title = _first(r"\btitle: '((?:[^'\\]|\\.)*)'", body) or story_id
        collection = _first(r"collectionType: KidsIslamicStoryCollectionType\.(\w+)", body) or ""
        audio_name = _first(r"audioFileName: '([^']*)'", body) or ""
        text = _first(r"ttsText: '''(.*?)'''", body, re.S)
        if text is None:
            # A picture book reads its spreads; each `lines: [...]` is one page.
            pages = re.findall(r"lines: (?:const )?\[(.*?)\]", body, re.S)
            text = "\n\n".join(
                "\n".join(re.findall(r"'((?:[^'\\]|\\.)*)'", page)) for page in pages
            )
        # The prophet seeds leave collectionType to its default, so the id
        # decides when the block does not say.
        prophets = collection == "prophets" or (
            not collection and story_id.startswith("story_prophet_")
        )
        found.append(Story(story_id, title, prophets, audio_name, text.strip()))
    return found


def _first(pattern: str, text: str, flags: int = 0) -> str | None:
    match = re.search(pattern, text, flags)
    return match.group(1) if match else None


def print_script() -> None:
    for story in stories():
        print("=" * 72)
        print(f"{story.title}")
        print(f"save as: {story.slot.removesuffix('.mp3')}   ({story.id})")
        print("=" * 72)
        print(story.text.replace("\\'", "'"))
        print()


def convert(raw_dir: pathlib.Path) -> int:
    if shutil.which("ffmpeg") is None:
        sys.exit("ffmpeg is required (brew install ffmpeg)")
    by_name = {}
    for story in stories():
        by_name[story.slot.removesuffix(".mp3")] = story
        by_name[story.id] = story
    done = 0
    for take in sorted(raw_dir.iterdir()):
        if take.suffix.lower() not in AUDIO_EXTS:
            continue
        story = by_name.get(take.stem)
        if story is None:
            print(f"skip {take.name}: no story is called {take.stem}")
            continue
        story.folder.mkdir(parents=True, exist_ok=True)
        cmd = [
            "ffmpeg", "-y", "-loglevel", "error", "-i", str(take),
            "-af",
            "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.2,"
            "areverse,silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.3,areverse,"
            "loudnorm=I=-18:TP=-1.5:LRA=9",
            "-ac", "1", "-ar", "44100", "-b:a", "96k", str(story.target),
        ]
        subprocess.run(cmd, check=True)
        seconds = _duration(story.target)
        print(f"{story.target.relative_to(ROOT)}  {seconds:.1f}s")
        done += 1
    return done


def _duration(path: pathlib.Path) -> float:
    if shutil.which("ffprobe") is None:
        return 0.0
    out = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", str(path)],
        capture_output=True, text=True,
    ).stdout.strip()
    return float(out) if out else 0.0


def check() -> int:
    all_stories = stories()
    slots = {story.target for story in all_stories}
    problems = 0
    for story in all_stories:
        state = "recorded" if story.target.exists() else "device voice"
        print(f"{state:13} {story.target.relative_to(ROOT)}")
    for folder in (PROPHETS_DIR, KIDS_DIR):
        if not folder.exists():
            continue
        for file in sorted(folder.iterdir()):
            if file.suffix.lower() == ".mp3" and file not in slots:
                print(f"STRAY         {file.relative_to(ROOT)} matches no story")
                problems += 1
    recorded = sum(1 for story in all_stories if story.target.exists())
    print(f"\n{recorded}/{len(all_stories)} stories narrated")
    return problems


def main(argv: list[str]) -> int:
    if len(argv) != 1:
        print(__doc__)
        return 2
    if argv[0] == "--script":
        print_script()
        return 0
    if argv[0] == "--check":
        return 1 if check() else 0
    raw_dir = pathlib.Path(argv[0])
    if not raw_dir.is_dir():
        sys.exit(f"{raw_dir} is not a folder")
    done = convert(raw_dir)
    print(f"{done} take(s) imported")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
