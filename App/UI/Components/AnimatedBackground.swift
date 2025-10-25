import SwiftUI

struct AnimatedBackground: View {
    let palette: ThemePalette
    @Environment(\.persistentMoodState) private var moodState

    var body: some View {
        ZStack {
            switch moodState.program {
            case .aurora:
                AuroraBackground(color: palette.accent, opacity: moodState.background.opacity, speed: moodState.background.speed)
            case .bubbles:
                BubblesBackground(color: palette.accent.opacity(0.9), opacity: moodState.background.opacity, speed: moodState.background.speed)
            case .fire:
                FireBackground(color: palette.accent, opacity: moodState.background.opacity)
            case .rain:
                RainBackground(color: palette.accent, opacity: moodState.background.opacity)
            case .thunder:
                ThunderBackground(color: palette.accent, opacity: moodState.background.opacity)
            case .stars:
                StarsBackground(color: palette.accent.opacity(0.9), opacity: moodState.background.opacity)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Programs
private struct AuroraBackground: View {
    let color: Color
    let opacity: Double
    let speed: Double
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                let y = size.height * 0.25 + sin(t * speed * 0.8) * 24
                var path = Path()
                path.move(to: .init(x: 0, y: y))
                stride(from: 0.0, through: size.width, by: 16).forEach { x in
                    let yy = y + sin((t * speed * 1.2) + x * 0.02) * 20 + sin((t * speed * 0.7) + x * 0.04) * 14
                    path.addLine(to: .init(x: x, y: yy))
                }
                path.addLine(to: .init(x: size.width, y: 0))
                path.addLine(to: .init(x: 0, y: 0))
                path.closeSubpath()
                ctx.fill(path, with: .linearGradient(Gradient(colors: [color.opacity(0.06), color.opacity(0.18), color.opacity(0.06)]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))
            }
            .opacity(opacity)
            .blendMode(.plusLighter)
        }
    }
}

private struct BubblesBackground: View {
    let color: Color
    let opacity: Double
    let speed: Double
    @State private var seeds: [Double] = (0..<28).map { _ in Double.random(in: 0...1) }
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                for (i, s) in seeds.enumerated() {
                    let x = (s * size.width).truncatingRemainder(dividingBy: size.width)
                    let y = (size.height - fmod((t * (speed * 40 + 40) + s * 800), size.height + 40))
                    let r = CGFloat(6 + (Double(i).truncatingRemainder(dividingBy: 6)))
                    let rect = CGRect(x: x, y: y, width: r, height: r)
                    ctx.fill(Path(ellipseIn: rect), with: .color(color.opacity(0.22)))
                }
            }
            .opacity(opacity)
        }
    }
}

private struct FireBackground: View {
    let color: Color
    let opacity: Double
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            LinearGradient(colors: [.clear, color.opacity(0.18), color.opacity(0.08)], startPoint: .center, endPoint: .bottom)
                .offset(y: CGFloat(sin(t * 2.2) * 6))
                .opacity(opacity)
                .blendMode(.plusLighter)
        }
    }
}

private struct RainBackground: View {
    let color: Color
    let opacity: Double
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                ctx.stroke(Path { p in
                    for i in stride(from: 0.0, through: size.width, by: 12) {
                        let y = fmod(t * 220 + i * 7, size.height + 20) - 20
                        p.move(to: .init(x: i, y: y))
                        p.addLine(to: .init(x: i + 6, y: y + 14))
                    }
                }, with: .color(color.opacity(0.18)), lineWidth: 1.2)
            }
            .opacity(opacity)
        }
    }
}

private struct ThunderBackground: View {
    let color: Color
    let opacity: Double
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                RainBackground(color: color, opacity: opacity)
                Rectangle()
                    .fill(Color.white.opacity(((Int(t) % 5 == 0) && (t.truncatingRemainder(dividingBy: 5) < 0.1)) ? 0.08 : 0))
            }
        }
    }
}

private struct StarsBackground: View {
    let color: Color
    let opacity: Double
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                for i in 0..<140 {
                    let x = fmod(Double(i) * 11.0 + t * 20.0, Double(size.width))
                    let y = fmod(Double(i) * 7.0, Double(size.height))
                    let r = CGFloat(0.6 + (i % 5 == 0 ? 1.2 : 0.3))
                    let rect = CGRect(x: x, y: y, width: r, height: r)
                    ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.6)))
                }
            }
            .overlay(
                AuroraBackground(color: color, opacity: opacity * 0.9, speed: 0.6)
            )
            .opacity(opacity)
        }
    }
}
