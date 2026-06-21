import SwiftUI

/// Animated representation of a yoga stance: an SF Symbol figure inside a soft
/// "breathing" halo. The halo scales gently in and out to suggest calm breath.
struct PoseFigure: View {
    let symbol: String
    var tint: Color = Theme.primary
    var size: CGFloat = 120
    var animated: Bool = true

    @State private var breatheIn = false

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(0.12))
                .frame(width: size, height: size)
                .scaleEffect(breatheIn ? 1.0 : 0.82)

            Circle()
                .stroke(tint.opacity(0.25), lineWidth: 2)
                .frame(width: size * 0.92, height: size * 0.92)
                .scaleEffect(breatheIn ? 1.04 : 0.9)

            Image(systemName: symbol)
                .font(.system(size: size * 0.42, weight: .regular))
                .foregroundStyle(tint)
                .symbolRenderingMode(.hierarchical)
        }
        .onAppear {
            guard animated else { return }
            withAnimation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true)) {
                breatheIn = true
            }
        }
        .accessibilityHidden(true)
    }
}

/// Small fixed badge version used in list rows / chips.
struct PoseBadge: View {
    let symbol: String
    var tint: Color = Theme.primary
    var size: CGFloat = 52

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size * 0.42, weight: .regular))
            .foregroundStyle(tint)
            .symbolRenderingMode(.hierarchical)
            .frame(width: size, height: size)
            .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .accessibilityHidden(true)
    }
}
