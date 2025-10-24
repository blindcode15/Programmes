import SwiftUI
#if canImport(Charts)
import Charts
#endif

#if canImport(Charts)
struct ChartsView: View {
    @EnvironmentObject private var store: MoodStore
    @EnvironmentObject private var vm: ChartsViewModel

    var body: some View {
        VStack(spacing: 12) {
            Picker("Range", selection: $vm.selected) {
                ForEach(ChartsViewModel.Range.allCases, id: \.self) { r in
                    Text(r.rawValue).tag(r)
                }
            }
            .pickerStyle(.segmented)

            HStack(spacing: 8) {
                StatPill(title: "Avg", value: vm.avg.isNaN ? "–" : String(format: "%.1f", vm.avg))
                StatPill(title: "Median", value: vm.median.isNaN ? "–" : String(format: "%.1f", vm.median))
                StatPill(title: "Min", value: "\(vm.minValue)")
                StatPill(title: "Max", value: "\(vm.maxValue)")
            }

            Chart(vm.series()) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Value", entry.value)
                )
                PointMark(
                    x: .value("Date", entry.date),
                    y: .value("Value", entry.value)
                )
            }
            .frame(height: 220)
            .chartYScale(domain: 0...100)

            Text("Heatmap by hour")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            HeatmapView(entries: store.entries)
                .frame(height: 180)
        }
        .padding()
    }
}
#else
// Fallback when Charts framework is unavailable (defensive for CI/toolchains)
struct ChartsView: View {
    @EnvironmentObject private var store: MoodStore
    @EnvironmentObject private var vm: ChartsViewModel
    var body: some View {
        VStack(spacing: 12) {
            Picker("Range", selection: $vm.selected) {
                ForEach(ChartsViewModel.Range.allCases, id: \.self) { r in
                    Text(r.rawValue).tag(r)
                }
            }
            .pickerStyle(.segmented)

            Text("Charts framework is not available in this environment.")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Heatmap by hour")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            HeatmapView(entries: store.entries)
                .frame(height: 180)
        }
        .padding()
    }
}
#endif

// Simple 7x24 heatmap using entry counts per hour for the last 7 days
struct HeatmapView: View {
    let entries: [MoodEntry]

    private func opacity(for count: Int) -> Double {
        // Base 0.08 so empty cells are still visible, ramp by 0.22 per entry up to 1.0
        min(0.08 + Double(count) * 0.22, 1.0)
    }

    var body: some View {
        let map = AnalyticsEngine(entries: entries).hourlyHeatmap()
        VStack(alignment: .leading, spacing: 4) {
            ForEach((-6)...0, id: \.self) { dayOffset in
                HStack(spacing: 2) {
                    ForEach(0..<24, id: \.self) { hour in
                        let count = map[dayOffset]?[hour]?.count ?? 0
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(Color.accentColor.opacity(opacity(for: count)))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
    }
}
