import SwiftUI

/// Root view with tabs: Home, History, Charts, Tips
struct ContentView: View {
    @EnvironmentObject private var store: MoodStore
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var moodVM = MoodViewModel()
    @StateObject private var chartsVM = ChartsViewModel()
    @State private var showFineTune = false
    @State private var selectedTab: Int = 0
    @State private var showThemeDebug = false
    @State private var debugStateOverride: PersistentMoodState? = nil
    @State private var debugColorScheme: ColorScheme? = nil
    private var palette: ThemePalette {
        let avg = AnalyticsEngine(entries: store.entries).avg(period: .week)
        let safe = avg.isNaN ? 50.0 : avg
        if let ov = debugStateOverride {
            return ThemePalette.fromState(ov, scheme: debugColorScheme ?? colorScheme)
        }
        return ThemePalette.forMood(safe, scheme: debugColorScheme ?? colorScheme)
    }
    @State private var demoTimer: Timer?
    private let isDemo = ProcessInfo.processInfo.arguments.contains("DEMO_MODE")

    var body: some View {
        ZStack {
            AnimatedBackground(palette: palette)
            TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(showFineTune: $showFineTune)
                    .navigationTitle(LocalizedStringKey("APP_TITLE"))
                }
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

                NavigationStack { ChartsView() }
                    .tabItem { Label("Charts", systemImage: "chart.xyaxis.line") }
                    .tag(1)

                NavigationStack { TipsView() }
                    .tabItem { Label("Tips", systemImage: "lightbulb.fill") }
                    .tag(2)
            }
            .animation(.easeInOut(duration: 0.25), value: selectedTab)
        }
        .environmentObject(moodVM)
        .environmentObject(chartsVM)
        .environment(\.themePalette, palette)
        .environment(\.persistentMoodState, palette.state)
        .sheet(isPresented: $showFineTune) {
            FineTuneSheet(isPresented: $showFineTune)
                .presentationDetents([.fraction(0.4), .medium])
                .modifier(PresentationCornerRadiusIfAvailable(radius: 16))
        }
        .sheet(isPresented: $showThemeDebug) {
            ThemeDebugView(stateOverride: $debugStateOverride, colorSchemeOverride: $debugColorScheme)
                .presentationDetents([.fraction(0.4), .medium])
                .modifier(PresentationCornerRadiusIfAvailable(radius: 16))
        }
        .tint(palette.accent)
        .preferredColorScheme(debugColorScheme)
        .toolbar {
            if isDemo {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Theme") { showThemeDebug = true }
                }
            }
        }
        .task {
            if store.consumeFineTuneFlag() { showFineTune = true }
            _ = await NotificationHelper.requestAuthorization()
            // DEMO: when launched with argument "DEMO_MODE", seed some entries and auto-rotate tabs for video
            if ProcessInfo.processInfo.arguments.contains("DEMO_MODE") {
                if store.entries.isEmpty {
                    seedDemoEntries()
                }
                demoTimer?.invalidate()
                var step = 0
                demoTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                    selectedTab = step % 3
                    // also inject a visible change: add a small random entry to animate charts
                    let base = Int.random(in: 20...85)
                    let jitter = Int.random(in: -12...12)
                    let val = max(0, min(100, base + jitter))
                    let emos: [Emotion] = [.joy, .anxiety, .anger, .sadness]
                    let emo = emos.randomElement()
                    MoodStore.shared.append(value: val, note: nil, emotion: emo)
                    // flip theme override occasionally to show different visuals
                    if step % 2 == 0 {
                        debugStateOverride = PersistentMoodState.allCases.randomElement()
                    }
                    step += 1
                }
            }
        }
        .onChange(of: selectedTab) { _ in Haptics.fire(.light) }
    }
}

// MARK: - Conditional corner radius for sheet (older toolchains)
private struct PresentationCornerRadiusIfAvailable: ViewModifier {
    let radius: CGFloat
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationCornerRadius(radius)
        } else {
            content
        }
    }
}

private extension ContentView {
    func seedDemoEntries() {
        var items: [MoodEntry] = []
        let cal = Calendar.current
        let now = Date()
        for i in 0..<14 {
            let day = cal.date(byAdding: .day, value: -i, to: now)!
            for h in [9, 14, 21] {
                var comps = cal.dateComponents([.year,.month,.day], from: day)
                comps.hour = h
                let d = cal.date(from: comps) ?? day
                let base = 55 + Int(25 * sin(Double(i)/3.5))
                let val = max(0, min(100, base + Int.random(in: -10...10)))
                let emotion: Emotion = (val >= 70) ? .joy : (val >= 50 ? .anxiety : (val >= 35 ? .anger : .sadness))
                items.append(MoodEntry(date: d, value: val, note: nil, emotion: emotion))
            }
        }
        MoodStore.shared.setEntries(items)
    }
}
// Preview removed for CI stability