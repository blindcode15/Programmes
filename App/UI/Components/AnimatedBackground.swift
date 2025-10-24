import SwiftUI

struct AnimatedBackground: View {
    let palette: ThemePalette
    @State private var angle: Angle = .degrees(0)

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let deg = (sin(t / 6) + 1) * 90 // 0..180
            Rectangle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: [palette.accent, palette.glow]),
                        center: .center,
                        angle: .degrees(deg)
                    )
                )
                .opacity(0.12)
                .ignoresSafeArea()
        }
    }
}
