// Disabled legacy shim in favor of MoodStore+Shim.swift
#if false
import Foundation

public extension MoodStore {
    func load() -> [MoodEntry] { entries }

    func append(value: Int, note: String?) {
        addQuick(value: value, note: note)
    }

    func removeLast() {
        var list = entries
        _ = list.popLast()
        setEntries(list)
    }

    func latest() -> MoodEntry? { entries.last }

    func exportCSV() -> Data {
        exportCSV().data(using: .utf8) ?? Data()
    }
}
#endif
