import SwiftUI

struct PoseDetailView: View {
    let pose: Pose

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                // Animated figure
                PoseFigure(symbol: pose.symbol, tint: pose.stance.tint, size: 150)
                    .padding(.top, 8)

                VStack(spacing: 4) {
                    Text(pose.name)
                        .font(.title.bold())
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.center)
                    Text(pose.sanskrit)
                        .font(.subheadline).italic()
                        .foregroundStyle(Theme.mutedInk)
                }

                // Meta chips
                HStack(spacing: 10) {
                    MetaChip(symbol: pose.stance.symbol, text: pose.stance.rawValue, tint: pose.stance.tint)
                    MetaChip(symbol: "chart.bar.fill", text: pose.difficulty.rawValue, tint: pose.difficulty.color)
                    MetaChip(symbol: "timer", text: "\(pose.defaultHold)s", tint: Theme.secondary)
                }

                // Focus
                Text(pose.focus)
                    .font(.headline)
                    .foregroundStyle(Theme.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                // Steps
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "How to practice", symbol: "figure.yoga")
                    ForEach(Array(pose.steps.enumerated()), id: \.offset) { idx, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(idx + 1)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                                .background(pose.stance.tint, in: Circle())
                            Text(step)
                                .font(.body)
                                .foregroundStyle(Theme.ink)
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()

                // Benefits
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Benefits", symbol: "heart.fill")
                    ForEach(pose.benefits, id: \.self) { benefit in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.sage)
                            Text(benefit).foregroundStyle(Theme.ink)
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()
            }
            .padding(18)
        }
        .background(Theme.background)
        .navigationTitle(pose.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MetaChip: View {
    let symbol: String
    let text: String
    let tint: Color
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: symbol).font(.caption2)
            Text(text).font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 12).padding(.vertical, 7)
        .foregroundStyle(tint)
        .background(tint.opacity(0.12), in: Capsule())
    }
}

struct SectionHeader: View {
    let title: String
    let symbol: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol).foregroundStyle(Theme.primary)
            Text(title).font(.headline).foregroundStyle(Theme.ink)
        }
    }
}
