import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: geo.safeAreaInsets.top)
                        
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Text("Privacy Policy")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Color.clear.frame(width: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemBackground))
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Privacy Policy")
                                .font(.system(size: 28, weight: .bold))
                            
                            Text("Last updated: \(Date.now.formatted(date: .long, time: .omitted))")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            
                            Text("Your privacy is important to us. This Privacy Policy explains how TaskiAI collects, uses, and protects your information.")
                                .font(.system(size: 16))
                            
                            Group {
                                Text("Information We Collect")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("• Account information (name, email)\n• Task and reminder data\n• Usage analytics\n• Device information")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("How We Use Your Information")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("• To provide and improve our services\n• To send notifications and reminders\n• To analyze app usage\n• To ensure security")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("Data Security")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("We implement industry-standard security measures to protect your data. Your information is encrypted both in transit and at rest.")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("Contact Us")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("If you have questions about this Privacy Policy, please contact us at support@taskiai.com")
                                    .font(.system(size: 16))
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    PrivacyPolicyView()
}
