import 'package:flutter/material.dart';

import '../../shared/theme/islamic_icons.dart';

/// The app's icon vocabulary: one glyph per concept.
///
/// Header redesign, decision B1 (2026-09-04). Every recurring concept the
/// product names — a section, a tool, a state — resolves to exactly one glyph
/// here, so a hub row, the landing it opens and the registry that describes it
/// can never disagree about what "hadith" or "fasting" looks like.
///
/// Rules the icon policy test enforces:
///
/// * Material glyphs come from the **rounded** family. The only place a
///   non-rounded Material icon may be named is this file, and only for the
///   handful of state glyphs (unpinned, AR off, study off) whose hollow form
///   has no rounded twin.
/// * Islamic concepts use the bundled [IslamicIcons] font, never a Material
///   stand-in — a compass rose is not a qibla, a burger is not a fast.
/// * The wrong-world glyphs the audit found (yoga pose, robot, dice, DNA,
///   gamepad, burger) are banned outright.
///
/// Generic UI glyphs — chevrons, close, play, check — stay as direct
/// `Icons.*_rounded` references; the vocabulary is for concepts.
abstract final class AppIcons {
  // ── Worship ────────────────────────────────────────────────────────────
  static const IconData salah = IslamicIcons.prayer;
  static const IconData guidedPrayer = IslamicIcons.prayingPerson;
  static const IconData khushu = IslamicIcons.prayingPerson;
  static const IconData dhikr = IslamicIcons.tasbih;
  static const IconData fasting = IslamicIcons.lantern;
  static const IconData ramadan = Icons.nightlight_round_rounded;
  static const IconData dua = Icons.volunteer_activism_rounded;
  static const IconData qibla = IslamicIcons.qibla;
  static const IconData kaaba = IslamicIcons.kaaba;
  static const IconData mosque = IslamicIcons.locationMosque;
  static const IconData wudu = IslamicIcons.wudhu;
  static const IconData namesOfAllah = IslamicIcons.allahText;

  // ── Qur'an ─────────────────────────────────────────────────────────────
  static const IconData quran = IslamicIcons.quran;
  static const IconData surahs = Icons.format_list_numbered_rounded;
  static const IconData readingPlan = Icons.flag_rounded;
  static const IconData bookmark = Icons.bookmark_rounded;
  static const IconData bookmarkOff = Icons.bookmark_border_rounded;
  static const IconData memorize = Icons.repeat_rounded;
  static const IconData listen = Icons.headphones_rounded;
  static const IconData arabic = Icons.translate_rounded;
  static const IconData wordDeck = Icons.style_rounded;
  static const IconData summary = Icons.summarize_rounded;
  static const IconData topics = Icons.account_tree_rounded;
  static const IconData insights = Icons.auto_awesome_rounded;
  static const IconData universe = Icons.hub_rounded;

  // ── Learn ──────────────────────────────────────────────────────────────
  static const IconData learn = Icons.school_rounded;
  static const IconData lesson = Icons.menu_book_rounded;
  static const IconData glossary = Icons.menu_book_rounded;
  static const IconData path = Icons.route_rounded;
  static const IconData journeys = Icons.hub_rounded;
  static const IconData hadith = Icons.format_quote_rounded;
  static const IconData prophets = Icons.auto_stories_rounded;
  static const IconData stories = Icons.auto_stories_rounded;
  static const IconData seerah = Icons.route_rounded;
  static const IconData history = Icons.history_edu_rounded;
  static const IconData world = Icons.public_rounded;
  static const IconData science = Icons.science_rounded;
  static const IconData lessons = Icons.lightbulb_rounded;
  static const IconData character = Icons.favorite_border_rounded;
  static const IconData reflection = Icons.eco_rounded;
  static const IconData practice = Icons.repeat_rounded;
  static const IconData quiz = Icons.quiz_rounded;
  static const IconData games = Icons.extension_rounded;
  static const IconData crossword = Icons.grid_on_rounded;
  static const IconData wordSearch = Icons.grid_3x3_rounded;
  static const IconData matching = Icons.view_week_rounded;
  static const IconData notes = Icons.sticky_note_2_rounded;
  static const IconData journal = Icons.edit_note_rounded;
  static const IconData babyNames = Icons.child_care_rounded;
  static const IconData random = Icons.shuffle_rounded;
  static const IconData faq = Icons.help_outline_rounded;
  static const IconData help = Icons.help_outline_rounded;
  static const IconData explore = Icons.travel_explore_rounded;
  static const IconData browseAll = Icons.grid_view_rounded;
  static const IconData search = Icons.search_rounded;

