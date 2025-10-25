// Disabled legacy extension (0..10 scale). Kept for history; not compiled.
#if false
import Foundation

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
#endif
