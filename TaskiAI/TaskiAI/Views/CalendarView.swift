import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var monthOffset: Int = 0
    @State private var selectedDate: Date = .now
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemBackground).ignoresSafeArea()
            
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 14) {
                        Spacer()
                            .frame(height: geo.safeAreaInsets.top)
                        // Custom back bar
                        HStack(spacing: 8) {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)

                        Text("Calendar")
                            .font(.system(size: 28, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        MonthHeader(monthOffset: $monthOffset)
                            .padding(.horizontal, 20)

                        MonthGrid(monthOffset: monthOffset, selectedDate: $selectedDate)
                            .padding(.horizontal, 16)

                        DaySections(date: selectedDate)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)
                        
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.bottom + 80, 80))
                    }
                }

                NavigationLink { NewTaskView(defaultDate: selectedDate) } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color.black)
                                .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
                        )
                }
                .position(x: UIScreen.main.bounds.width - 40, y: UIScreen.main.bounds.height - geo.safeAreaInsets.bottom - 40)
            }
        }
        .navigationTitle("Calendar")
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct MonthHeader: View {
    @Binding var monthOffset: Int
    var body: some View {
        HStack(spacing: 8) {
            Button { monthOffset -= 1 } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(.systemGray6)))
            }
            
            Text(currentMonthString)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(Color(.systemGray6))
                )
            
            Button { monthOffset += 1 } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(.systemGray6)))
            }
        }
    }
    private var currentMonthString: String {
        let date = Calendar.current.date(byAdding: .month, value: monthOffset, to: Date())!
        return date.formatted(.dateTime.month(.wide).year())
    }
}

private struct MonthGrid: View {
    var monthOffset: Int
    @Binding var selectedDate: Date
    var body: some View {
        let date = Calendar.current.date(byAdding: .month, value: monthOffset, to: Date())!
        CalendarMonthView(date: date, selectedDate: $selectedDate)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
    }
}

private struct DaySections: View {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [Task]
    let date: Date

    init(date: Date) {
        self.date = date
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        _tasks = Query(filter: #Predicate<Task> { $0.date >= start && $0.date < end }, sort: \.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 4)
            
            DisclosureGroup {
                ForEach(tasks.filter { !$0.isCompleted }) { task in
                    TaskRow(task: task)
                }
            } label: {
                HStack {
                    Text("To Do")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("\(tasks.filter { !$0.isCompleted }.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            
            DisclosureGroup {
                ForEach(tasks.filter { $0.isCompleted }) { task in
                    TaskRow(task: task)
                }
            } label: {
                HStack {
                    Text("Completed")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text("\(tasks.filter { $0.isCompleted }.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

// Simple month grid
struct CalendarMonthView: View {
    let date: Date
    @Binding var selectedDate: Date

    var body: some View {
        let days = generateDays(for: date)
        VStack(spacing: 8) {
            HStack { ForEach(["Sun","Mon","Tue","Wed","Thu","Fri","Sat"], id: \.self) { Text($0).frame(maxWidth: .infinity) } }
            ForEach(0..<days.count/7, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<7, id: \.self) { col in
                        let d = days[row*7+col]
                        DayCell(day: d, selectedDate: $selectedDate)
                    }
                }
            }
        }
    }

    struct Day: Identifiable { let id = UUID(); let date: Date; let inMonth: Bool }

    func generateDays(for base: Date) -> [Day] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let range = calendar.range(of: .day, in: .month, for: base)!
        let first = calendar.date(from: calendar.dateComponents([.year, .month], from: base))!
        let firstWeekday = calendar.component(.weekday, from: first)
        var days: [Day] = []
        // leading
        if firstWeekday > 1 {
            for i in stride(from: firstWeekday-2, through: 0, by: -1) {
                let d = calendar.date(byAdding: .day, value: -i-1, to: first)!
                days.append(Day(date: d, inMonth: false))
            }
        }
        // current month
        for i in 0..<range.count {
            let d = calendar.date(byAdding: .day, value: i, to: first)!
            days.append(Day(date: d, inMonth: true))
        }
        // trailing to fill 6 weeks
        while days.count % 7 != 0 { let d = calendar.date(byAdding: .day, value: days.count - (firstWeekday-1), to: first)!; days.append(Day(date: d, inMonth: false)) }
        while days.count < 42 { let d = calendar.date(byAdding: .day, value: days.count - (firstWeekday-1), to: first)!; days.append(Day(date: d, inMonth: false)) }
        return days
    }
}

struct DayCell: View {
    let day: CalendarMonthView.Day
    @Binding var selectedDate: Date
    var body: some View {
        Button {
            selectedDate = day.date
        } label: {
            Text(String(Calendar.current.component(.day, from: day.date)))
                .font(.system(size: 16, weight: Calendar.current.isDate(selectedDate, inSameDayAs: day.date) ? .bold : .regular))
                .frame(maxWidth: .infinity)
                .padding(10)
                .foregroundStyle(day.inMonth ? .primary : .secondary)
                .background(
                    (Calendar.current.isDate(selectedDate, inSameDayAs: day.date) ? Color.blue : Color.clear)
                        .clipShape(Circle())
                )
                .foregroundStyle(Calendar.current.isDate(selectedDate, inSameDayAs: day.date) ? .white : (day.inMonth ? .primary : .secondary))
        }
        .buttonStyle(.plain)
    }
}
