import Foundation

final class WatchDhikrPulseEngine {
    private var timer: Timer?

    func start(interval: TimeInterval, onPulse: @escaping () -> Void) {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            onPulse()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
