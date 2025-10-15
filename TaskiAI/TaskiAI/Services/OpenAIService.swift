import Foundation
import SwiftData

struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
    
    struct ChatMessage: Codable {
        let role: String
        let content: String
    }
}

struct ChatCompletionResponse: Codable {
    let id: String
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
        }
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
}

struct TaskModification: Codable {
    let action: String // "modify", "delete", "create"
    let taskId: String?
    let title: String?
    let date: Date?
    let notes: String?
}

final class OpenAIService {
    static let shared = OpenAIService()
    
    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }
    
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    private init() {}
    
    // MARK: - Chat with Task Context
    
    func chat(userMessage: String, tasks: [Task], context: ModelContext) async throws -> (response: String, modifications: [TaskModification]?) {
        guard !apiKey.isEmpty else {
            throw NSError(domain: "OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "OpenAI API key not configured. Add OPENAI_API_KEY to Info.plist"])
        }
        
        // Build task context for GPT
        let taskContext = buildTaskContext(from: tasks)
        
        // System prompt with instructions
        let systemPrompt = """
        You are TaskiAI, an intelligent task management assistant. You have access to the user's tasks and can help them manage their schedule.
        
        Current tasks:
        \(taskContext)
        
        When the user asks about their tasks, analyze the task list and provide helpful insights.
        When the user asks to modify a task (change date, title, notes, or delete), respond naturally AND append a special JSON block at the end in this exact format:
        
        [TASK_MODIFICATION]
        {
          "action": "modify|delete|create",
          "taskId": "task-uuid-here",
          "title": "new title",
          "date": "ISO8601 date string",
          "notes": "new notes"
        }
        [/TASK_MODIFICATION]
        
        For example, if user says "change the meeting date to tomorrow", respond with:
        "I'll update the meeting task to tomorrow for you.
        [TASK_MODIFICATION]
        {"action": "modify", "taskId": "uuid", "date": "2024-10-16T10:00:00Z"}
        [/TASK_MODIFICATION]"
        
        Be conversational and helpful. Only include the JSON block when actually modifying tasks.
        """
        
        let messages = [
            ChatCompletionRequest.ChatMessage(role: "system", content: systemPrompt),
            ChatCompletionRequest.ChatMessage(role: "user", content: userMessage)
        ]
        
        let request = ChatCompletionRequest(
            model: "gpt-4-turbo-preview", // or "gpt-4o" when available
            messages: messages,
            temperature: 0.7
        )
        
        var urlRequest = URLRequest(url: URL(string: apiURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "API request failed: \(errorMessage)"])
        }
        
        let completion = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
        guard let content = completion.choices.first?.message.content else {
            throw NSError(domain: "OpenAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from GPT"])
        }
        
        // Parse response for task modifications
        let (cleanResponse, modifications) = parseResponse(content, tasks: tasks, context: context)
        
        return (cleanResponse, modifications)
    }
    
    // MARK: - Helper Methods
    
    private func buildTaskContext(from tasks: [Task]) -> String {
        if tasks.isEmpty {
            return "No tasks currently."
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let taskList = tasks.enumerated().map { index, task in
            let dateStr = formatter.string(from: task.date)
            let status = task.isCompleted ? "✓ Completed" : "○ Pending"
            let notes = task.notes?.isEmpty == false ? " - \(task.notes!)" : ""
            return "\(index + 1). [\(task.id)] \(status) - \(task.title) (Due: \(dateStr))\(notes)"
        }.joined(separator: "\n")
        
        return taskList
    }
    
    private func parseResponse(_ response: String, tasks: [Task], context: ModelContext) -> (String, [TaskModification]?) {
        // Check if response contains task modification block
        guard response.contains("[TASK_MODIFICATION]") else {
            return (response, nil)
        }
        
        // Extract JSON block
        let pattern = "\\[TASK_MODIFICATION\\]\\s*\\{[^}]+\\}\\s*\\[/TASK_MODIFICATION\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators),
              let match = regex.firstMatch(in: response, range: NSRange(response.startIndex..., in: response)) else {
            return (response, nil)
        }
        
        let matchRange = Range(match.range, in: response)!
        let jsonBlock = String(response[matchRange])
        
        // Remove the block from response
        let cleanResponse = response.replacingOccurrences(of: jsonBlock, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Extract JSON
        let jsonPattern = "\\{[^}]+\\}"
        guard let jsonRegex = try? NSRegularExpression(pattern: jsonPattern),
              let jsonMatch = jsonRegex.firstMatch(in: jsonBlock, range: NSRange(jsonBlock.startIndex..., in: jsonBlock)) else {
            return (cleanResponse, nil)
        }
        
        let jsonRange = Range(jsonMatch.range, in: jsonBlock)!
        let jsonString = String(jsonBlock[jsonRange])
        
        // Parse JSON
        guard let jsonData = jsonString.data(using: .utf8),
              let modification = try? JSONDecoder().decode(TaskModification.self, from: jsonData) else {
            return (cleanResponse, nil)
        }
        
        // Apply modification
        applyModification(modification, tasks: tasks, context: context)
        
        return (cleanResponse, [modification])
    }
    
    private func applyModification(_ modification: TaskModification, tasks: [Task], context: ModelContext) {
        switch modification.action {
        case "modify":
            guard let taskId = modification.taskId,
                  let uuid = UUID(uuidString: taskId),
                  let task = tasks.first(where: { $0.id == uuid }) else { return }
            
            if let title = modification.title {
                task.title = title
            }
            if let date = modification.date {
                task.date = date
            }
            if let notes = modification.notes {
                task.notes = notes
            }
            try? context.save()
            
        case "delete":
            guard let taskId = modification.taskId,
                  let uuid = UUID(uuidString: taskId),
                  let task = tasks.first(where: { $0.id == uuid }) else { return }
            
            context.delete(task)
            try? context.save()
            
        case "create":
            guard let title = modification.title else { return }
            let newTask = Task(
                title: title,
                notes: modification.notes,
                date: modification.date ?? Date()
            )
            context.insert(newTask)
            try? context.save()
            
        default:
            break
        }
    }
}
