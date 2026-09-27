import SwiftUI

/// Full-screen routine player for the living room: one phrase at a time,
/// large Arabic, a bead-style ring for the step, and a pace the room can
/// follow without holding the remote. Select counts one; play/pause lets
/// the TV count on its own.
///
/// A phrase of the counter is a routine of one step and is counted here
/// too, without what speaks of steps.
struct TVDhikrRoutinePlayerScreen: View {
  @ObservedObject var viewModel: TVDhikrViewModel
  @Environment(\.dismiss) private var dismiss
  @FocusState private var focusedControl: String?
  @State private var focusSeeker = TVFocusSeeker()

  var body: some View {
    ZStack {
      // The same sky as the page beneath, and nothing of the page itself: a
      // cover drawn in the card colours is see-through, because they are.
      TVCoverBackground()

      VStack(spacing: 28) {
        _header

        Spacer(minLength: 0)

        if viewModel.isRoutineComplete {
          _completionCard
        } else {
          _stage
        }

        Spacer(minLength: 0)

        if !viewModel.isRoutineComplete {
          _controls
        }
      }
      .padding(.horizontal, 72)
      .padding(.vertical, 42)
    }
    .onAppear {
      focusSeeker.seek("routine.count", with: $focusedControl)
    }
    .onExitCommand {
      viewModel.closeRoutinePlayer()
      dismiss()
    }
    .onPlayPauseCommand {
      viewModel.toggleRoutinePacing()
    }
  }

