#!/usr/bin/env python3
"""Turn raw letter readings into the Arabic letters' audio slots.

Usage:
  python3 tools/import_kids_letter_audio.py --script      print the reading sheet
  python3 tools/import_kids_letter_audio.py <raw_dir>     convert every take found
  python3 tools/import_kids_letter_audio.py --check       validate what is bundled

Every letter has one audio slot, the mp3 the shared Arabic audio manifest
resolves first (quranTeachingAudioAssetPath in
lib/features/arabic/data/arabic_alphabet_catalog.dart). The kids Letters
door, the review and the Qur'an teacher all play that file; until a slot is
filled they fall back to the device voice reading the letter's name.

Recording: run --script and, for each letter, record one take: say the
letter's name, pause for half a second, then say it with fatha (alif … a,
ba … ba). Save the take as <slot>.<ext> (the mp3 name without its
extension, e.g. jeem.m4a) or as <letter id>.<ext> (jim.m4a); Voice Memos
m4a, wav, aiff, mp3 and ogg all work.

Import: each take is trimmed of leading and trailing silence, loudness
normalised, and written as a mono 44.1 kHz 96 kbps mp3 into
assets/audio/quran_teacher/letters/. The folder is declared in pubspec.yaml
and the app checks the asset manifest at runtime, so nothing else changes.
"""

from __future__ import annotations

import pathlib
import re
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
CATALOG = ROOT / "lib" / "features" / "arabic" / "data" / "arabic_alphabet_catalog.dart"
LETTERS_DIR = ROOT / "assets" / "audio" / "quran_teacher" / "letters"
AUDIO_EXTS = {".m4a", ".wav", ".aiff", ".aif", ".mp3", ".ogg", ".flac", ".caf"}

_FIELD = re.compile(r"^\s*(\w+):\s*'([^']*)'", re.M)


class Letter:
    def __init__(self, fields: dict[str, str]):
        self.id = fields["id"]
        self.glyph = fields["glyph"]
        self.name_ar = fields["nameAr"]
        self.name_en = fields["kidsNameEn"]
        self.sound = fields["soundHint"]
        self.asset = fields["quranTeachingAudioAssetPath"]
        self.target = ROOT / self.asset
        self.slot = self.target.name

    @property
    def order(self) -> int:
        return int(self._order)


def letters() -> list[Letter]:
    text = CATALOG.read_text(encoding="utf-8")
    result: list[Letter] = []
    for block in re.split(r"\n\s*_letter\(\n", text)[1:]:
        fields = dict(_FIELD.findall(block.split("positionalForms:")[0]))
        if "quranTeachingAudioAssetPath" not in fields:
            continue
        letter = Letter(fields)
        order = re.search(r"order:\s*(\d+)", block)
        letter._order = order.group(1) if order else "0"
        result.append(letter)
    result.sort(key=lambda item: item.order)
    if len(result) != 28:
        sys.exit(f"expected 28 letters in the catalog, parsed {len(result)}")
    return result


def script() -> None:
    print("Arabic letters · one take per letter: the name, a short pause, then the")
    print("letter with fatha. Save each take as <slot>.m4a (or <id>.m4a).\n")
    print(f"{'slot':14} {'id':6} {'letter':7} {'name':10} say")
    for letter in letters():
        say = f"{letter.name_ar} … {letter.sound}"
        print(f"{letter.slot:14} {letter.id:6} {letter.glyph:^7} {letter.name_en:10} {say}")
    print("\nNote: ح is haa_soft.mp3 and ه is haa.mp3; ح also accepts haa.mp3 as a fallback.")


def convert(raw_dir: pathlib.Path) -> int:
    if shutil.which("ffmpeg") is None:
        sys.exit("ffmpeg is required (brew install ffmpeg)")
    by_name: dict[str, Letter] = {}
    for letter in letters():
        by_name[letter.slot.removesuffix(".mp3")] = letter
        by_name[letter.id] = letter
    done = 0
    for take in sorted(raw_dir.iterdir()):
        if take.suffix.lower() not in AUDIO_EXTS:
            continue
        letter = by_name.get(take.stem)
        if letter is None:
            print(f"skip {take.name}: no letter is called {take.stem}")
            continue
        letter.target.parent.mkdir(parents=True, exist_ok=True)
        cmd = [
            "ffmpeg", "-y", "-loglevel", "error", "-i", str(take),
            "-af",
            "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.2,"
            "areverse,silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.3,areverse,"
            "loudnorm=I=-18:TP=-1.5:LRA=9",
            "-ac", "1", "-ar", "44100", "-b:a", "96k", str(letter.target),
        ]
        subprocess.run(cmd, check=True)
        print(f"{letter.target.relative_to(ROOT)}  {_duration(letter.target):.1f}s")
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
    all_letters = letters()
    slots = {letter.target for letter in all_letters}
    problems = 0
    for letter in all_letters:
        state = "recorded" if letter.target.exists() else "device voice"
        print(f"{state:13} {letter.target.relative_to(ROOT)}  ({letter.glyph} {letter.name_en})")
    if LETTERS_DIR.exists():
        for file in sorted(LETTERS_DIR.iterdir()):
            if file.suffix.lower() == ".mp3" and file not in slots:
                print(f"STRAY         {file.relative_to(ROOT)} matches no letter")
                problems += 1
    recorded = sum(1 for letter in all_letters if letter.target.exists())
    print(f"\n{recorded}/{len(all_letters)} letters recorded")
    return problems


def main(argv: list[str]) -> int:
    if len(argv) != 2 or argv[1] in {"-h", "--help"}:
        print(__doc__)
        return 2
    if argv[1] == "--script":
        script()
        return 0
    if argv[1] == "--check":
        return 1 if check() else 0
    raw_dir = pathlib.Path(argv[1])
    if not raw_dir.is_dir():
        sys.exit(f"{raw_dir} is not a folder")
    done = convert(raw_dir)
    print(f"\n{done} take(s) imported")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
