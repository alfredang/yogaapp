import SwiftUI

struct SequencesView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(YogaLibrary.sequences) { seq in
                        NavigationLink(value: seq) {
                            SequenceCard(sequence: seq)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
            .background(Theme.background)
            .navigationTitle("Sequences")
            .navigationDestination(for: YogaSequence.self) { SequenceDetailView(sequence: $0) }
        }
        .onAppear {
            if path.isEmpty, let s = ScreenshotNav.sequence { path.append(s) }
        }
    }
}

private struct SequenceCard: View {
    let sequence: YogaSequence

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(LinearGradient(colors: [Theme.primary, Theme.secondary],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: sequence.symbol)
                    .font(.system(size: 26))
                    .foregroundStyle(.white)
            }
            .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 5) {
                Text(sequence.name).font(.headline).foregroundStyle(Theme.ink)
                Text(sequence.subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
                    .lineLimit(1)
                HStack(spacing: 10) {
                    Label("\(sequence.minutes) min", systemImage: "clock.fill")
                    Label("\(sequence.steps.count) poses", systemImage: "figure.yoga")
                    Text(sequence.level.rawValue)
                        .foregroundStyle(sequence.level.color)
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.mutedInk)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard()
    }
}

struct SequenceDetailView: View {
    let sequence: YogaSequence
    @State private var showPlayer = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 14) {
                        Image(systemName: sequence.symbol)
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(LinearGradient(colors: [Theme.primary, Theme.secondary],
                                                       startPoint: .top, endPoint: .bottom),
                                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sequence.name).font(.title2.bold()).foregroundStyle(Theme.ink)
                            Text(sequence.subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
                        }
                    }
                    HStack(spacing: 10) {
                        MetaChip(symbol: "clock.fill", text: "\(sequence.minutes) min", tint: Theme.secondary)
                        MetaChip(symbol: "figure.yoga", text: "\(sequence.steps.count) poses", tint: Theme.primary)
                        MetaChip(symbol: "chart.bar.fill", text: sequence.level.rawValue, tint: sequence.level.color)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()

                Text("Flow").font(.headline).foregroundStyle(Theme.ink)
                    .padding(.horizontal, 4)

                ForEach(Array(sequence.steps.enumerated()), id: \.offset) { idx, step in
                    HStack(spacing: 14) {
                        Text("\(idx + 1)")
                            .font(.subheadline.bold()).foregroundStyle(Theme.mutedInk)
                            .frame(width: 22)
                        PoseBadge(symbol: step.pose.symbol, tint: step.pose.stance.tint, size: 46)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.pose.name).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                            Text(step.pose.sanskrit).font(.caption).italic().foregroundStyle(Theme.mutedInk)
                        }
                        Spacer()
                        Text(formatTime(step.seconds))
                            .font(.subheadline.monospacedDigit().weight(.medium))
                            .foregroundStyle(Theme.primary)
                    }
                    .padding(.vertical, 10).padding(.horizontal, 14)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Theme.surface, lineWidth: 1))
                }
            }
            .padding(18)
            .padding(.bottom, 90)
        }
        .background(Theme.background)
        .navigationTitle(sequence.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                showPlayer = true
            } label: {
                Label("Start Session · \(sequence.minutes) min", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.primary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
            .background(Theme.background.opacity(0.96))
        }
        .fullScreenCover(isPresented: $showPlayer) {
            SessionPlayerView(sequence: sequence)
        }
        .onAppear {
            if ScreenshotNav.openPlayer { showPlayer = true }
        }
    }
}

func formatTime(_ seconds: Int) -> String {
    let m = seconds / 60, s = seconds % 60
    return m > 0 ? String(format: "%d:%02d", m, s) : "\(s)s"
}
