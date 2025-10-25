import Foundation

public enum Emotion: String, Codable, CaseIterable {
    case joy
    case anxiety
    case anger
    case sadness

    public var display: String {
        switch self {
        case .joy: return "Радость"
        case .anxiety: return "Беспокойство"
        case .anger: return "Злость"
        case .sadness: return "Печаль"
        }
    }
}

/// Represents a single mood record
/// value: 0...100 scale.
public struct MoodEntry: Codable, Identifiable {
    public let id: UUID
    public let date: Date
    public let value: Int
    public let note: String?
    public let emotion: Emotion?
    public let customEmoji: String?

    public init(id: UUID = UUID(), date: Date = Date(), value: Int, note: String? = nil, emotion: Emotion? = nil, customEmoji: String? = nil) {
        self.id = id
        self.date = date
        self.value = value
        self.note = note
        self.emotion = emotion
        self.customEmoji = customEmoji
    }
}