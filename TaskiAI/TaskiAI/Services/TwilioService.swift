import Foundation

final class TwilioService {
    static let shared = TwilioService()
    
    // These should be set in environment variables or secure configuration
    private var accountSID: String { Bundle.main.object(forInfoDictionaryKey: "TWILIO_ACCOUNT_SID") as? String ?? "" }
    private var authToken: String { Bundle.main.object(forInfoDictionaryKey: "TWILIO_AUTH_TOKEN") as? String ?? "" }
    private var fromPhone: String { Bundle.main.object(forInfoDictionaryKey: "TWILIO_PHONE_NUMBER") as? String ?? "" }
    private var fromEmail: String { Bundle.main.object(forInfoDictionaryKey: "TWILIO_EMAIL") as? String ?? "noreply@taskiai.app" }
    
    private init() {}
    
    // MARK: - SMS Reminder
    
    func sendSMSReminder(to phoneNumber: String, taskTitle: String, taskTime: Date) async throws {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let timeString = formatter.string(from: taskTime)
        
        let message = "TaskiAI Reminder: \(taskTitle) is due at \(timeString)"
        
        try await sendSMS(to: phoneNumber, message: message)
    }
    
    private func sendSMS(to phoneNumber: String, message: String) async throws {
        guard !accountSID.isEmpty, !authToken.isEmpty, !fromPhone.isEmpty else {
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "Twilio credentials not configured"])
        }
        
        let url = URL(string: "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Basic Auth
        let credentials = "\(accountSID):\(authToken)"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = [
            "To": phoneNumber,
            "From": fromPhone,
            "Body": message
        ]
        
        request.httpBody = bodyParams.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "SMS failed: \(errorMessage)"])
        }
    }
    
    // MARK: - Email Reminder
    
    func sendEmailReminder(to email: String, taskTitle: String, taskTime: Date) async throws {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let timeString = formatter.string(from: taskTime)
        
        let subject = "TaskiAI Reminder: \(taskTitle)"
        let body = """
        Hello,
        
        This is a reminder for your task:
        
        Task: \(taskTitle)
        Due: \(timeString)
        
        Don't forget to complete it!
        
        Best regards,
        TaskiAI Team
        """
        
        try await sendEmail(to: email, subject: subject, body: body)
    }
    
    private func sendEmail(to email: String, subject: String, body: String) async throws {
        guard !accountSID.isEmpty, !authToken.isEmpty else {
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "Twilio credentials not configured"])
        }
        
        // Using Twilio SendGrid API
        let url = URL(string: "https://api.sendgrid.com/v3/mail/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // You'll need to set SENDGRID_API_KEY in Info.plist
        let sendGridKey = Bundle.main.object(forInfoDictionaryKey: "SENDGRID_API_KEY") as? String ?? ""
        guard !sendGridKey.isEmpty else {
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "SendGrid API key not configured"])
        }
        
        request.setValue("Bearer \(sendGridKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "personalizations": [[
                "to": [["email": email]]
            ]],
            "from": ["email": fromEmail],
            "subject": subject,
            "content": [[
                "type": "text/plain",
                "value": body
            ]]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email failed: \(errorMessage)"])
        }
    }
    
    // MARK: - Phone Call Reminder
    
    func schedulePhoneCallReminder(to phoneNumber: String, taskTitle: String, taskTime: Date) async throws {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let timeString = formatter.string(from: taskTime)
        
        let message = "Hello, this is TaskiAI. You have a reminder for: \(taskTitle), due at \(timeString). Thank you."
        
        try await makePhoneCall(to: phoneNumber, message: message)
    }
    
    private func makePhoneCall(to phoneNumber: String, message: String) async throws {
        guard !accountSID.isEmpty, !authToken.isEmpty, !fromPhone.isEmpty else {
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "Twilio credentials not configured"])
        }
        
        // Generate TwiML for text-to-speech
        let twiml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
            <Say voice="alice">\(message)</Say>
        </Response>
        """
        
        let url = URL(string: "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Calls.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Basic Auth
        let credentials = "\(accountSID):\(authToken)"
        let credentialsData = credentials.data(using: .utf8)!
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // For TwiML, we need to host it or use Twiml parameter directly
        // For simplicity, using Twiml parameter (requires proper URL encoding)
        let bodyParams = [
            "To": phoneNumber,
            "From": fromPhone,
            "Twiml": twiml
        ]
        
        request.httpBody = bodyParams.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "Twilio", code: -1, userInfo: [NSLocalizedDescriptionKey: "Phone call failed: \(errorMessage)"])
        }
    }
}
