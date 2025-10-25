import SwiftUI

public enum PersistentMoodState: String, CaseIterable, Codable {
    case bliss, joyfulCalm, hopeful, content, focused, productive, reflective, neutral,
         uneasy, irritated, angry, sad, sorrowful, grieving, exhausted,
         melancholic, overwhelmed, despair, panic, tragic

    public var display: String {
        switch self {
        case .bliss: return "Экстаз"
        case .joyfulCalm: return "Радостное спокойствие"
        case .hopeful: return "Надежда"
        case .content: return "Довольство"
        case .focused: return "Сосредоточенность"
        case .productive: return "Продуктивность"
        case .reflective: return "Рефлексивность"
        case .neutral: return "Нейтрально"
        case .uneasy: return "Неловкость/Тревога"
        case .irritated: return "Раздражение"
        case .angry: return "Злость"
        case .sad: return "Грусть"
        case .sorrowful: return "Печаль"
        case .grieving: return "Горе"
        case .exhausted: return "Истощение"
        case .melancholic: return "Меланхолия"
        case .overwhelmed: return "Перегруженность"
        case .despair: return "Отчаяние"
        case .panic: return "Паника"
        case .tragic: return "Трагичность"
        }
    }

    public struct Tone {
        public let day: [Color]
        public let night: [Color]
    }

    public struct BackgroundSpec {
        public let speed: Double
        public let opacity: Double
        public let swirl: Bool
    }

    public struct InteractionSpec {
        public let pressScale: CGFloat
        public let pressDuration: Double
        public let glow: Double
    }

    public struct ChartSpec {
        public let line: Color
        public let phasic: Color
    }

    public enum BackgroundProgram: String, Codable {
        case aurora, bubbles, fire, rain, thunder, stars
    }

    public var tone: Tone {
        switch self {
        case .bliss: return Tone(day: [.yellow, .orange], night: [.orange, .pink])
        case .joyfulCalm: return Tone(day: [.mint, .teal], night: [.teal, .blue])
        case .hopeful: return Tone(day: [.green, .teal], night: [.teal, .indigo])
        case .content: return Tone(day: [.cyan, .blue], night: [.indigo, .purple])
        case .focused: return Tone(day: [.blue, .indigo], night: [.indigo, .black])
        case .productive: return Tone(day: [.green, .cyan], night: [.green, .teal])
        case .reflective: return Tone(day: [.purple, .indigo], night: [.purple, .black])
        case .neutral: return Tone(day: [.gray.opacity(0.6), .gray.opacity(0.3)], night: [.gray.opacity(0.9), .black])
        case .uneasy: return Tone(day: [.cyan, .orange], night: [.indigo, .orange])
        case .irritated: return Tone(day: [.orange, .red], night: [.red, .pink])
        case .angry: return Tone(day: [.red, .pink], night: [.red, .purple])
        case .sad: return Tone(day: [.blue, .indigo], night: [.indigo, .black])
        case .sorrowful: return Tone(day: [.indigo, .purple], night: [.purple, .black])
        case .grieving: return Tone(day: [.gray, .indigo], night: [.black, .indigo])
        case .exhausted: return Tone(day: [.gray, .blue.opacity(0.5)], night: [.black, .gray])
        case .melancholic: return Tone(day: [.purple, .blue], night: [.purple, .black])
        case .overwhelmed: return Tone(day: [.pink, .orange], night: [.pink, .red])
        case .despair: return Tone(day: [.gray, .purple], night: [.black, .purple])
        case .panic: return Tone(day: [.yellow, .red], night: [.orange, .red])
        case .tragic: return Tone(day: [.black, .red], night: [.black, .red])
        }
    }

    public var background: BackgroundSpec {
        switch self {
        case .bliss: return BackgroundSpec(speed: 0.25, opacity: 0.22, swirl: true)
        case .joyfulCalm: return BackgroundSpec(speed: 0.22, opacity: 0.18, swirl: true)
        case .hopeful: return BackgroundSpec(speed: 0.20, opacity: 0.16, swirl: true)
        case .content: return BackgroundSpec(speed: 0.18, opacity: 0.14, swirl: false)
        case .focused: return BackgroundSpec(speed: 0.16, opacity: 0.12, swirl: false)
        case .productive: return BackgroundSpec(speed: 0.20, opacity: 0.15, swirl: false)
        case .reflective: return BackgroundSpec(speed: 0.15, opacity: 0.14, swirl: true)
        case .neutral: return BackgroundSpec(speed: 0.12, opacity: 0.10, swirl: false)
        case .uneasy: return BackgroundSpec(speed: 0.22, opacity: 0.16, swirl: true)
        case .irritated: return BackgroundSpec(speed: 0.26, opacity: 0.20, swirl: true)
        case .angry: return BackgroundSpec(speed: 0.28, opacity: 0.22, swirl: true)
        case .sad: return BackgroundSpec(speed: 0.14, opacity: 0.14, swirl: false)
        case .sorrowful: return BackgroundSpec(speed: 0.13, opacity: 0.14, swirl: false)
        case .grieving: return BackgroundSpec(speed: 0.12, opacity: 0.12, swirl: false)
        case .exhausted: return BackgroundSpec(speed: 0.10, opacity: 0.10, swirl: false)
        case .melancholic: return BackgroundSpec(speed: 0.12, opacity: 0.13, swirl: true)
        case .overwhelmed: return BackgroundSpec(speed: 0.24, opacity: 0.18, swirl: true)
        case .despair: return BackgroundSpec(speed: 0.11, opacity: 0.12, swirl: false)
        case .panic: return BackgroundSpec(speed: 0.30, opacity: 0.24, swirl: true)
        case .tragic: return BackgroundSpec(speed: 0.12, opacity: 0.22, swirl: false)
        }
    }