  // ── Kids ───────────────────────────────────────────────────────────────
  static const IconData kids = Icons.child_care_rounded;
  static const IconData fun = Icons.celebration_rounded;
  static const IconData letters = Icons.text_fields_rounded;
  static const IconData bedtime = Icons.bedtime_rounded;
  static const IconData bedtimeStories = Icons.nightlight_round_rounded;
  static const IconData family = Icons.family_restroom_rounded;

  // ── Growth ─────────────────────────────────────────────────────────────
  static const IconData growth = Icons.auto_graph_rounded;
  static const IconData spiritualGrowth = Icons.eco_rounded;
  static const IconData today = Icons.today_rounded;
  static const IconData habits = Icons.checklist_rtl_rounded;
  static const IconData statistics = Icons.query_stats_rounded;
  static const IconData garden = Icons.local_florist_rounded;
  static const IconData drops = Icons.water_drop_rounded;
  static const IconData wallpapers = Icons.wallpaper_rounded;
  static const IconData badges = Icons.stars_rounded;
  static const IconData rewards = Icons.emoji_events_rounded;
  static const IconData challenge = Icons.flag_circle_rounded;
  static const IconData daily = Icons.wb_sunny_rounded;
  static const IconData sky = Icons.wb_twilight_rounded;
  static const IconData calendar = Icons.calendar_month_rounded;
  static const IconData growthPaths = Icons.alt_route_rounded;
  static const IconData goal = Icons.flag_rounded;

  // ── Community ──────────────────────────────────────────────────────────
  static const IconData community = Icons.groups_rounded;
  static const IconData masjidBuddy = IslamicIcons.community;
  static const IconData events = Icons.event_rounded;
  static const IconData moderation = Icons.admin_panel_settings_rounded;

  // ── App ────────────────────────────────────────────────────────────────
  static const IconData assistant = Icons.question_answer_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData accounts = Icons.manage_accounts_rounded;
  static const IconData appearance = Icons.palette_rounded;
  static const IconData notifications = Icons.notifications_active_rounded;
  static const IconData widgetsWatch = Icons.watch_rounded;
  static const IconData language = Icons.language_rounded;
  static const IconData privacy = Icons.shield_rounded;
  static const IconData sync = Icons.sync_rounded;
  static const IconData adhan = Icons.volume_up_rounded;
  static const IconData about = Icons.info_outline_rounded;
  static const IconData legal = Icons.gavel_rounded;
  static const IconData dashboard = Icons.dashboard_customize_rounded;
  static const IconData profiles = Icons.people_alt_rounded;
  static const IconData profileBadge = Icons.badge_rounded;
  static const IconData devices = Icons.devices_rounded;
  static const IconData sharedDeviceSafety = Icons.shield_moon_rounded;
  static const IconData backup = Icons.backup_rounded;
  static const IconData download = Icons.cloud_download_rounded;
  static const IconData compare = Icons.compare_arrows_rounded;
  static const IconData export = Icons.ios_share_rounded;
  static const IconData import = Icons.restore_page_rounded;
  static const IconData location = Icons.place_rounded;
  static const IconData occasions = Icons.auto_awesome_rounded;
  static const IconData care = Icons.favorite_border_rounded;
  static const IconData whatsNew = Icons.new_releases_rounded;
  static const IconData comingSoon = Icons.upcoming_rounded;
  static const IconData support = Icons.support_agent_rounded;
  static const IconData licenses = Icons.workspace_premium_rounded;
  static const IconData schedule = Icons.schedule_rounded;
  static const IconData recent = Icons.history_rounded;
  static const IconData adjust = Icons.tune_rounded;

  // ── Actions that head a row ───────────────────────────────────────────
  static const IconData add = Icons.add_rounded;

  // ── States ─────────────────────────────────────────────────────────────
  static const IconData notFound = Icons.error_outline_rounded;
  static const IconData locked = Icons.lock_outline_rounded;
  static const IconData dot = Icons.circle_rounded;
  static const IconData dotHollow = Icons.radio_button_unchecked_rounded;
  static const IconData pin = Icons.push_pin_rounded;

  // Hollow state forms with no rounded twin in the Material catalogue. These
  // are the only non-rounded Material glyphs the policy allows, and only here.
  static const IconData pinOff = Icons.push_pin_outlined;
  static const IconData arOff = Icons.view_in_ar_outlined;
  static const IconData studyOff = Icons.school_outlined;
}
