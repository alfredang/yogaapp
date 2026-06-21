import SwiftUI

/// Guided session player: steps through each pose with a countdown timer, an
/// animated progress ring, and the breathing PoseFigure animation.
struct SessionPlayerView: View {
    let sequence: YogaSequence
    @Environment(\.dismiss) private var dismiss

    @State private var stepIndex = 0
    @State private var remaining = 0
    @State private var running = true
    @State private var finished = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var step: SequenceStep { sequence.steps[min(stepIndex, sequence.steps.count - 1)] }
    private var pose: Pose { step.pose }
    private var progress: Double {
        step.seconds == 0 ? 0 : 1 - Double(remaining) / Double(step.seconds)
    }
    private var overallProgress: Double {
        Double(stepIndex) / Double(sequence.steps.count)
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            if finished {
                completionView
            } else {
                sessionView
            }
        }
        .onAppear { remaining = step.seconds }
        .onReceive(timer) { _ in tick() }
    }

    // MARK: Session

    private var sessionView: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark").font(.headline).foregroundStyle(Theme.mutedInk)
                        .frame(width: 40, height: 40)
                        .background(Theme.surface, in: Circle())
                }
                Spacer()
                Text(sequence.name).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                Spacer()
                Text("\(stepIndex + 1)/\(sequence.steps.count)")
                    .font(.subheadline.weight(.medium).monospacedDigit())
                    .foregroundStyle(Theme.mutedInk)
                    .frame(width: 40)
            }
            .padding(.horizontal, 18).padding(.top, 10)

            // Overall progress
            ProgressView(value: overallProgress)
                .tint(Theme.primary)
                .padding(.horizontal, 18).padding(.top, 12)

            Spacer()

            // Timer ring with breathing figure
            ZStack {
                Circle()
                    .stroke(Theme.surface, lineWidth: 14)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(pose.stance.tint, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)

                VStack(spacing: 14) {
                    PoseFigure(symbol: pose.symbol, tint: pose.stance.tint, size: 130)
                    Text(formatTime(remaining))
                        .font(.system(size: 46, weight: .bold, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.ink)
                        .contentTransition(.numericText())
                }
            }
            .frame(width: 300, height: 300)

            Spacer()

            // Pose info
            VStack(spacing: 6) {
                Text(pose.name).font(.title2.bold()).foregroundStyle(Theme.ink)
                Text(pose.sanskrit).font(.subheadline).italic().foregroundStyle(Theme.mutedInk)
                Text(pose.focus).font(.subheadline).foregroundStyle(pose.stance.tint).padding(.top, 2)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)

            // Next-up
            if stepIndex + 1 < sequence.steps.count {
                let next = sequence.steps[stepIndex + 1].pose
                HStack(spacing: 8) {
                    Text("Next").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                    Image(systemName: next.symbol).font(.caption).foregroundStyle(next.stance.tint)
                    Text(next.name).font(.caption.weight(.medium)).foregroundStyle(Theme.ink)
                }
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Theme.surface, in: Capsule())
                .padding(.top, 14)
            }

            Spacer()

            // Controls
            HStack(spacing: 28) {
                ControlButton(symbol: "backward.fill", disabled: stepIndex == 0) { previous() }
                Button { running.toggle() } label: {
                    Image(systemName: running ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                        .frame(width: 76, height: 76)
                        .background(Theme.primary, in: Circle())
                }
                ControlButton(symbol: "forward.fill", disabled: false) { advance(skip: true) }
            }
            .padding(.bottom, 30)
        }
    }

    // MARK: Completion

    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()
            PoseFigure(symbol: "checkmark.seal.fill", tint: Theme.sage, size: 150)
            Text("Session complete").font(.title.bold()).foregroundStyle(Theme.ink)
            Text("You practiced \(sequence.steps.count) poses in \(sequence.minutes) minutes. Take a breath and notice how you feel.")
                .font(.body).foregroundStyle(Theme.mutedInk)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Spacer()
            Button { dismiss() } label: {
                Text("Done").font(.headline).frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Theme.primary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24).padding(.bottom, 30)
        }
    }

    // MARK: Logic

    private func tick() {
        guard running, !finished else { return }
        if remaining > 1 {
            remaining -= 1
        } else {
            advance(skip: false)
        }
    }

    private func advance(skip: Bool) {
        if stepIndex + 1 < sequence.steps.count {
            stepIndex += 1
            remaining = step.seconds
        } else {
            withAnimation { finished = true }
        }
    }

    private func previous() {
        guard stepIndex > 0 else { return }
        stepIndex -= 1
        remaining = step.seconds
    }
}

private struct ControlButton: View {
    let symbol: String
    let disabled: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 22))
                .foregroundStyle(disabled ? Theme.mutedInk.opacity(0.4) : Theme.ink)
                .frame(width: 60, height: 60)
                .background(Theme.surface, in: Circle())
        }
        .disabled(disabled)
    }
}
