import SwiftUI

struct WatchHomeView: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 12) {
        WatchScreenHeader(WatchStrings.homeTitle) {
          WatchSyncStatusBadge(state: model.syncBadgeState)
        }
        if let dashboard = model.dashboardState {
          WatchHeroCard(glow: dashboard.allPrayersComplete) {
            Text(dashboard.allPrayersComplete ? WatchStrings.allPrayersComplete : WatchStrings.nextPrayerTitle)
              .font(WatchType.captionEmphasis)
              .foregroundStyle(palette.onSurfaceSubtle)
            Text(dashboard.nextPrayerName)
              .font(WatchType.heroTitle)
              .foregroundStyle(palette.onSurface)
            if let nextPrayerTime = dashboard.nextPrayerTime, !dashboard.allPrayersComplete {
              VStack(alignment: .leading, spacing: 2) {
                Text(nextPrayerTime, style: .time)
                  .font(WatchType.value)
                  .foregroundStyle(palette.accent)
                Text(freshnessLabel(for: dashboard))
                  .font(WatchType.caption)
                  .foregroundStyle(dashboard.isStale ? palette.warning : palette.onSurfaceMuted)
              }
            }
            HStack(spacing: 12) {
              WatchMiniProgressRing(
                progress: dashboard.progressValue,
                label: "\(dashboard.completedPrayerCount)/\(dashboard.totalPrayerCount)"
              )
              VStack(alignment: .leading, spacing: 6) {
                Text(WatchStrings.prayerSummary)
                  .font(WatchType.caption)
                  .foregroundStyle(palette.onSurfaceSubtle)
                Text("\(dashboard.completedPrayerCount)/\(dashboard.totalPrayerCount)")
                  .font(WatchType.value)
                  .foregroundStyle(palette.onSurface)
                Text("\(WatchStrings.streak): \(dashboard.streakDays)")
                  .font(WatchType.caption)
                  .foregroundStyle(palette.accentSoft)
              }
            }
          }

          HStack(spacing: 8) {
            WatchQuickActionButton(
              title: WatchStrings.prayerTitle,
              systemImage: "checkmark.circle"
            ) {
              model.selectedTab = .prayer
            }
            WatchQuickActionButton(
              title: WatchStrings.dhikrTitle,
              systemImage: "hand.tap"
            ) {
              model.selectedTab = .dhikr
            }
            WatchQuickActionButton(
              title: WatchStrings.progressTitle,
              systemImage: "sparkles"
            ) {
              model.selectedTab = .progress
            }
          }
          HStack(spacing: 8) {
            WatchQuickActionButton(
              title: WatchStrings.qiblaTitle,
              systemImage: "location.north.circle"
            ) {
              model.presentedAuxScreen = .qibla
            }
            WatchQuickActionButton(
              title: WatchStrings.namesShortTitle,
              systemImage: "book.closed"
            ) {
              model.presentedAuxScreen = .names
            }
            WatchQuickActionButton(
              title: WatchStrings.quranShortTitle,
              systemImage: "waveform"
            ) {
              model.presentedAuxScreen = .quranRemote
            }
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

  private func freshnessLabel(for dashboard: WatchDashboardState) -> String {
    guard let lastSyncAt = dashboard.lastSyncAt else {
      return WatchStrings.freshnessNeedsSync
    }
    if dashboard.isStale {
      return WatchStrings.freshnessNeedsSync
    }
    if Date().timeIntervalSince(lastSyncAt) < 60 {
      return "\(WatchStrings.freshnessUpdated) \(WatchStrings.freshnessJustNow)"
    }
    return "\(WatchStrings.freshnessUpdated) \(lastSyncAt.formatted(.relative(presentation: .named)))"
  }
}

#Preview {
  WatchHomeView()
    .environmentObject(WatchAppModel())
}
