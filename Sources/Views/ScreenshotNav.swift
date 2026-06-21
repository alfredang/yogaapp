import SwiftUI

/// Deterministic navigation for App Store screenshot capture, driven by environment
/// variables so screens can be reached without relying on flaky synthetic taps.
/// Harmless in production: every value is nil unless the launch env sets it.
enum ScreenshotNav {
    private static let env = ProcessInfo.processInfo.environment

    /// Initial tab index (0 Poses, 1 Sequences, 2 Feedback, 3 About).
    static var tab: Int? { env["UI_TAB"].flatMap { Int($0) } }

    /// A pose id to push as a detail on the Poses tab.
    static var pose: Pose? { env["UI_POSE"].map { YogaLibrary.pose($0) } }

    /// A sequence id to push as a detail on the Sequences tab.
    static var sequence: YogaSequence? {
        guard let id = env["UI_SEQUENCE"] else { return nil }
        return YogaLibrary.sequences.first { $0.id == id }
    }

    /// Auto-open the session player on the pushed sequence detail.
    static var openPlayer: Bool { env["UI_PLAYER"] == "1" }
}
