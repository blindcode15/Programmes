import Foundation

public struct TipsEngine {
    public struct Bank: Codable { let ranges: [RangeItem] }
    public struct RangeItem: Codable { let range: String; let phrases: [String] }

    private let phrases: [String: [String]]

    public init(jsonURL: URL) {
        if let data = try? Data(contentsOf: jsonURL),
           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: [String]] {
            self.phrases = dict
        } else {
            // Built-in fallback
            self.phrases = [
                "0-20": [
                    "Тяжёлый момент — это не навсегда.",
                    "Подыши глубже, дай себе 2 минуты тишины.",
                    "Напомни себе: ты уже справлялся раньше."
                ],
                "21-40": [
                    "Кажется, всё тянет вниз — сделай один маленький шаг.",
                    "Стакан воды и короткая прогулка могут помочь."
                ],
                "41-60": [
                    "Нейтрально — тоже состояние. Что одно маленькое улучшит день?",
                    "Проверь базовые потребности: сон, вода, еда."
                ],
                "61-80": [
                    "Отмечай приятные мелочи — они накапливаются.",
                    "Поддержи это состояние: музыка, движение, свет."
                ],
                "81-100": [
                    "Класс! Зафиксируй, что помогло — пригодится потом.",
                    "Поделись теплом с кем-то ещё — усилит эффект."
                ]
            ]
        }
    }

    public func phrases(for value: Int, count: Int = 3) -> [String] {
        let key: String
        switch value {
        case 0...20: key = "0-20"
        case 21...40: key = "21-40"
        case 41...60: key = "41-60"
        case 61...80: key = "61-80"
        case 81...100: key = "81-100"
        default: key = "41-60"
        }
        let list = phrases[key] ?? []
        return Array(list.shuffled().prefix(count))
    }

    public func advice(latest: Int, trend: Trend) -> [String] {
        var out = phrases(for: latest, count: 2)
        switch trend {
        case .down(let d) where d <= -5.0:
            out.append(contentsOf: [
                "Бережный режим: сон, вода, короткие прогулки, тёплые контакты.",
                "Не требуйте от себя слишком многого — маленькие шаги." 
            ])
        case .up(let d) where d >= 5.0:
            out.append(contentsOf: [
                "Поддерживающий режим: зафиксируйте триггеры (музыка, спорт, общение).",
                "Закрепите полезные привычки — они работают." 
            ])
        default:
            out.append("Держим стабильность: продолжайте замечать и поддерживать рабочие ритуалы.")
        }
        return out
    }
}
