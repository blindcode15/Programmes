import Foundation

// Shim API matching the requested interface while using the existing MoodStore
public extension MoodStore {
    // Do not clash with internal private load(); give a unique name
    func snapshot() -> [MoodEntry] { entries }

    func append(value: Int, note: String?) {
        addQuick(value: value, note: note)
    }

    func removeLast() {
        var list = entries
        _ = list.popLast()
        setEntries(list)
    }

    func latest() -> MoodEntry? { entries.last }

    // Avoid name collision with existing exportCSV() -> String
    func exportCSVData() -> Data {
        exportCSV().data(using: .utf8) ?? Data()
    }
}
