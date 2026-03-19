import SwiftUI

struct ProgressWatchScreen: View {
  @EnvironmentObject private var model: WatchAppModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text(WatchStrings.progressTitle)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
          Spacer()
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
                  .font(.caption2)
                  .foregroundStyle(WatchTheme.secondaryText)
                Text("\(WatchStrings.growthPrefix): \(progress.growthStageKey.capitalized)")
                  .font(.caption2)
                  .foregroundStyle(WatchTheme.accentSoft)
                Text("\(WatchStrings.level) \(progress.currentLevel)")
                  .font(.headline.weight(.semibold))
                  .foregroundStyle(.white)
              }
            }
            if let dashboard = model.dashboardState, dashboard.isStale {
              Text(WatchStrings.freshnessNeedsSync)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(WatchTheme.warning)
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
              .font(.headline)
              .foregroundStyle(.white)
            Text(WatchStrings.noSnapshotBody)
              .font(.caption2)
              .foregroundStyle(WatchTheme.secondaryText)
          }
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
    }
    .containerBackground(WatchTheme.backgroundGradient, for: .navigation)
  }
}
