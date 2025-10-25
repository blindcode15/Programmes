import SwiftUI

/// Root view with tabs: Home, History, Charts, Tips
struct ContentView: View {
    @EnvironmentObject private var store: MoodStore
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var moodVM = MoodViewModel()
    @StateObject private var chartsVM = ChartsViewModel()
    @State private var showFineTune = false
    @State private var selectedTab: Int = 0
    private var palette: ThemePalette {
        let avg = AnalyticsEngine(entries: store.entries).avg(period: .week)
        let safe = avg.isNaN ? 50.0 : avg
        return ThemePalette.forMood(safe, scheme: colorScheme)
    }

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
        .sheet(isPresented: $showFineTune) {
            FineTuneSheet(isPresented: $showFineTune)
                .presentationDetents([.fraction(0.4), .medium])
                .presentationCornerRadius(16)
        }
        .tint(palette.accent)
        .task {
            if store.consumeFineTuneFlag() { showFineTune = true }
            _ = await NotificationHelper.requestAuthorization()
        }
        .onChange(of: selectedTab) { _ in Haptics.fire(.light) }
    }
}

#Preview { ContentView().environmentObject(MoodStore.shared) }