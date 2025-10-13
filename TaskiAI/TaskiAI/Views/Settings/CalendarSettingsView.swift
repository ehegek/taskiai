import SwiftUI

struct CalendarSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstDayOfWeek = 0 // 0 = Sunday
    @State private var show24Hour = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with proper spacing
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.top + 10, 50))
                        
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Text("Calendar")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Color.clear.frame(width: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemBackground))
                    
                    Form {
                        Section("Week Settings") {
                            Picker("First Day of Week", selection: $firstDayOfWeek) {
                                Text("Sunday").tag(0)
                                Text("Monday").tag(1)
                            }
                        }
                        
                        Section("Time Format") {
                            Toggle("24-Hour Time", isOn: $show24Hour)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
