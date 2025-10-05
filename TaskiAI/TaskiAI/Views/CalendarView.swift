import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var monthOffset: Int = 0
    @State private var selectedDate: Date = .now
    @Environment(\.modelContext) private var context

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea(.all)
            VStack(spacing: 12) {
                MonthHeader(monthOffset: $monthOffset)
                MonthGrid(monthOffset: monthOffset, selectedDate: $selectedDate)
                DaySections(date: selectedDate)
                Spacer()
                NavigationLink { NewTaskView(defaultDate: selectedDate) } label: {
                    Image(systemName: "plus.circle.fill").font(.system(size: 44))
                }
            }
            .padding()
        }
        .navigationTitle("Calendar")
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct MonthHeader: View {
    @Binding var monthOffset: Int
    var body: some View {
        HStack {
            Button { monthOffset -= 1 } label: { Image(systemName: "chevron.left") }
            Spacer()
            Text(currentMonthString).font(.headline)
            Spacer()
            Button { monthOffset += 1 } label: { Image(systemName: "chevron.right") }
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
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
            }
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
        _tasks = Query(filter: #Predicate<Task> { $0.date >= start && $0.date < end }, sort: \Task.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DisclosureGroup("To Do") { ForEach(tasks.filter { !$0.isCompleted }) { TaskRow(task: $0) } }
            DisclosureGroup("Completed") { ForEach(tasks.filter { $0.isCompleted }) { TaskRow(task: $0) } }
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
                .frame(maxWidth: .infinity)
                .padding(8)
                .foregroundStyle(day.inMonth ? .primary : .secondary)
                .background(
                    (Calendar.current.isDate(selectedDate, inSameDayAs: day.date) ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                )
        }
        .buttonStyle(.plain)
    }
}
