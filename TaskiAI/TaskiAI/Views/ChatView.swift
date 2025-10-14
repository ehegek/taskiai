import SwiftUI
import SwiftData

struct ChatMessage: Identifiable { let id = UUID(); let text: String; let isUser: Bool }

struct ChatView: View {
    @Environment(\.modelContext) private var context
    @State private var messages: [ChatMessage] = [ChatMessage(text: "What task can I help you with?", isUser: false)]
    @State private var input = ""
    @State private var isRecording = false
    @State private var showAttachLabel = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(messages) { msg in
                                    bubble(for: msg)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        .onChange(of: messages.count) {
                            if let last = messages.last {
                                withAnimation {
                                    proxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    inputBar
                        .padding(.bottom, geo.safeAreaInsets.bottom)
                }
                
                // Header at top
                VStack(spacing: 0) {
                    header
                        .padding(.top, geo.safeAreaInsets.top)
                        .background(Color(.systemBackground))
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .navigationTitle("Taski AI Chat")
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            Spacer()
            Text("Taski AI Chat")
                .font(.system(size: 18, weight: .bold))
            Spacer()
            NavigationLink { VoiceChatView() } label: {
                Image(systemName: "phone.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    @ViewBuilder private func bubble(for msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 0) {
            if msg.isUser { Spacer(minLength: 60) }
            
            if !msg.isUser {
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundStyle(.purple)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.purple.opacity(0.1)))
                    .padding(.trailing, 8)
            }
            
            Text(msg.text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    if msg.isUser {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.blue)
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray6))
                    }
                }
                .foregroundStyle(msg.isUser ? .white : .primary)
            
            if !msg.isUser { Spacer(minLength: 60) }
        }
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            // Attachment chip toggle
            Button { withAnimation { showAttachLabel.toggle() } } label: {
                HStack(spacing: 6) {
                    if showAttachLabel {
                        Text("Add Photo & Files")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemGray6)))
            }

            HStack(spacing: 8) {
                TextField("Task me anything...", text: $input)
                    .font(.system(size: 16))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                Button { toggleMic() } label: {
                    Image(systemName: isRecording ? "mic.circle.fill" : "mic")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isRecording ? .red : .secondary)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemGray6))
            )

            Button { send() } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(input.isEmpty ? Color.secondary : Color.black)
            }
            .disabled(input.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
        )
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