  private var _header: some View {
    HStack(alignment: .top, spacing: 20) {
      VStack(alignment: .leading, spacing: 10) {
        Text(viewModel.activeRoutine?.title ?? tvLocalized("Routine"))
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)
          .tvReadableTitle()

        if _hasSteps {
          Text(_stepLine)
            .font(TVTypography.sectionSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableBody()
        }

        Text(viewModel.isRoutinePacing ? tvLocalized("The TV is counting") : tvLocalized("Select counts one. Play/Pause lets the TV count."))
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.accentStrong)
          .tvReadableBody()
      }

      Spacer()

      Button {
        viewModel.closeRoutinePlayer()
        dismiss()
      } label: {
        Label(_leaveTitle, systemImage: "xmark.circle.fill")
          .font(TVTypography.chip)
          .foregroundColor(TVTheme.textPrimary)
          .padding(.horizontal, 20)
          .padding(.vertical, 14)
          .background(TVTheme.surfaceSoft, in: Capsule())
      }
      .buttonStyle(TVCardButtonStyle(shape: .capsule))
      .tvFocusID($focusedControl, "routine.exit")
      .accessibilityLabel(_leaveTitle)
    }
  }

  /// A routine has steps to speak of; a phrase is its own one step.
  private var _hasSteps: Bool {
    viewModel.activeRoutine?.isPhrase != true
  }

  private var _leaveTitle: String {
    _hasSteps ? tvLocalized("Leave routine") : tvLocalized("Leave")
  }

  private var _stepLine: String {
    guard let routine = viewModel.activeRoutine else { return "" }
    return tvLocalized("Step %d of %d", viewModel.routineStepIndex + 1, routine.steps.count)
  }

  private var _stage: some View {
    HStack(alignment: .center, spacing: 40) {
      VStack(spacing: 22) {
        if let step = viewModel.routineStep {
          // A phrase's name is already the heading of the screen.
          if _hasSteps {
            Text(step.title)
              .font(TVTypography.featureSubtitle)
              .foregroundColor(TVTheme.accentStrong)
              .tvReadableBody()
          }

          ScrollView(.vertical, showsIndicators: false) {
            Text(step.arabic)
              .font(step.isLongText ? TVTypography.arabicHero : TVTypography.arabicListening)
              .foregroundColor(TVTheme.textPrimary)
              .multilineTextAlignment(.center)
              .frame(maxWidth: 1000, alignment: .center)
              .tvReadableArabic()
          }
          .frame(maxHeight: step.isLongText ? 300 : 180)

          Text(step.transliteration)
            .font(TVTypography.featureSubtitle.italic())
            .italic()
            .foregroundColor(TVTheme.textMuted)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .frame(maxWidth: 980)
            .tvReadableBody()

          Text(step.translation)
            .font(TVTypography.body)
            .foregroundColor(TVTheme.textSecondary)
            .multilineTextAlignment(.center)
            .lineLimit(4)
            .frame(maxWidth: 980)
            .tvReadableBody()

          if !step.sourceRef.isEmpty {
            Text(step.sourceRef)
              .font(TVTypography.caption)
              .foregroundColor(TVTheme.textMuted)
          }
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 36)
      .padding(.vertical, 28)
      .tvSurfaceCard(elevated: true, emphasized: true)

      _ring
    }
  }

  private var _ring: some View {
    let step = viewModel.routineStep
    let target = max(step?.count ?? 1, 1)
    let fraction = min(Double(viewModel.routineStepCount) / Double(target), 1)
    let beads = min(target, 33)
    return VStack(spacing: 16) {
      ZStack {
        Circle()
          .stroke(TVTheme.accentStrong.opacity(0.18), lineWidth: 2)
          .frame(width: 300, height: 300)
        ForEach(0..<beads, id: \.self) { index in
          let angle = -Double.pi / 2 + 2 * Double.pi * Double(index) / Double(beads)
          let lit = index < Int((fraction * Double(beads)).rounded(.down)) || (fraction >= 1)
          Circle()
            .fill(index == 0 ? TVTheme.accentStrong : (lit ? TVTheme.focus : Color.clear))
            .overlay(
              Circle().stroke(TVTheme.focus.opacity(lit ? 0 : 0.6), lineWidth: 2)
            )
            .frame(width: index == 0 ? 16 : 13, height: index == 0 ? 16 : 13)
            .offset(x: 150 * CGFloat(cos(angle)), y: 150 * CGFloat(sin(angle)))
        }
        VStack(spacing: 4) {
          Text("\(viewModel.routineStepCount)")
            .font(.custom("Figtree-SemiBold", size: 96))
            .foregroundColor(TVTheme.textPrimary)
          Text(tvLocalized("of %d", target))
            .font(TVTypography.summaryLine)
            .foregroundColor(TVTheme.textSecondary)
        }
      }
      .frame(width: 340, height: 340)

      if let next = viewModel.routineNextStep {
        Text(tvLocalized("Next: %@ × %d", next.title, next.count))
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .frame(maxWidth: 340)
      } else if _hasSteps {
        Text(tvLocalized("Last step"))
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
      }
    }
    .frame(width: 380)
  }

  private var _controls: some View {
    HStack(spacing: 20) {
      _controlButton(
        title: tvLocalized("Count"),
        systemImage: "plus.circle.fill",
        focusID: "routine.count",
        emphasized: true
      ) {
        viewModel.countRoutine()
      }
      _controlButton(
        title: viewModel.isRoutinePacing ? tvLocalized("Pause") : tvLocalized("Let the TV count"),
        systemImage: viewModel.isRoutinePacing ? "pause.circle.fill" : "play.circle.fill",
        focusID: "routine.pace"
      ) {
        viewModel.toggleRoutinePacing()
      }
      _controlButton(
        title: tvLocalized("Undo"),
        systemImage: "arrow.uturn.backward.circle.fill",
        focusID: "routine.undo"
      ) {
        viewModel.undoRoutine()
      }
      if _hasSteps {
        _controlButton(
          title: tvLocalized("Skip step"),
          systemImage: "forward.end.circle.fill",
          focusID: "routine.skip"
        ) {
          viewModel.skipRoutineStep()
        }
      }
    }
    .padding(.horizontal, 28)
    .padding(.vertical, 20)
    .tvSurfaceCard(elevated: true, emphasized: false)
  }

  private var _completionCard: some View {
    VStack(spacing: 20) {
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 64, weight: .semibold))
        .foregroundColor(TVTheme.accentStrong)
      Text("ٱلْحَمْدُ لِلَّهِ")
        .font(TVTypography.arabicHero)
        .foregroundColor(TVTheme.textPrimary)
      Text(tvLocalized("%@ complete", viewModel.activeRoutine?.title ?? tvLocalized("Routine")))
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()
      Text(tvLocalized("%d remembrances · %@", viewModel.activeRoutine?.totalCount ?? 0, viewModel.routineElapsedLabel))
        .font(TVTypography.sectionSubtitle)
        .foregroundColor(TVTheme.textSecondary)
      if _hasSteps {
        Text(tvLocalized("Today’s routines are remembered on this Apple TV."))
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
          .multilineTextAlignment(.center)
          .frame(maxWidth: 820)
      }

      HStack(spacing: 20) {
        _controlButton(
          title: tvLocalized("Done"),
          systemImage: "checkmark.circle.fill",
          focusID: "routine.done",
          emphasized: true
        ) {
          viewModel.closeRoutinePlayer()
          dismiss()
        }
        _controlButton(
          title: tvLocalized("Again"),
          systemImage: "arrow.clockwise.circle.fill",
          focusID: "routine.again"
        ) {
          viewModel.restartRoutine()
          focusSeeker.seek("routine.count", with: $focusedControl)
        }
      }
    }
    .frame(maxWidth: 1100)
    .padding(.horizontal, 48)
    .padding(.vertical, 40)
    .tvSurfaceCard(elevated: true, emphasized: true)
    .onAppear {
      focusSeeker.seek("routine.done", with: $focusedControl)
    }
  }

  private func _controlButton(
    title: String,
    systemImage: String,
    focusID: String,
    emphasized: Bool = false,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Label(title, systemImage: systemImage)
        .font(TVTypography.chip)
        .foregroundColor(emphasized ? TVTheme.backgroundBottom : TVTheme.textPrimary)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(emphasized ? TVTheme.accentStrong : TVTheme.surfaceSoft, in: Capsule())
    }
    // The button takes the focus itself. Wrapped in a card that takes it,
    // the card has the focus and a press never reaches the button.
    .buttonStyle(TVCardButtonStyle(shape: .capsule))
    .tvFocusID($focusedControl, focusID)
    .accessibilityLabel(title)
  }
}
