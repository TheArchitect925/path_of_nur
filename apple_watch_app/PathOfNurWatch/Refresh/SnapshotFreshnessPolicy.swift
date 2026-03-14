import Foundation

struct SnapshotFreshnessPolicy {
    func evaluate(
        now: Date,
        snapshot: WatchDaySnapshot?,
        lastRefreshAt: Date?,
        lastSuccessfulSyncAt: Date?,
        hasPendingActions: Bool
    ) -> SnapshotFreshnessState {
        guard let snapshot else {
            return SnapshotFreshnessState(
                snapshotDate: nil,
                lastRefreshAt: lastRefreshAt,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                freshnessStatus: .expired,
                reason: "Missing snapshot"
            )
        }

        let calendar = Calendar.current
        if !calendar.isDate(snapshot.date, inSameDayAs: now) {
            return SnapshotFreshnessState(
                snapshotDate: snapshot.date,
                lastRefreshAt: lastRefreshAt,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                freshnessStatus: .expired,
                reason: "Snapshot belongs to a different day"
            )
        }

        let age = now.timeIntervalSince(lastRefreshAt ?? snapshot.lastSyncAt ?? snapshot.date)
        if hasPendingActions {
            return SnapshotFreshnessState(
                snapshotDate: snapshot.date,
                lastRefreshAt: lastRefreshAt,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                freshnessStatus: age > 60 * 60 ? .stale : .aging,
                reason: "Pending local actions"
            )
        }
        if age <= 15 * 60 {
            return SnapshotFreshnessState(snapshotDate: snapshot.date, lastRefreshAt: lastRefreshAt, lastSuccessfulSyncAt: lastSuccessfulSyncAt, freshnessStatus: .fresh, reason: "Recent refresh")
        }
        if age <= 60 * 60 {
            return SnapshotFreshnessState(snapshotDate: snapshot.date, lastRefreshAt: lastRefreshAt, lastSuccessfulSyncAt: lastSuccessfulSyncAt, freshnessStatus: .aging, reason: "Refresh advisable soon")
        }
        return SnapshotFreshnessState(snapshotDate: snapshot.date, lastRefreshAt: lastRefreshAt, lastSuccessfulSyncAt: lastSuccessfulSyncAt, freshnessStatus: .stale, reason: "Snapshot is aging")
    }
}

