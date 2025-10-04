import SwiftUI
import SwiftData

struct ChatMessage: Identifiable { let id = UUID(); let text: String; let isUser: Bool }

struct ChatView: View {
    @Environment(\.modelContext) private var context
    @State private var messages: [ChatMessage] = [ChatMessage(text: "What task can I help you with?", isUser: false)]
    @State private var input = ""
    @State private var isRecording = false

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView { LazyVStack(alignment: .leading, spacing: 12) { ForEach(messages) { msg in bubble(for: msg) } } }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } }
                    }
            }
            inputBar
        }
        .padding()
        .navigationTitle("Taski AI Chat")
    }

    @ViewBuilder private func bubble(for msg: ChatMessage) -> some View {
        HStack { if msg.isUser { Spacer() }
            Text(msg.text).padding(12)
                .background(
                    (msg.isUser ? Color.blue.opacity(0.2) : Color.clear)
                        .background(msg.isUser ? Color.clear : .ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
            if !msg.isUser { Spacer() }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 8) {
            Button { /* add attachment */ } label: { Image(systemName: "paperclip") }
            TextField("Task me anything...", text: $input)
                .textFieldStyle(.roundedBorder)
            Button { toggleMic() } label: { Image(systemName: isRecording ? "mic.circle.fill" : "mic") }
            Button { send() } label: { Image(systemName: "paperplane.fill") }
        }
    }

    private func toggleMic() {
        isRecording.toggle()
        // Wire to SpeechService later
    }

    private func send() {
        guard !input.isEmpty else { return }
        messages.append(ChatMessage(text: input, isUser: true))
        // Very naive intent: if message contains 'add' and 'task', create a task titled by the message
        if input.lowercased().contains("add") && input.lowercased().contains("task") {
            let t = Task(title: input.replacingOccurrences(of: "add", with: "").replacingOccurrences(of: "task", with: "").trimmingCharacters(in: .whitespacesAndNewlines), date: .now)
            context.insert(t)
            try? context.save()
            messages.append(ChatMessage(text: "Added a new task.", isUser: false))
        } else if input.lowercased().contains("delete") {
            // naive delete last task
            if let last = try? context.fetch(FetchDescriptor<Task>(sortBy: [SortDescriptor(\.date, order: .reverse)])).first {
                context.delete(last)
                try? context.save()
                messages.append(ChatMessage(text: "Deleted the most recent task.", isUser: false))
            } else {
                messages.append(ChatMessage(text: "I couldn't find a task to delete.", isUser: false))
            }
        } else {
            messages.append(ChatMessage(text: "Got it.", isUser: false))
        }
        input = ""
    }
}
