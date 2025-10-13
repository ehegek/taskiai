import SwiftUI

struct TermsOfServiceView: View {
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
                            Text("Terms of Service")
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
                            Text("Terms of Service")
                                .font(.system(size: 28, weight: .bold))
                            
                            Text("Last updated: \(Date.now.formatted(date: .long, time: .omitted))")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            
                            Text("By using TaskiAI, you agree to these Terms of Service.")
                                .font(.system(size: 16))
                            
                            Group {
                                Text("1. Acceptance of Terms")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("By accessing and using TaskiAI, you accept and agree to be bound by the terms and provision of this agreement.")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("2. Use License")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("Permission is granted to use TaskiAI for personal, non-commercial purposes. This is the grant of a license, not a transfer of title.")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("3. User Account")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities under your account.")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("4. Prohibited Uses")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("You may not use TaskiAI:\n• For any unlawful purpose\n• To harass, abuse, or harm others\n• To impersonate any person or entity\n• To violate any applicable laws")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("5. Termination")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("We may terminate or suspend your account immediately, without prior notice, for any reason, including breach of these Terms.")
                                    .font(.system(size: 16))
                            }
                            
                            Group {
                                Text("6. Contact Us")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("If you have questions about these Terms, please contact us at support@taskiai.com")
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
    TermsOfServiceView()
}
