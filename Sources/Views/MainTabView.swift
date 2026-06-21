import SwiftUI

struct MainTabView: View {
    @State private var selection = ScreenshotNav.tab ?? 0

    var body: some View {
        TabView(selection: $selection) {
            PosesView()
                .tabItem { Label("Poses", systemImage: "figure.yoga") }
                .tag(0)
            SequencesView()
                .tabItem { Label("Sequences", systemImage: "list.bullet.rectangle.portrait.fill") }
                .tag(1)
            FeedbackView()
                .tabItem { Label("Feedback", systemImage: "bubble.left.and.bubble.right.fill") }
                .tag(2)
            AboutView()
                .tabItem { Label("About", systemImage: "info.circle.fill") }
                .tag(3)
        }
        .tint(Theme.primary)
    }
}
