import Foundation
import Combine

// Widget-only lightweight store stub
public final class MoodStore: ObservableObject {
    public static let shared = MoodStore()

    private let appGroupID = "group.com.yourcompany.mood"
    private let entriesKey = "mood_entries"
    private let fineTuneFlagKey = "fine_tune_flag"

    @Published public private(set) var entries: [MoodEntry] = []

    private var defaults: UserDefaults { UserDefaults(suiteName: appGroupID) ?? .standard }

    private init() { load() }

    public func addQuick(value: Int, note: String? = nil) {
        var list = entries
        list.append(MoodEntry(value: value, note: note))
        save(list)
    }

    public func triggerFineTuneSheet() {
        defaults.set(true, forKey: fineTuneFlagKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: entriesKey) else { return }
        if let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            self.entries = decoded
        }
    }

    private func save(_ list: [MoodEntry]) {
        entries = list.sorted { $0.date < $1.date }
        if let data = try? JSONEncoder().encode(entries) { defaults.set(data, forKey: entriesKey) }
    }
}
