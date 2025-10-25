import Foundation

// Extension for convenience on the shared MoodEntry model
public extension MoodEntry {
    var emoji: String {
        let v = max(0, min(100, value))
        // Use coarse buckets on 0..100
        switch v {
        case 0..<20: return "😞"
        case 20..<40: return "😟"
        case 40..<60: return "😐"
        case 60..<80: return "🙂"
        default: return "😄"
        }
    }
}
