import SwiftUI

struct PosesView: View {
    @State private var query = ""
    @State private var selectedStance: Stance?
    @State private var path = NavigationPath()

    private var filtered: [Pose] {
        YogaLibrary.poses.filter { pose in
            (selectedStance == nil || pose.stance == selectedStance)
            && (query.isEmpty
                || pose.name.localizedCaseInsensitiveContains(query)
                || pose.sanskrit.localizedCaseInsensitiveContains(query))
        }
    }

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Stance filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            StanceChip(title: "All", symbol: "square.grid.2x2.fill",
                                       tint: Theme.primary, selected: selectedStance == nil) {
                                selectedStance = nil
                            }
                            ForEach(Stance.allCases) { stance in
                                StanceChip(title: stance.rawValue, symbol: stance.symbol,
                                           tint: stance.tint, selected: selectedStance == stance) {
                                    selectedStance = (selectedStance == stance) ? nil : stance
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                    }

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(filtered) { pose in
                            NavigationLink(value: pose) {
                                PoseCard(pose: pose)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .background(Theme.background)
            .navigationTitle("Poses")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $query, prompt: "Search poses")
            .navigationDestination(for: Pose.self) { PoseDetailView(pose: $0) }
        }
        .onAppear {
            if path.isEmpty, let p = ScreenshotNav.pose { path.append(p) }
        }
    }
}

private struct StanceChip: View {
    let title: String
    let symbol: String
    let tint: Color
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: symbol).font(.caption)
                Text(title).font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 14).padding(.vertical, 9)
            .foregroundStyle(selected ? .white : Theme.ink)
            .background(selected ? tint : Theme.surface,
                        in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct PoseCard: View {
    let pose: Pose

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                PoseBadge(symbol: pose.symbol, tint: pose.stance.tint)
                Spacer()
                DifficultyPips(difficulty: pose.difficulty)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(pose.name)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                Text(pose.sanskrit)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(Theme.mutedInk)
                    .lineLimit(1)
            }
            HStack(spacing: 6) {
                Image(systemName: pose.stance.symbol).font(.caption2)
                Text(pose.stance.rawValue).font(.caption2.weight(.medium))
            }
            .foregroundStyle(pose.stance.tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
}

struct DifficultyPips: View {
    let difficulty: Difficulty
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(i < difficulty.pips ? difficulty.color : Theme.surface)
                    .frame(width: 6, height: 6)
            }
        }
        .accessibilityLabel(difficulty.rawValue)
    }
}
