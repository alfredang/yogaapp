import SwiftUI

struct AboutView: View {
    private let developerURL = URL(string: "https://www.tertiaryinfotech.com")!

    private var versionString: String {
        let i = Bundle.main.infoDictionary
        let s = i?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = i?["CFBundleVersion"] as? String ?? "1"
        return "\(s) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App card
                    VStack(alignment: .center, spacing: 14) {
                        PoseFigure(symbol: "figure.yoga", tint: Theme.primary, size: 96, animated: false)
                        Text("ZenAsana").font(.title2.bold()).foregroundStyle(Theme.ink)
                        Text("Learn essential yoga poses with clear guidance and flow through timed sequences for every part of your day — all in a calm, distraction-free space.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .appCard(padding: 22)

                    // Developer card
                    VStack(alignment: .leading, spacing: 0) {
                        Text("DEVELOPER").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                            .padding(.bottom, 6)
                        Label("Tertiary Infotech Academy Pte Ltd", systemImage: "building.2.fill")
                            .foregroundStyle(Theme.ink)
                            .padding(.vertical, 14)
                        Divider()
                        Link(destination: developerURL) {
                            Label("tertiaryinfotech.com", systemImage: "globe")
                                .foregroundStyle(Theme.primary)
                        }
                        .padding(.vertical, 14)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Practice safely card
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Practice safely", systemImage: "heart.text.square.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.primary)
                        Text("ZenAsana is for general wellness and education. Move within your limits, never force a pose, and consult a healthcare professional before starting if you have any injury or medical condition.")
                            .font(.footnote).foregroundStyle(Theme.mutedInk)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Version row
                    HStack {
                        Text("Version").foregroundStyle(Theme.ink)
                        Spacer()
                        Text(versionString).foregroundStyle(Theme.mutedInk)
                    }
                    .padding(.horizontal, 4)
                }
                .padding(18)
            }
            .background(Theme.background)
            .navigationTitle("About")
        }
    }
}
