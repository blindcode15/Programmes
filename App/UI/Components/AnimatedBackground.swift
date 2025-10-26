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

// Lightweight seeded RNG to keep Canvas deterministic within a frame
private struct SeededRandom: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed &* 0x9E3779B97F4A7C15 }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
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
                // Falling streaks
                ctx.stroke(Path { p in
                    for i in stride(from: 0.0, through: size.width, by: 12) {
                        let y = fmod(t * 220 + i * 7, size.height + 20) - 20
                        p.move(to: .init(x: i, y: y))
                        p.addLine(to: .init(x: i + 6, y: y + 14))
                    }
                }, with: .color(color.opacity(0.18)), lineWidth: 1.2)

                // Subtle ripples near bottom surface
                var rng = SeededRandom(seed: 42)
                for k in 0..<8 {
                    let phase = (t * 0.9 + Double(k) * 0.73)
                    let u = Double.random(in: 0...1, using: &rng)
                    let x = CGFloat(u) * size.width
                    let baseY = size.height - 6
                    // animate periodic ripples
                    let prog = (sin(phase) + 1) / 2 // 0..1
                    let r = CGFloat(8 + prog * 10)
                    let alpha = 0.10 * (1 - prog)
                    let rect = CGRect(x: x - r, y: baseY - r/2, width: r * 2, height: r)
                    ctx.stroke(Path(ellipseIn: rect), with: .color(color.opacity(alpha)), lineWidth: 1)
                }
            }
            .opacity(opacity)
        }
    }
}

private struct ThunderBackground: View {
    let color: Color
    let opacity: Double
    @State private var flashSeed: Int = 0
    @State private var nextFlash: TimeInterval = 0
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                // Base rain
                RainBackground(color: color, opacity: opacity)

                // Lightning pass
                Canvas { ctx, size in
                    // decide if we should flash
                    var rng = SeededRandom(seed: UInt64(flashSeed))
                    if nextFlash == 0 || t > nextFlash {
                        // schedule next flash 2.5..6.5s later
                        nextFlash = t + Double.random(in: 2.5...6.5, using: &rng)
                        flashSeed = Int.random(in: 0...Int.max)
                    }
                    let timeToFlash = max(0, nextFlash - t)
                    let flashing = timeToFlash < 0.22 // brief window
                    if flashing {
                        let strikes = 1 + Int.random(in: 0...1, using: &rng)
                        for _ in 0..<strikes {
                            let startX = Double.random(in: size.width*0.2...size.width*0.8, using: &rng)
                            var path = Path()
                            var x = startX
                            var y: Double = 0
                            path.move(to: CGPoint(x: x, y: y))
                            let segments = Int.random(in: 8...14, using: &rng)
                            for _ in 0..<segments {
                                x += Double.random(in: -14...14, using: &rng)
                                y += Double.random(in: 20...44, using: &rng)
                                path.addLine(to: CGPoint(x: x, y: y))
                                // occasional branch
                                if Bool.random(using: &rng) && Int.random(in: 0...3, using: &rng) == 0 {
                                    var bx = x
                                    var by = y
                                    var b = Path()
                                    b.move(to: CGPoint(x: bx, y: by))
                                    for _ in 0..<Int.random(in: 3...5, using: &rng) {
                                        bx += Double.random(in: -10...10, using: &rng)
                                        by += Double.random(in: 12...24, using: &rng)
                                        b.addLine(to: CGPoint(x: bx, y: by))
                                    }
                                    ctx.stroke(b, with: .color(Color.white.opacity(0.35)), lineWidth: 1)
                                }
                            }
                            // main bolt with glow
                            ctx.stroke(path, with: .color(Color.white.opacity(0.9)), lineWidth: 2)
                            ctx.stroke(path, with: .color(color.opacity(0.35)), lineWidth: 6)
                        }
                    }
                }
                .blendMode(.plusLighter)

                // Global flash glow
                Rectangle()
                    .fill(Color.white.opacity(((nextFlash - t) < 0.18 && (nextFlash - t) > 0) ? 0.10 : 0))
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
