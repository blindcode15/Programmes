import AppIntents
import SwiftUI

// MARK: - Quick Mood Intent
@available(iOS 17.0, *)
struct QuickMoodIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Mood"
    static var description = IntentDescription("Save a quick mood value from the widget.")

    @Parameter(title: "Value")
    var value: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Save mood \(\.$value)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        // Clamp value 0...100
        let clamped = max(0, min(100, value))
        MoodStore.shared.addQuick(value: clamped)
        return .result()
    }
}

// MARK: - Open Fine Tune Intent
@available(iOS 17.0, *)
struct OpenFineTuneIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Fine Tune"
    static var description = IntentDescription("Open the app to fine-tune mood with slider and note.")

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        MoodStore.shared.triggerFineTuneSheet()
        return .result()
    }
}

// MARK: - App Shortcuts
@available(iOS 17.0, *)
struct MoodShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        [
            AppShortcut(
                intent: QuickMoodIntent(value: 50),
                phrases: ["Save mood in \(.application)"]
            ),
            AppShortcut(
                intent: OpenFineTuneIntent(),
                phrases: ["Fine tune mood in \(.application)"]
            )
        ]
    }
}
