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
                "0-2": [
                    "Тяжёлый момент — это не навсегда.",
                    "Подыши глубже, дай себе 2 минуты тишины.",
                    "Напомни себе: ты уже справлялся раньше."
                ],
                "3-4": [
                    "Кажется, всё тянет вниз — сделай один маленький шаг.",
                    "Стакан воды и короткая прогулка могут помочь."
                ],
                "5": [
                    "Нейтрально — тоже состояние. Что одно маленькое улучшит день?",
                    "Проверь базовые потребности: сон, вода, еда."
                ],
                "6-8": [
                    "Отмечай приятные мелочи — они накапливаются.",
                    "Поддержи это состояние: музыка, движение, свет."
                ],
                "9-10": [
                    "Класс! Зафиксируй, что помогло — пригодится потом.",
                    "Поделись теплом с кем-то ещё — усилит эффект."
                ]
            ]
        }
    }

    public func phrases(for value: Int, count: Int = 3) -> [String] {
        let key: String
        switch value {
        case 0...2: key = "0-2"
        case 3...4: key = "3-4"
        case 5: key = "5"
        case 6...8: key = "6-8"
        case 9...10: key = "9-10"
        default: key = "5"
        }
        let list = phrases[key] ?? []
        return Array(list.shuffled().prefix(count))
    }

    public func advice(latest: Int, trend: Trend) -> [String] {
        var out = phrases(for: latest, count: 2)
        switch trend {
        case .down(let d) where d <= -1.0:
            out.append(contentsOf: [
                "Бережный режим: сон, вода, короткие прогулки, тёплые контакты.",
                "Не требуйте от себя слишком многого — маленькие шаги." 
            ])
        case .up(let d) where d >= 1.0:
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
