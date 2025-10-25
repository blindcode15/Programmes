import SwiftUI

struct AnimatedBackground: View {
    let palette: ThemePalette
    @Environment(\.persistentMoodState) private var moodState
    @State private var angle: Angle = .degrees(0)

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let deg = (sin(t / max(2.0, moodState.background.speed * 5)) + 1) * 90 // 0..180
            ZStack {
                Rectangle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [palette.accent, palette.glow]),
                            center: .center,
                            angle: .degrees(deg)
                        )
                    )
                    .opacity(moodState.background.opacity)
                if moodState.background.swirl {
                    RadialGradient(gradient: Gradient(colors: [palette.accent.opacity(0.25), .clear]), center: .center, startRadius: 20, endRadius: 240)
                        .blendMode(.plusLighter)
                        .opacity(0.5)
                        .scaleEffect(1.0 + 0.03 * sin(t / 2.0))
                }
            }
            .ignoresSafeArea()
        }
    }
}
