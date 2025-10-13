import SwiftUI

struct VoiceChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isRecording = false
    @State private var duration: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.top + 20, 60))
                    
                    // Header
                    Text("Taski AI")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    
                    // Animated voice wave
                    VStack(spacing: 20) {
                        ZStack {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                    .frame(width: 150 + CGFloat(index * 40), height: 150 + CGFloat(index * 40))
                                    .scaleEffect(isRecording ? 1.2 : 1.0)
                                    .opacity(isRecording ? 0.3 : 0.6)
                                    .animation(
                                        .easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: isRecording
                                    )
                            }
                            
                            Image(systemName: isRecording ? "waveform" : "mic.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        }
                        
                        Text(isRecording ? "Listening..." : "Tap to talk")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                        
                        if isRecording {
                            Text(timeString(duration))
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    // Record button
                    Button {
                        toggleRecording()
                    } label: {
                        Circle()
                            .fill(isRecording ? Color.red : Color.white)
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                            .overlay(
                                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                    .font(.system(size: 36))
                                    .foregroundStyle(isRecording ? .white : .blue)
                            )
                    }
                    
                    // Close button
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.2))
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                        .frame(height: max(geo.safeAreaInsets.bottom + 20, 40))
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        
        if isRecording {
            duration = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                duration += 1
            }
            // TODO: Start actual voice recording
        } else {
            timer?.invalidate()
            timer = nil
            // TODO: Stop voice recording and process
        }
    }
    
    private func timeString(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
