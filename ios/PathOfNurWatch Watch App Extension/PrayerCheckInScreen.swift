import SwiftUI

struct PrayerCheckInScreen: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette
  @State private var selectedPrayer: WatchPrayerPayload?
  @State private var showingPostPrayerAdhkar = false

  var body: some View {
    ScrollViewReader { proxy in
      List {
        if let promptState = promptState {
          Section {
            WatchHeroCard(glow: promptState.isComplete) {
              if promptState.isComplete {
                Text(WatchStrings.adhkarCompletedTitle)
                  .font(WatchType.heroTitle)
                  .foregroundStyle(palette.onSurface)
                Text(WatchStrings.adhkarCompletedBody)
                  .font(WatchType.caption)
                  .foregroundStyle(palette.onSurfaceSubtle)
                Button(WatchStrings.done) {
                  model.finishPostPrayerAdhkarPrompt()
                  showingPostPrayerAdhkar = false
                }
                .buttonStyle(.borderedProminent)
                .tint(palette.accent)
              } else if promptState.totalCompletedCount == 0 {
                Text(WatchStrings.postPrayerCompletedTitle)
                  .font(WatchType.heroTitle)
                  .foregroundStyle(palette.onSurface)
                Text(WatchStrings.postPrayerCompletedBody)
                  .font(WatchType.caption)
                  .foregroundStyle(palette.onSurfaceSubtle)
                HStack(spacing: 8) {
                  Button(WatchStrings.postPrayerAdhkar) {
                    if let prayer = model.prayerState.prayers.first(where: { $0.prayerId == promptState.prayerId }) {
                      model.startPostPrayerAdhkar(for: prayer)
                    }
                    showingPostPrayerAdhkar = true
                  }
                  .buttonStyle(.borderedProminent)
                  .tint(palette.accent)
                  Button(WatchStrings.done) {
                    model.skipPostPrayerAdhkar()
                  }
                  .buttonStyle(.bordered)
                }
              } else {
                Text(WatchStrings.adhkarTitle)
                  .font(WatchType.heroTitle)
                  .foregroundStyle(palette.onSurface)
                Text(promptState.prayerName)
                  .font(WatchType.caption)
                  .foregroundStyle(palette.accentSoft)
                HStack(spacing: 8) {
                  Button(WatchStrings.adhkarResume) {
                    showingPostPrayerAdhkar = true
                  }
                  .buttonStyle(.borderedProminent)
                  .tint(palette.accent)
                  Button(WatchStrings.skip) {
                    model.skipPostPrayerAdhkar()
                  }
                  .buttonStyle(.bordered)
                }
              }
            }
            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))
            .listRowBackground(Color.clear)
          }
        }

        ForEach(model.prayerState.prayers) { prayer in
          Button {
            selectedPrayer = prayer
          } label: {
            WatchPrayerRow(
              prayer: prayer,
              isFocused: model.focusedPrayerId == prayer.prayerId
            )
            .padding(.vertical, 2)
            .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
          }
          .buttonStyle(.plain)
          .listRowBackground(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
              .fill(palette.cardFillSoft)
          )
          .id(prayer.prayerId)
        }
      }
      .onChange(of: model.focusedPrayerId) { _, prayerId in
        guard let prayerId else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
          proxy.scrollTo(prayerId, anchor: .center)
        }
      }
      .onAppear {
        if let prayerId = model.focusedPrayerId {
          proxy.scrollTo(prayerId, anchor: .center)
        }
      }
    }
    .sheet(isPresented: $showingPostPrayerAdhkar) {
      PostPrayerAdhkarFlow()
        .environmentObject(model)
        .environment(\.watchPalette, model.palette)
    }
    .confirmationDialog(
      selectedPrayer?.displayName ?? WatchStrings.prayerTitle,
      isPresented: Binding(
        get: { selectedPrayer != nil },
        set: { isPresented in
          if !isPresented {
            selectedPrayer = nil
          }
        }
      )
    ) {
      if let prayer = selectedPrayer {
        Button(WatchStrings.prayed) {
          model.updatePrayer(prayerId: prayer.prayerId, status: .completed, timing: .onTime)
          selectedPrayer = nil
        }
        Button(WatchStrings.prayedLate) {
          model.updatePrayer(prayerId: prayer.prayerId, status: .completed, timing: .late)
          selectedPrayer = nil
        }
        Button(WatchStrings.missed) {
          model.updatePrayer(prayerId: prayer.prayerId, status: .missed, timing: nil)
          selectedPrayer = nil
        }
      }
      Button(WatchStrings.cancel, role: .cancel) {
        selectedPrayer = nil
      }
    }
    .containerBackground(palette.backgroundGradient, for: .tabView)
  }

  private var promptState: WatchPostPrayerAdhkarState? {
    model.postPrayerAdhkarState
  }
}

private struct PostPrayerAdhkarFlow: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ScrollView {
      if let state = model.postPrayerAdhkarState {
        VStack(spacing: 14) {
          Text(WatchStrings.adhkarTitle)
            .font(WatchType.screenTitle)
            .foregroundStyle(palette.accent)

          if state.isComplete {
            WatchHeroCard(glow: true) {
              Text(WatchStrings.adhkarCompletedTitle)
                .font(WatchType.heroTitle)
                .foregroundStyle(palette.onSurface)
              Text(WatchStrings.adhkarCompletedBody)
                .font(WatchType.caption)
                .foregroundStyle(palette.onSurfaceSubtle)
              Button(WatchStrings.done) {
                model.finishPostPrayerAdhkarPrompt()
                dismiss()
              }
              .buttonStyle(.borderedProminent)
              .tint(palette.accent)
            }
          } else if let step = state.currentStep {
            WatchHeroCard {
              Text(state.prayerName)
                .font(WatchType.captionEmphasis)
                .foregroundStyle(palette.accentSoft)
              Text(step.kind.title)
                .font(.system(size: 20, weight: .semibold, design: .serif))
                .foregroundStyle(palette.onSurface)
              Text("\(WatchStrings.adhkarStepLabel) \(state.currentStepIndex + 1)/\(state.steps.count)")
                .font(WatchType.caption)
                .foregroundStyle(palette.onSurfaceSubtle)

              Button(action: model.advancePostPrayerAdhkar) {
                VStack(spacing: 8) {
                  WatchMiniProgressRing(
                    progress: Double(min(step.count, step.kind.targetCount)) / Double(step.kind.targetCount),
                    lineWidth: 12,
                    label: "\(min(step.count, step.kind.targetCount))"
                  )
                  .frame(width: 110, height: 110)

                  Text("\(min(step.count, step.kind.targetCount)) / \(step.kind.targetCount)")
                    .font(WatchType.label)
                    .foregroundStyle(palette.accentSoft)
                  Text(WatchStrings.adhkarTap)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(palette.onSurface)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(
                  RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(palette.accent.opacity(0.14))
                )
                .overlay(
                  RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(palette.accent.opacity(0.4), lineWidth: 1)
                )
                .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
              }
              .buttonStyle(.plain)
            }

            HStack(spacing: 8) {
              Button(WatchStrings.skip) {
                model.skipPostPrayerAdhkar()
                dismiss()
              }
              .buttonStyle(.bordered)
              .frame(maxWidth: .infinity, minHeight: 44)

              Button(WatchStrings.done) {
                dismiss()
              }
              .buttonStyle(.bordered)
              .frame(maxWidth: .infinity, minHeight: 44)
            }
          }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
      }
    }
    .containerBackground(palette.backgroundGradient, for: .navigation)
  }
}
