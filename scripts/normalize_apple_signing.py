#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
APP_CONFIG = ROOT / "ios/Flutter/AppConfig.xcconfig"
PBXPROJ = ROOT / "ios/Runner.xcodeproj/project.pbxproj"

TARGET_IDS = (
    "2BE8967712367400A95BCF94",  # PathOfNurTV
    "44EBC13A7C2EFBFEF83C8372",  # PrayerLiveActivityExtension
    "97C146ED1CF9000F007C117D",  # Runner
    "AC03585982794548765852A0",  # PathOfNurWatch Watch App
    "E2EF5A4C5B12A16E1EFA555F",  # PathOfNurWatch Watch App Extension
)


def read_team_id() -> str:
    for line in APP_CONFIG.read_text().splitlines():
        if line.startswith("APPLE_DEVELOPMENT_TEAM = "):
            value = line.split("=", 1)[1].strip()
            if value:
                return value
    raise SystemExit(f"Missing APPLE_DEVELOPMENT_TEAM in {APP_CONFIG}")


def normalize_development_team(text: str) -> str:
    return re.sub(
        r'DEVELOPMENT_TEAM = [^;]+;',
        f'DEVELOPMENT_TEAM = {read_team_id()};',
        text,
    )


def normalize_project_team_setting(text: str, team_id: str) -> str:
    return re.sub(
        r'APPLE_DEVELOPMENT_TEAM = [^;]+;',
        f'APPLE_DEVELOPMENT_TEAM = {team_id};',
        text,
    )


def upsert_target_attribute_block(text: str, target_id: str, team_id: str) -> str:
    pattern = re.compile(rf'(\t\t\t\t{re.escape(target_id)} = \{{\n)(.*?)(\t\t\t\t\}};)', re.S)
    match = pattern.search(text)
    if not match:
        raise SystemExit(f"TargetAttributes entry not found for {target_id}")

    body = match.group(2)
    lines = [line for line in body.splitlines() if line.strip()]
    filtered: list[str] = []
    saw_created = False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("DevelopmentTeam =") or stripped.startswith("ProvisioningStyle ="):
            continue
        filtered.append(line)
        if stripped.startswith("CreatedOnToolsVersion ="):
            filtered.append(f"\t\t\t\t\tDevelopmentTeam = {team_id};")
            filtered.append("\t\t\t\t\tProvisioningStyle = Automatic;")
            saw_created = True
    if not saw_created:
        filtered.append(f"\t\t\t\t\tDevelopmentTeam = {team_id};")
        filtered.append("\t\t\t\t\tProvisioningStyle = Automatic;")

    replacement = match.group(1) + "\n".join(filtered) + ("\n" if filtered else "") + match.group(3)
    return text[: match.start()] + replacement + text[match.end() :]


def main() -> None:
    team_id = read_team_id()
    text = PBXPROJ.read_text()
    text = normalize_project_team_setting(text, team_id)
    text = normalize_development_team(text)
    for target_id in TARGET_IDS:
        text = upsert_target_attribute_block(text, target_id, team_id)
    PBXPROJ.write_text(text)
    print(f"Normalized Apple signing metadata to team {team_id}")


if __name__ == "__main__":
    main()
