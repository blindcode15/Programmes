import Foundation

public struct PsychKnowledgeBase: Sendable {
    public struct StateInfo: Codable {
        public let key: String
        public let title: String
        public let tips: [String]
        public let phrases: [String]
    }

    public let states: [StateInfo]
    public let phasicLabels: [String]

    public init(bundle: Bundle = .main) {
        // Attempt to load from JSON resources; fallback to minimal defaults
        if let url = bundle.url(forResource: "PsychDB/states", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([StateInfo].self, from: data) {
            self.states = decoded
        } else {
            self.states = [
                StateInfo(key: "joyfulCalm", title: "Радостное спокойствие", tips: ["Заметьте моменты легкости"], phrases: ["Дышу ровно", "Мне спокойно"]),
                StateInfo(key: "neutral", title: "Нейтрально", tips: ["Подумайте, что принесет ясность"], phrases: ["Стабильно", "Нормально"])
            ]
        }
        if let url = bundle.url(forResource: "PsychDB/phasic", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            self.phasicLabels = decoded
        } else {
            self.phasicLabels = ["Вспышка радости", "Скачок тревоги", "Вспышка гнева"]
        }
    }
}
