import SwiftUI

/// Root view with tabs: Home, History, Charts, Tips
struct ContentView: View {
    @EnvironmentObject private var store: MoodStore
    @StateObject private var moodVM = MoodViewModel()
    @StateObject private var chartsVM = ChartsViewModel()
    @State private var showFineTune = false

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(showFineTune: $showFineTune)
                    .navigationTitle(LocalizedStringKey("APP_TITLE"))
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { HistoryView() }
                .tabItem { Label("History", systemImage: "clock.fill") }

            NavigationStack { ChartsView() }
                .tabItem { Label("Charts", systemImage: "chart.xyaxis.line") }

            NavigationStack { TipsView() }
                .tabItem { Label("Tips", systemImage: "lightbulb.fill") }
        }
        .environmentObject(moodVM)
        .environmentObject(chartsVM)
        .sheet(isPresented: $showFineTune) {
            FineTuneSheet(isPresented: $showFineTune)
                .presentationDetents([.fraction(0.4), .medium])
                .presentationCornerRadius(16)
        }
        .task {
            if store.consumeFineTuneFlag() { showFineTune = true }
            _ = await NotificationHelper.requestAuthorization()
        }
    }
}

#Preview { ContentView().environmentObject(MoodStore.shared) }