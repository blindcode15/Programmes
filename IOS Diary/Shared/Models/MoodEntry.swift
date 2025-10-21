import Foundation

/// Represents a single mood record
/// value: 0...10 (or 0...100 if you prefer). We'll use 0...10 for UI simplicity.
public struct MoodEntry: Codable, Identifiable {
    public let id: UUID
    public let date: Date
    public let value: Int
    public let note: String?

    public init(id: UUID = UUID(), date: Date = Date(), value: Int, note: String? = nil) {
        self.id = id
        self.date = date
        self.value = value
        self.note = note
    }
}