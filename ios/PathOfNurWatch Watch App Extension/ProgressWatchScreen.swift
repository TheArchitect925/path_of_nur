import SwiftUI

struct ProgressWatchScreen: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        WatchScreenHeader(WatchStrings.progressTitle) {
          WatchSyncStatusBadge(state: model.syncBadgeState)
        }
        if let progress = model.progressState {
          WatchHeroCard {
            HStack(spacing: 12) {
              WatchMiniProgressRing(
                progress: progress.totalPrayerCount == 0
                    ? 0
                    : Double(progress.completedPrayerCount) / Double(progress.totalPrayerCount),
                label: "\(progress.completedPrayerCount)/\(progress.totalPrayerCount)"
              )
              VStack(alignment: .leading, spacing: 4) {
                Text(WatchStrings.progress)
                  .font(WatchType.caption)
                  .foregroundStyle(palette.onSurfaceSubtle)
                Text("\(WatchStrings.growthPrefix): \(progress.growthStageKey.capitalized)")
                  .font(WatchType.caption)
                  .foregroundStyle(palette.accentSoft)
                Text("\(WatchStrings.level) \(progress.currentLevel)")
                  .font(.system(size: 16, weight: .semibold, design: .serif))
                  .foregroundStyle(palette.onSurface)
              }
            }
            if let dashboard = model.dashboardState, dashboard.isStale {
              Text(WatchStrings.freshnessNeedsSync)
                .font(WatchType.captionEmphasis)
                .foregroundStyle(palette.warning)
                .padding(.top, 4)
            }
          }

          HStack(spacing: 8) {
            WatchStatChip(title: WatchStrings.streak, value: "\(progress.streakDays)")
            WatchStatChip(title: WatchStrings.xp, value: "\(progress.xpToday)")
          }
          HStack(spacing: 8) {
            WatchStatChip(title: WatchStrings.drops, value: "\(progress.oceanDropsToday)")
            WatchStatChip(title: WatchStrings.prayerSummary, value: "\(progress.completedPrayerCount)/\(progress.totalPrayerCount)")
          }
        } else {
          WatchHeroCard {
            Text(WatchStrings.noSnapshotTitle)
              .font(WatchType.heroTitle)
              .foregroundStyle(palette.onSurface)
            Text(WatchStrings.noSnapshotBody)
              .font(WatchType.caption)
              .foregroundStyle(palette.onSurfaceSubtle)
          }
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
    }
    .containerBackground(palette.backgroundGradient, for: .tabView)
  }
}
