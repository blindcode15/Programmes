import WidgetKit
import SwiftUI
import AppIntents

@main
struct MoodWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "MoodWidget", intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MoodWidgetView(entry: entry)
        }
        .configurationDisplayName("Mood Diary")
        .description("Quickly log your mood right from the Home Screen.")
        .supportedFamilies([.systemMedium])
    }
}

struct ConfigurationAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Mood Widget"
}

struct MoodEntryTimeline: TimelineEntry {
    let date: Date
    let lastValue: Int?
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MoodEntryTimeline {
        .init(date: Date(), lastValue: 5)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MoodEntryTimeline {
        .init(date: Date(), lastValue: MoodStore.shared.entries.last?.value)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<MoodEntryTimeline> {
        let entry = MoodEntryTimeline(date: Date(), lastValue: MoodStore.shared.entries.last?.value)
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

struct MoodWidgetView: View {
    var entry: MoodEntryTimeline

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Button(intent: QuickMoodIntent(value: 1)) { Text("😞") }
                Button(intent: QuickMoodIntent(value: 4)) { Text("😐") }
                Button(intent: QuickMoodIntent(value: 7)) { Text("🙂") }
                Button(intent: QuickMoodIntent(value: 9)) { Text("😄") }
                Button(intent: OpenFineTuneIntent()) { Image(systemName: "slider.horizontal.3") }
            }
            .font(.title)

            if let last = entry.lastValue {
                Text("Last: \(last)/10")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .containerBackground(.background, for: .widget)
        .invalidatableContent()
    }
}