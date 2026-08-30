import SwiftUI

struct DhikrWatchScreen: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette
  @State private var showEndConfirmation = false
  @State private var showAutoSessionControls = false

  private let autoTargets = [33, 34, 99]

  var body: some View {
    ScrollView {
      VStack(spacing: 14) {
        WatchScreenHeader(WatchStrings.dhikrTitle)

        modeSelector

        if model.dhikrMode == .auto {
          autoDhikrContent
        } else {
          manualDhikrContent
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
    }
    .containerBackground(palette.backgroundGradient, for: .tabView)
    .onAppear {
      syncAutoSessionControlVisibility()
    }
    .onChange(of: model.autoDhikrState.phase) { _, _ in
      syncAutoSessionControlVisibility()
    }
    .alert(WatchStrings.autoDhikrEndConfirmTitle, isPresented: $showEndConfirmation) {
      Button(WatchStrings.cancel, role: .cancel) {}
      Button(WatchStrings.autoDhikrEnd, role: .destructive) {
        model.endAutoDhikr()
      }
    } message: {
      Text(WatchStrings.autoDhikrEndConfirmBody)
    }
    .alert(WatchStrings.dhikrAntiRushTitle, isPresented: Binding(
      get: { model.showDhikrAntiRushReminder },
      set: { value in
        if !value {
          model.dismissDhikrAntiRushReminder()
        }
      }
    )) {
      Button(WatchStrings.dhikrAntiRushAcknowledge) {
        model.dismissDhikrAntiRushReminder()
      }
    } message: {
      Text(WatchStrings.dhikrAntiRushBody)
    }
  }

  private var modeSelector: some View {
    HStack(spacing: 8) {
      modeButton(.manual, title: WatchStrings.dhikrModeManual)
      modeButton(.auto, title: WatchStrings.dhikrModeAuto)
    }
  }

  private var manualDhikrContent: some View {
    VStack(spacing: 14) {
      WatchHeroCard(glow: model.dhikrState.isComplete) {
        Text(model.dhikrState.phrase)
          .font(.system(size: 14, weight: .semibold, design: .serif))
          .foregroundStyle(palette.onSurfaceSubtle)
        Button(action: model.incrementDhikr) {
          VStack(spacing: 8) {
            WatchMiniProgressRing(
              progress: model.dhikrState.progressValue,
              lineWidth: 12,
              label: "\(min(model.dhikrState.count, model.dhikrState.target))"
            )
            .frame(width: 100, height: 100)
            Text("\(min(model.dhikrState.count, model.dhikrState.target)) / \(model.dhikrState.target)")
              .font(WatchType.label)
              .foregroundStyle(palette.accentSoft)
            Text(WatchStrings.tapToCount)
              .font(.system(size: 15, weight: .semibold))
              .foregroundStyle(palette.onSurface)
          }
          .frame(maxWidth: .infinity, minHeight: 136)
          .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
              .fill(palette.accent.opacity(0.14))
          )
          .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
              .strokeBorder(palette.accent.opacity(0.4), lineWidth: 1)
          )
          .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
      }

      Picker(WatchStrings.choosePreset, selection: Binding(
        get: { model.dhikrState.preset },
        set: { model.selectDhikrPreset($0) }
      )) {
        ForEach(WatchDhikrPreset.allCases) { preset in
          Text(preset.title).tag(preset)
        }
      }

      HStack(spacing: 8) {
        Button(WatchStrings.finishSession, action: model.finishDhikrSession)
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)
        Button(WatchStrings.resetSession, action: model.resetDhikr)
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)
      }
    }
  }

  private var autoDhikrContent: some View {
    VStack(spacing: 12) {
      WatchHeroCard(glow: model.autoDhikrState.isCompleted) {
        Text(WatchStrings.autoDhikrTitle)
          .font(WatchType.captionEmphasis)
          .foregroundStyle(palette.onSurfaceSubtle)

        Text(model.autoDhikrState.phrase.title)
          .font(.system(size: 16, weight: .semibold, design: .serif))
          .foregroundStyle(palette.onSurface)

        WatchMiniProgressRing(
          progress: model.autoDhikrState.progressValue,
          lineWidth: 12,
          label: "\(min(model.autoDhikrState.count, model.autoDhikrState.target))"
        )
        .frame(width: 96, height: 96)

        Text("\(min(model.autoDhikrState.count, model.autoDhikrState.target)) / \(model.autoDhikrState.target)")
          .font(WatchType.label)
          .foregroundStyle(palette.accentSoft)

        Text(autoStatusTitle)
          .font(WatchType.captionEmphasis)
          .foregroundStyle(model.autoDhikrState.isCompleted ? palette.success : palette.accent)

        Text("\(WatchStrings.autoDhikrPace): \(model.autoDhikrState.intervalDisplay)")
          .font(WatchType.caption)
          .foregroundStyle(palette.onSurfaceSubtle)

        if model.autoDhikrState.isRunning && !showAutoSessionControls {
          Text(WatchStrings.autoDhikrMinimalHint)
            .font(WatchType.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(palette.onSurfaceMuted)
        } else if !model.autoDhikrState.isActive && !model.autoDhikrState.isCompleted {
          Text(WatchStrings.autoDhikrKeepFocus)
            .font(WatchType.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(palette.onSurfaceMuted)
        }
      }
      .onTapGesture {
        guard model.autoDhikrState.isRunning else { return }
        showAutoSessionControls.toggle()
      }

      if model.autoDhikrState.isCompleted {
        completionCard
      } else if model.autoDhikrState.isActive {
        activeSessionControls
      } else {
        Picker(WatchStrings.autoDhikrTitle, selection: Binding(
          get: { model.autoDhikrState.phrase },
          set: { model.selectAutoDhikrPhrase($0) }
        )) {
          ForEach(WatchAutoDhikrPhrase.allCases) { phrase in
            Text(phrase.title).tag(phrase)
          }
        }
        .disabled(model.autoDhikrState.isActive)

        Picker(WatchStrings.autoDhikrTarget, selection: Binding(
          get: { model.autoDhikrState.target },
          set: { model.selectAutoDhikrTarget($0) }
        )) {
          ForEach(autoTargets, id: \.self) { target in
            Text("\(target)").tag(target)
          }
        }
        .disabled(model.autoDhikrState.isActive)

        paceControls
        sessionControls
      }
    }
  }

  private var paceControls: some View {
    VStack(spacing: 8) {
      Text("\(WatchStrings.autoDhikrPace): \(model.autoDhikrState.intervalDisplay)")
        .font(WatchType.label)
        .foregroundStyle(palette.onSurfaceSubtle)

      HStack(spacing: 8) {
        Button(WatchStrings.autoDhikrFaster, action: model.fasterAutoDhikr)
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)
          .disabled(model.autoDhikrState.intervalSeconds <= WatchAutoDhikrPreferences.minimumInterval)

        Button(WatchStrings.autoDhikrSlower, action: model.slowerAutoDhikr)
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)
          .disabled(model.autoDhikrState.intervalSeconds >= WatchAutoDhikrPreferences.maximumInterval)
      }
    }
  }

  private var sessionControls: some View {
    VStack(spacing: 8) {
      Button(WatchStrings.autoDhikrBegin, action: model.beginAutoDhikr)
        .buttonStyle(.borderedProminent)
        .tint(palette.accent)
        .frame(maxWidth: .infinity, minHeight: 48)
    }
  }

  private var activeSessionControls: some View {
    VStack(spacing: 8) {
      Button(model.autoDhikrState.isRunning ? WatchStrings.autoDhikrPause : WatchStrings.autoDhikrResume) {
        if model.autoDhikrState.isRunning {
          model.pauseAutoDhikr()
        } else {
          model.resumeAutoDhikr()
        }
      }
      .buttonStyle(.borderedProminent)
      .tint(model.autoDhikrState.isPaused ? palette.success : palette.accent)
      .frame(maxWidth: .infinity, minHeight: 50)

      if showAutoSessionControls || model.autoDhikrState.isPaused {
        paceControls
        HStack(spacing: 8) {
          Button(WatchStrings.autoDhikrHideControls) {
            showAutoSessionControls = false
          }
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)

          Button(WatchStrings.autoDhikrEnd) {
            showEndConfirmation = true
          }
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)
        }
      } else {
        HStack(spacing: 8) {
          Button(WatchStrings.autoDhikrShowControls) {
            showAutoSessionControls = true
          }
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)

          Button(WatchStrings.autoDhikrEnd) {
            showEndConfirmation = true
          }
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, minHeight: 44)
        }
      }
    }
  }

  private var completionCard: some View {
    WatchHeroCard(glow: true) {
      Text(WatchStrings.autoDhikrSessionCompleteTitle)
        .font(.system(size: 16, weight: .semibold, design: .serif))
        .foregroundStyle(palette.onSurface)
      Text(model.autoDhikrState.phrase.title)
        .font(WatchType.label)
        .foregroundStyle(palette.accentSoft)
      Text("\(model.autoDhikrState.target) • \(model.autoDhikrState.intervalDisplay)")
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceSubtle)
      Text(WatchStrings.autoDhikrSessionCompleteBody)
        .font(WatchType.caption)
        .multilineTextAlignment(.center)
        .foregroundStyle(palette.onSurfaceSubtle)
      HStack(spacing: 8) {
        Button(WatchStrings.done) {
          model.dismissAutoDhikrCompletion()
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, minHeight: 44)

        Button(WatchStrings.autoDhikrBegin) {
          model.dismissAutoDhikrCompletion()
          model.beginAutoDhikr()
        }
        .buttonStyle(.borderedProminent)
        .tint(palette.accent)
        .frame(maxWidth: .infinity, minHeight: 44)
      }
    }
  }

  private var autoStatusTitle: String {
    switch model.autoDhikrState.phase {
    case .idle:
      return WatchStrings.autoDhikrTitle
    case .running:
      return WatchStrings.autoDhikrRunning
    case .paused:
      return WatchStrings.autoDhikrPaused
    case .completed:
      return WatchStrings.autoDhikrCompleted
    }
  }

  private func modeButton(_ mode: WatchDhikrMode, title: String) -> some View {
    Button(title) {
      model.setDhikrMode(mode)
    }
    .buttonStyle(.borderedProminent)
    .tint(model.dhikrMode == mode ? palette.accent : palette.surfaceSoft)
    .frame(maxWidth: .infinity, minHeight: 40)
    .disabled(mode == .manual && model.autoDhikrState.isRunning)
  }

  private func syncAutoSessionControlVisibility() {
    if model.autoDhikrState.isRunning {
      showAutoSessionControls = false
    } else if model.autoDhikrState.isPaused || model.autoDhikrState.isCompleted {
      showAutoSessionControls = true
    }
  }
}
