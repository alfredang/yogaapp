import SwiftUI

@main
struct YogaApp: App {
    init() {
        // Keep navigation bars on the clean white background.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Theme.background)
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(Theme.primary)
                .preferredColorScheme(.light)   // ZenAsana is a white-theme app
        }
    }
}
