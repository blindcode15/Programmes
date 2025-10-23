import SwiftUI
import Charts

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

            Chart(vm.series()) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Value", $0.value)
                )
                PointMark(
                    x: .value("Date", $0.date),
                    y: .value("Value", $0.value)
                )
            }
            .frame(height: 220)
            .chartYScale(domain: 0...10)

            // Heatmap stub (can be extended)
            Text("Heatmap by hour")
                import SwiftUI
                #if canImport(Charts)
                import Charts

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

                            Chart(vm.series()) {
                                LineMark(
                                    x: .value("Date", $0.date),
                                    y: .value("Value", $0.value)
                                )
                                PointMark(
                                    x: .value("Date", $0.date),
                                    y: .value("Value", $0.value)
                                )
                            }
                            .frame(height: 220)
                            .chartYScale(domain: 0...10)

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
