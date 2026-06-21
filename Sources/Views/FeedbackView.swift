import SwiftUI

struct FeedbackView: View {
    private let whatsAppNumber = "6588666375"   // +65 8866 6375, no "+"/spaces
    @State private var title = ""
    @State private var message = ""

    private var canSend: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("We'd love your feedback on your practice experience.")
                        .font(.subheadline).foregroundStyle(Theme.mutedInk)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("TITLE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        TextField("Title", text: $title)
                            .padding(14)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Theme.surface, lineWidth: 1))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("MESSAGE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Your message…").foregroundStyle(Theme.mutedInk).padding(18)
                            }
                            TextEditor(text: $message)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 160)
                                .padding(8)
                        }
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Theme.surface, lineWidth: 1))
                    }

                    Button(action: send) {
                        Label("Send via WhatsApp", systemImage: "paperplane.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(canSend ? Theme.primary : Theme.mutedInk.opacity(0.4),
                                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .foregroundStyle(.white)
                    }
                    .disabled(!canSend)
                }
                .padding(18)
            }
            .background(Theme.background)
            .navigationTitle("Feedback")
        }
    }

    private func send() {
        var text = ""
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let m = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if !t.isEmpty { text += "*\(t)*\n" }
        text += m
        var comps = URLComponents()
        comps.scheme = "https"; comps.host = "wa.me"; comps.path = "/\(whatsAppNumber)"
        comps.queryItems = [URLQueryItem(name: "text", value: text)]
        if let url = comps.url { UIApplication.shared.open(url) }
    }
}
