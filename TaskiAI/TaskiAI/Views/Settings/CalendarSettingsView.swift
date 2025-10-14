import SwiftUI

struct CalendarSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstDayOfWeek = 0 // 0 = Sunday
    @State private var show24Hour = false
    
    var body: some View {
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
        .safeAreaInset(edge: .top, spacing: 0) {
            GeometryReader { geo in
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
                .padding(.top, geo.safeAreaInsets.top)
                .background(Color(.systemBackground).ignoresSafeArea(edges: .top))
            }
        }
        .navigationBarHidden(true)
    }
}
