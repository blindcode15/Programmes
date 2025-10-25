import AppIntents
import SwiftUI

@available(iOS 17.0, *)
struct QuickMoodIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Mood"
    static var description = IntentDescription("Save a quick mood value from the widget.")

    @Parameter(title: "Value")
    var value: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Save mood \(.$value)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        let clamped = max(0, min(100, value))
        MoodStore.shared.addQuick(value: clamped)
        return .result()
    }
}

@available(iOS 17.0, *)
struct OpenFineTuneIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Fine Tune"
    static var description = IntentDescription("Open the app to fine-tune mood.")

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        MoodStore.shared.triggerFineTuneSheet()
        return .result()
    }
}
