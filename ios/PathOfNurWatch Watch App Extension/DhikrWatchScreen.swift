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

        routinesEntry

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

  private var routinesEntry: some View {
    Button(action: model.openDhikrRoutines) {
      HStack(spacing: 10) {
        Image(systemName: "list.bullet.rectangle.fill")
          .font(.system(size: 15, weight: .semibold))
          .foregroundStyle(palette.accent)
        VStack(alignment: .leading, spacing: 2) {
          Text(WatchStrings.dhikrRoutinesTitle)
            .font(WatchType.label)
            .foregroundStyle(palette.onSurface)
          Text(routinesEntrySubtitle)
            .font(WatchType.caption)
            .foregroundStyle(palette.onSurfaceSubtle)
            .lineLimit(1)
        }
        Spacer(minLength: 0)
        Image(systemName: "chevron.right")
          .font(.system(size: 11, weight: .semibold))
          .foregroundStyle(palette.onSurfaceMuted)
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .fill(palette.surface.opacity(0.9))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .strokeBorder(palette.accent.opacity(0.28), lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
  }

  private var routinesEntrySubtitle: String {
    if let routine = model.activeDhikrRoutine, let progress = model.dhikrRoutineProgress {
      return "\(routine.title) • \(WatchStrings.dhikrRoutineStepOf(progress.stepIndex + 1, routine.steps.count))"
    }
    let count = model.dhikrRoutines.count
    return count == 0 ? WatchStrings.dhikrRoutinesSubtitle : "\(count) • \(WatchStrings.dhikrRoutinesSubtitle)"
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


// MARK: - Routines sheet

/// The routines the phone sent, then the player for the one chosen. One
/// sheet, two states, so leaving mid-way and coming back resumes.
struct WatchDhikrRoutinesScreen: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette
  @Environment(\.dismiss) private var dismiss
  @State private var selectedRoutineId: String?

  var body: some View {
    Group {
      if let completion = model.dhikrRoutineCompletion {
        completionCard(completion)
      } else if let routine = playingRoutine {
        WatchDhikrRoutinePlayerView(routine: routine) {
          selectedRoutineId = nil
        }
      } else {
        routineList
      }
    }
    .containerBackground(palette.backgroundGradient, for: .navigation)
    .onAppear {
      if selectedRoutineId == nil, let active = model.activeDhikrRoutine {
        selectedRoutineId = active.id
      }
    }
    .alert(WatchStrings.dhikrAntiRushTitle, isPresented: Binding(
      get: { model.showDhikrAntiRushReminder },
      set: { value in
        if !value { model.dismissDhikrAntiRushReminder() }
      }
    )) {
      Button(WatchStrings.dhikrAntiRushAcknowledge) {
        model.dismissDhikrAntiRushReminder()
      }
    } message: {
      Text(WatchStrings.dhikrAntiRushBody)
    }
  }

  private var playingRoutine: WatchDhikrRoutinePayload? {
    guard let selectedRoutineId else { return nil }
    return model.dhikrRoutine(withId: selectedRoutineId)
  }

  private var routineList: some View {
    ScrollView {
      VStack(spacing: 10) {
        WatchScreenHeader(WatchStrings.dhikrRoutinesTitle)

        if model.dhikrRoutines.isEmpty {
          WatchHeroCard {
            Text(WatchStrings.dhikrRoutinesEmpty)
              .font(WatchType.caption)
              .multilineTextAlignment(.center)
              .foregroundStyle(palette.onSurfaceSubtle)
          }
        }

        ForEach(model.dhikrRoutines) { routine in
          Button {
            model.startDhikrRoutine(routine)
            selectedRoutineId = routine.id
          } label: {
            routineRow(routine)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
    }
  }

  private func routineRow(_ routine: WatchDhikrRoutinePayload) -> some View {
    let isActive = model.dhikrRoutineProgress?.routineId == routine.id
    let done = model.isDhikrRoutineDoneToday(routine)
    return HStack(spacing: 10) {
      Image(systemName: routine.systemImage)
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(palette.accent)
        .frame(width: 22)
      VStack(alignment: .leading, spacing: 2) {
        Text(routine.title)
          .font(.system(size: 14, weight: .semibold, design: .serif))
          .foregroundStyle(palette.onSurface)
          .lineLimit(1)
        Text(routineRowSubtitle(routine, isActive: isActive, done: done))
          .font(WatchType.caption)
          .foregroundStyle(done ? palette.success : palette.onSurfaceSubtle)
          .lineLimit(1)
      }
      Spacer(minLength: 0)
      if done {
        Image(systemName: "checkmark.circle.fill")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(palette.success)
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(palette.surface.opacity(0.9))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .strokeBorder(palette.accent.opacity(isActive ? 0.6 : 0.28), lineWidth: 1)
    )
  }

  private func routineRowSubtitle(
    _ routine: WatchDhikrRoutinePayload,
    isActive: Bool,
    done: Bool
  ) -> String {
    if isActive, let progress = model.dhikrRoutineProgress {
      return "\(WatchStrings.dhikrRoutineContinue) • \(WatchStrings.dhikrRoutineStepOf(progress.stepIndex + 1, routine.steps.count))"
    }
    if done { return WatchStrings.dhikrRoutineDoneToday }
    return WatchStrings.dhikrRoutineMeta(routine.steps.count, routine.estimatedMinutes)
  }

  private func completionCard(_ completion: WatchDhikrRoutineCompletion) -> some View {
    ScrollView {
      VStack(spacing: 12) {
        WatchHeroCard(glow: true) {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 26, weight: .semibold))
            .foregroundStyle(palette.accent)
          Text(WatchStrings.dhikrRoutineCompleteTitle)
            .font(.system(size: 16, weight: .semibold, design: .serif))
            .foregroundStyle(palette.onSurface)
          Text(completion.routine.title)
            .font(WatchType.label)
            .foregroundStyle(palette.accentSoft)
          Text("\(completion.routine.totalCount) • \(Self.durationLabel(completion.duration))")
            .font(WatchType.caption)
            .foregroundStyle(palette.onSurfaceSubtle)
          Text(WatchStrings.dhikrRoutineCompleteBody)
            .font(WatchType.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(palette.onSurfaceSubtle)
          Button(WatchStrings.done) {
            model.dismissDhikrRoutineCompletion()
            selectedRoutineId = nil
          }
          .buttonStyle(.borderedProminent)
          .tint(palette.accent)
          .frame(maxWidth: .infinity, minHeight: 44)
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
    }
  }

  static func durationLabel(_ interval: TimeInterval) -> String {
    let seconds = max(Int(interval.rounded()), 0)
    return String(format: "%d:%02d", seconds / 60, seconds % 60)
  }
}

/// One routine, one step at a time: the phrase, a ring for the step, the
/// whole card as the tap well. Steps advance on their own.
struct WatchDhikrRoutinePlayerView: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette
  let routine: WatchDhikrRoutinePayload
  let onLeave: () -> Void

  var body: some View {
    let progress = model.dhikrRoutineProgress
    let stepIndex = min(max(progress?.stepIndex ?? 0, 0), max(routine.steps.count - 1, 0))
    let stepCount = progress?.stepCount ?? 0
    let step = routine.steps.indices.contains(stepIndex) ? routine.steps[stepIndex] : nil

    ScrollView {
      VStack(spacing: 10) {
        VStack(spacing: 2) {
          Text(routine.title)
            .font(.system(size: 13, weight: .semibold, design: .serif))
            .foregroundStyle(palette.accent)
            .lineLimit(1)
          Text(WatchStrings.dhikrRoutineStepOf(stepIndex + 1, routine.steps.count))
            .font(WatchType.caption)
            .foregroundStyle(palette.onSurfaceSubtle)
        }

        if let step {
          WatchHeroCard(glow: false) {
            Text(step.arabic)
              .font(.system(size: step.isLongText ? 15 : 20, weight: .medium))
              .multilineTextAlignment(.center)
              .environment(\.layoutDirection, .rightToLeft)
              .lineLimit(step.isLongText ? 4 : 2)
              .minimumScaleFactor(0.7)
              .foregroundStyle(palette.onSurface)
            Text(step.title)
              .font(.system(size: 12, weight: .semibold, design: .serif))
              .foregroundStyle(palette.onSurfaceSubtle)
              .lineLimit(2)
              .multilineTextAlignment(.center)
            Button(action: model.tapDhikrRoutine) {
              VStack(spacing: 6) {
                WatchMiniProgressRing(
                  progress: step.count <= 0 ? 1 : min(Double(stepCount) / Double(step.count), 1),
                  lineWidth: 10,
                  label: "\(stepCount)"
                )
                .frame(width: 88, height: 88)
                Text(WatchStrings.dhikrRoutineOfTarget(stepCount, step.count))
                  .font(WatchType.label)
                  .foregroundStyle(palette.accentSoft)
                Text(WatchStrings.dhikrRoutineTapToCount)
                  .font(WatchType.caption)
                  .foregroundStyle(palette.onSurfaceSubtle)
              }
              .frame(maxWidth: .infinity, minHeight: 120)
              .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                  .fill(palette.accent.opacity(0.14))
              )
              .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                  .strokeBorder(palette.accent.opacity(0.4), lineWidth: 1)
              )
              .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            .buttonStyle(.plain)
          }
        }

        HStack(spacing: 8) {
          Button(WatchStrings.dhikrRoutineUndo, action: model.undoDhikrRoutine)
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, minHeight: 40)
            .disabled((progress?.stepCount ?? 0) == 0 && (progress?.stepIndex ?? 0) == 0)
          Button(WatchStrings.dhikrRoutineSkip, action: model.skipDhikrRoutineStep)
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, minHeight: 40)
        }
        HStack(spacing: 8) {
          Button(WatchStrings.dhikrRoutineRestart, action: model.restartDhikrRoutine)
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, minHeight: 40)
          Button(WatchStrings.dhikrRoutineLeave, action: onLeave)
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, minHeight: 40)
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
    }
    .onAppear {
      if model.dhikrRoutineProgress?.routineId != routine.id {
        model.startDhikrRoutine(routine)
      }
    }
  }
}