    public var interaction: InteractionSpec {
        switch self {
        case .bliss: return InteractionSpec(pressScale: 0.95, pressDuration: 0.15, glow: 0.45)
        case .joyfulCalm: return InteractionSpec(pressScale: 0.94, pressDuration: 0.18, glow: 0.40)
        case .hopeful: return InteractionSpec(pressScale: 0.94, pressDuration: 0.18, glow: 0.35)
        case .content: return InteractionSpec(pressScale: 0.93, pressDuration: 0.20, glow: 0.30)
        case .focused: return InteractionSpec(pressScale: 0.93, pressDuration: 0.22, glow: 0.25)
        case .productive: return InteractionSpec(pressScale: 0.93, pressDuration: 0.20, glow: 0.30)
        case .reflective: return InteractionSpec(pressScale: 0.93, pressDuration: 0.22, glow: 0.32)
        case .neutral: return InteractionSpec(pressScale: 0.92, pressDuration: 0.22, glow: 0.20)
        case .uneasy: return InteractionSpec(pressScale: 0.92, pressDuration: 0.18, glow: 0.30)
        case .irritated: return InteractionSpec(pressScale: 0.91, pressDuration: 0.16, glow: 0.35)
        case .angry: return InteractionSpec(pressScale: 0.90, pressDuration: 0.14, glow: 0.42)
        case .sad: return InteractionSpec(pressScale: 0.93, pressDuration: 0.24, glow: 0.22)
        case .sorrowful: return InteractionSpec(pressScale: 0.93, pressDuration: 0.24, glow: 0.24)
        case .grieving: return InteractionSpec(pressScale: 0.93, pressDuration: 0.26, glow: 0.22)
        case .exhausted: return InteractionSpec(pressScale: 0.94, pressDuration: 0.26, glow: 0.18)
        case .melancholic: return InteractionSpec(pressScale: 0.93, pressDuration: 0.25, glow: 0.26)
        case .overwhelmed: return InteractionSpec(pressScale: 0.91, pressDuration: 0.18, glow: 0.36)
        case .despair: return InteractionSpec(pressScale: 0.94, pressDuration: 0.28, glow: 0.20)
        case .panic: return InteractionSpec(pressScale: 0.90, pressDuration: 0.12, glow: 0.40)
        case .tragic: return InteractionSpec(pressScale: 0.92, pressDuration: 0.24, glow: 0.28)
        }
    }

    public var chart: ChartSpec {
        switch self {
        case .bliss: return ChartSpec(line: .orange, phasic: .yellow)
        case .joyfulCalm: return ChartSpec(line: .teal, phasic: .mint)
        case .hopeful: return ChartSpec(line: .green, phasic: .teal)
        case .content: return ChartSpec(line: .blue, phasic: .cyan)
        case .focused: return ChartSpec(line: .indigo, phasic: .blue)
        case .productive: return ChartSpec(line: .green, phasic: .teal)
        case .reflective: return ChartSpec(line: .purple, phasic: .pink)
        case .neutral: return ChartSpec(line: .gray, phasic: .teal)
        case .uneasy: return ChartSpec(line: .orange, phasic: .yellow)
        case .irritated: return ChartSpec(line: .red, phasic: .orange)
        case .angry: return ChartSpec(line: .red, phasic: .orange)
        case .sad: return ChartSpec(line: .blue, phasic: .mint)
        case .sorrowful: return ChartSpec(line: .indigo, phasic: .purple)
        case .grieving: return ChartSpec(line: .indigo, phasic: .gray)
        case .exhausted: return ChartSpec(line: .gray, phasic: .cyan)
        case .melancholic: return ChartSpec(line: .purple, phasic: .pink)
        case .overwhelmed: return ChartSpec(line: .pink, phasic: .orange)
        case .despair: return ChartSpec(line: .purple, phasic: .red)
        case .panic: return ChartSpec(line: .red, phasic: .yellow)
        case .tragic: return ChartSpec(line: .red, phasic: .black)
        }
    }

    public var program: BackgroundProgram {
        switch self {
        case .bliss, .joyfulCalm, .hopeful, .content, .reflective, .melancholic:
            return .aurora
        case .productive, .focused:
            return .bubbles
        case .angry, .irritated:
            return .fire
        case .sad, .sorrowful, .grieving, .exhausted:
            return .rain
        case .uneasy, .despair, .panic, .tragic:
            return .thunder
        case .neutral, .overwhelmed:
            return .stars
        }
    }
}

public enum MoodStateMapper {
    public static func fromAverage(_ avg: Double) -> PersistentMoodState {
        guard !avg.isNaN else { return .neutral }
        switch avg {
        case 95...100: return .bliss
        case 85..<95: return .joyfulCalm
        case 75..<85: return .hopeful
        case 68..<75: return .content
        case 62..<68: return .productive
        case 56..<62: return .focused
        case 50..<56: return .reflective
        case 45..<50: return .neutral
        case 40..<45: return .uneasy
        case 35..<40: return .irritated
        case 30..<35: return .angry
        case 26..<30: return .sad
        case 22..<26: return .sorrowful
        case 18..<22: return .grieving
        case 14..<18: return .exhausted
        case 10..<14: return .melancholic
        case 6..<10: return .overwhelmed
        case 3..<6: return .despair
        case 1..<3: return .panic
        default: return .tragic
        }
    }
}
