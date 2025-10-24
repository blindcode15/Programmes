import Foundation
import Combine

final class MoodViewModel: ObservableObject {
    @Published var undoAvailable: Bool = false
    private var undoTimer: Timer?
    private var lastAddedId: UUID?

    private var cancellables = Set<AnyCancellable>()

    init() {
        // listen if needed
    }

    func quickAdd(value: Int, emotion: Emotion) {
        MoodStore.shared.append(value: value, note: nil, emotion: emotion)
        lastAddedId = MoodStore.shared.latest()?.id
        startUndoTimer()
    }

    func fineAdd(value: Int, note: String?, emotion: Emotion?) {
        MoodStore.shared.append(value: value, note: note, emotion: emotion)
        lastAddedId = MoodStore.shared.latest()?.id
        startUndoTimer()
    }

    func undoLast() {
        guard undoAvailable else { return }
        MoodStore.shared.removeLast()
        undoAvailable = false
        undoTimer?.invalidate(); undoTimer = nil
    }

    private func startUndoTimer() {
        undoTimer?.invalidate()
        undoAvailable = true
        undoTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            self?.undoAvailable = false
        }
    }
}
