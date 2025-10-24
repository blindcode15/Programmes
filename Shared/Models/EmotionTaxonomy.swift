import Foundation

public enum EmotionFunction: String, Codable, CaseIterable {
    case phasic   // кратковременные, импульсивные
    case tonic    // устойчивые, фоновое настроение

    public var display: String {
        switch self {
        case .phasic: return "Разовые (импульсивные)"
        case .tonic: return "Постоянные (фоновые)"
        }
    }
}

public struct EmotionTaxonomy {
    public static let phasic: [String] = [
        "Восторг", "Гнев", "Страх", "Удивление", "Отвращение"
    ]
    public static let tonic: [String] = [
        "Спокойствие", "Уныние", "Тоска", "Грусть", "Радость", "Тревожность"
    ]
}

public extension Emotion {
    var function: EmotionFunction {
        switch self {
        case .joy: return .tonic
        case .anxiety: return .tonic
        case .anger: return .phasic
        case .sadness: return .tonic
        }
    }
}
