import Foundation

// Extension for convenience on the shared MoodEntry model
public extension MoodEntry {
    var emoji: String {
        switch value {
        case ..<3: return "😞"
        case 3..<5: return "😐"
        case 5..<8: return "🙂"
        default: return "😄"
        }
    }
}
