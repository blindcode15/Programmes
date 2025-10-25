import Foundation

// Shim API matching the requested interface while using the existing MoodStore
public extension MoodStore {
    // Snapshot helpers with explicit names to avoid collisions
    func entriesSnapshot() -> [MoodEntry] { entries }

    func append(value: Int, note: String?, emotion: Emotion? = nil) {
        addQuick(value: value, note: note, emotion: emotion)
    }

    func removeLastEntry() {
        var list = entries
        _ = list.popLast()
        setEntries(list)
    }

    func latestEntry() -> MoodEntry? { entries.last }

    // Avoid name collision with existing exportCSV() -> String
    func exportCSVData() -> Data {
        exportCSV().data(using: .utf8) ?? Data()
    }
}
