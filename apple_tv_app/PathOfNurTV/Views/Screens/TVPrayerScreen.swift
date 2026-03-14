import SwiftUI

struct TVPrayerScreen: View {
    @ObservedObject var viewModel: TVPrayerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
                TVHeroBanner(
                    title: viewModel.title,
                    subtitle: viewModel.subtitle,
                    eyebrow: viewModel.currentStateLabel,
                    supportingLine: viewModel.nextStateLabel
                )

                TVSectionHeader(
                    title: "Today’s Prayer Timeline",
                    subtitle: "Current and upcoming salah remain visible without dense scrolling."
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: TVTheme.railSpacing) {
                        ForEach(viewModel.prayers) { prayer in
                            TVPrayerTimeCard(prayer: prayer)
                        }
                    }
                    .padding(.vertical, 8)
                }

                TVSectionHeader(
                    title: "Full Day Schedule",
                    subtitle: "A large, room-readable view designed for family display."
                )

                VStack(spacing: 14) {
                    ForEach(viewModel.prayers) { prayer in
                        HStack {
                            Text(prayer.name)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(TVTheme.textPrimary)
                            Spacer()
                            Text(prayer.timeLabel)
                                .font(.system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundStyle(prayer.state == .current ? TVTheme.focus : TVTheme.textPrimary)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(TVTheme.surfaceSoft)
                        )
                    }
                }
            }
            .padding(TVTheme.outerPadding)
        }
        .background(TVBackgroundView())
        .navigationTitle("Prayer")
    }
}
