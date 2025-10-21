import Foundation
import Combine

/// Simple persistence over UserDefaults with App Group, JSON encoding
public final class MoodStore: ObservableObject {
    public static let shared = MoodStore()

    private let appGroupID = "group.com.yourcompany.mood"
    private let entriesKey = "mood_entries"
    private let fineTuneFlagKey = "fine_tune_flag"

    @Published public private(set) var entries: [MoodEntry] = []

    private var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    private init() {
        load()
    }

    // MARK: - Entries
    public func addQuick(value: Int, note: String? = nil) {
        var list = entries
        list.append(MoodEntry(value: value, note: note))
        save(list)
    }

    public func setEntries(_ newEntries: [MoodEntry]) {
        save(newEntries)
    }

    // MARK: - Fine tune flag
    public func triggerFineTuneSheet() {
        defaults?.set(true, forKey: fineTuneFlagKey)
    }

    /// Consumes the flag and returns whether to show the sheet.
    public func consumeFineTuneFlag() -> Bool {
        let flag = defaults?.bool(forKey: fineTuneFlagKey) ?? false
        if flag {
            defaults?.set(false, forKey: fineTuneFlagKey)
        }
        return flag
    }

    // MARK: - Export
    public func exportJSON() -> Data? {
        try? JSONEncoder().encode(entries)
    }

    public func exportCSV() -> String {
        let header = "id,date,value,note"
        let dateFormatter = ISO8601DateFormatter()
        let rows = entries.map { e in
            let note = e.note?.replacingOccurrences(of: ",", with: " ") ?? ""
            return "\(e.id.uuidString),\(dateFormatter.string(from: e.date)),\(e.value),\(note)"
        }
        return ([header] + rows).joined(separator: "\n")
    }

    // MARK: - Notifications
    public func scheduleDailyReminder(hour: Int = 20, minute: Int = 0) {
        NotificationHelper.scheduleDaily(hour: hour, minute: minute)
    }

    // MARK: - Persistence
    private func load() {
        guard let data = defaults?.data(forKey: entriesKey) else { return }
        if let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            self.entries = decoded
        }
    }

    private func save(_ list: [MoodEntry]) {
        entries = list.sorted { $0.date < $1.date }
        if let data = try? JSONEncoder().encode(entries) {
            defaults?.set(data, forKey: entriesKey)
        }
    }
}