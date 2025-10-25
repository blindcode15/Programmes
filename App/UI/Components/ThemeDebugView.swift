import SwiftUI

struct ThemeDebugView: View {
    @Binding var stateOverride: PersistentMoodState?
    @Binding var colorSchemeOverride: ColorScheme?

    var body: some View {
        NavigationStack {
            Form {
                Section("Long-term state") {
                    Picker("State", selection: Binding(
                        get: { stateOverride ?? .neutral },
                        set: { stateOverride = $0 }
                    )) {
                        ForEach(PersistentMoodState.allCases, id: \.self) { s in
                            Text(s.display).tag(s)
                        }
                    }
                }
                Section("Color Scheme") {
                    Picker("Appearance", selection: Binding(
                        get: { colorSchemeOverride == .dark ? 1 : (colorSchemeOverride == .light ? 0 : 2) },
                        set: { idx in
                            colorSchemeOverride = (idx == 2 ? nil : (idx == 1 ? .dark : .light))
                        }
                    )) {
                        Text("Light").tag(0)
                        Text("Dark").tag(1)
                        Text("System").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                if let s = stateOverride {
                    Text("Selected: \(s.display)")
                }
            }
            .navigationTitle("Theme")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
