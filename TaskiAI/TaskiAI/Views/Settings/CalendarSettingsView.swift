import SwiftUI

struct CalendarSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstDayOfWeek = 0 // 0 = Sunday
    @State private var show24Hour = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            GeometryReader { geo in
                ScrollView {
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
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Week Settings")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    Picker("First Day of Week", selection: $firstDayOfWeek) {
                                        Text("Sunday").tag(0)
                                        Text("Monday").tag(1)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time Format")
                                    .font(.system(size: 14, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    Toggle("24-Hour Time", isOn: $show24Hour)
                                        .padding()
                                        .background(Color(.systemGray6))
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.bottom + 20, 40))
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
    }
}
