import SwiftUI

/// Single source of truth for the ZenAsana palette — a clean, calm **white theme**.
/// Reference these tokens everywhere; never hardcode raw Color literals in views.
enum Theme {
    // Brand accent — a calm sage/teal green that reads well on white.
    static let primary   = Color(hex: 0x2E7D6B)   // deep sage-teal (buttons, active states)
    static let secondary = Color(hex: 0x4DA38C)   // lighter teal (links, selected tabs)
    static let highlight = Color(hex: 0xE0A458)   // warm amber (badges, ratings)

    // Surfaces — white background with subtle off-white cards.
    static let background = Color(hex: 0xFBFCFB)   // near-white app background
    static let surface    = Color(hex: 0xF1F4F2)   // chips / subtle fills
    static let card       = Color.white            // elevated card surface

    // Text
    static let ink      = Color(hex: 0x1E2A26)     // primary text (AA on white)
    static let mutedInk = Color(hex: 0x6B7B75)     // secondary text

    // Stance accent palette
    static let sage  = Color(hex: 0x5FA37E)
    static let clay  = Color(hex: 0xC07B53)
    static let sky   = Color(hex: 0x5B8DB8)
    static let coral = Color(hex: 0xD46A6A)
    static let amber = Color(hex: 0xD99A3E)
    static let plum  = Color(hex: 0x8E6BA8)
    static let teal  = Color(hex: 0x3FA09B)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue:  Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

// MARK: - Reusable card surface

private struct AppCard: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Theme.surface, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

extension View {
    /// White / elevated surface with a soft shadow — reuse for every card.
    func appCard(padding: CGFloat = 16) -> some View {
        modifier(AppCard(padding: padding))
    }
}
