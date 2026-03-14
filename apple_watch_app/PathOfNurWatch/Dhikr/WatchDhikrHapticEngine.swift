import WatchKit

final class WatchDhikrHapticEngine {
    func playConfirmation() {
        WKInterfaceDevice.current().play(.click)
    }

    func playGuidancePulse() {
        WKInterfaceDevice.current().play(.click)
    }

    func play(for milestone: DhikrMilestone) {
        switch milestone {
        case .none:
            break
        case .milestone33, .milestone66, .milestone99:
            WKInterfaceDevice.current().play(.directionUp)
        case .targetCompleted:
            WKInterfaceDevice.current().play(.success)
        }
    }
}
