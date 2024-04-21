//
//  ContentView.swift
//  Calender
//
//  Created by Liu, Emily on 4/15/24.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            Text("Calendar App")
                .font(.title)
                .padding()

            CalendarView(selectedDate: $selectedDate)
                .padding()

            Spacer()
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            CalendarHeaderView(selectedDate: $selectedDate)

            CalendarGridView(selectedDate: $selectedDate)
        }
    }
}

struct CalendarHeaderView: View {
    @Binding var selectedDate: Date

    var body: some View {
        HStack {
            Button(action: {
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
            }) {
                Image(systemName: "chevron.left")
            }
            .padding()

            Text("\(formattedMonthYear(date: selectedDate))")
                .font(.title2)

            Button(action: {
                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
            }) {
                Image(systemName: "chevron.right")
            }
            .padding()
        }
    }

    func formattedMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            HStack {
                ForEach(1...7, id: \.self) { day in
                    Text(dayOfWeekSymbol(index: day))
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }

            Divider()

            ForEach(monthGrid(), id: \.self) { week in
                HStack {
                    ForEach(week, id: \.self) { date in
                        Button(action: {
                            selectedDate = date
                        }) {
                            Text("\(dayOfMonth(date: date))")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedDate == date ? Color.blue : Color.clear)
                                .clipShape(Circle())
                                .foregroundColor(selectedDate == date ? .white : .primary)
                        }
                    }
                }
            }
        }
    }

    func monthGrid() -> [[Date]] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: selectedDate)
        let month = calendar.component(.month, from: startDate)
        let year = calendar.component(.year, from: startDate)
        let range = calendar.range(of: .day, in: .month, for: selectedDate)!
        let numberOfDaysInMonth = range.count

        var grid = [[Date]]()
        var week = [Date]()

        for i in 1...numberOfDaysInMonth {
            let components = DateComponents(year: year, month: month, day: i)
            if let date = calendar.date(from: components) {
                week.append(date)
                if calendar.component(.weekday, from: date) == 7 || i == numberOfDaysInMonth {
                    grid.append(week)
                    week = []
                }
            }
        }

        return grid
    }

    func dayOfWeekSymbol(index: Int) -> String {
        let calendar = Calendar.current
        let symbols = calendar.shortWeekdaySymbols
        return symbols[index % symbols.count]
    }

    func dayOfMonth(date: Date) -> String {
        let calendar = Calendar.current
        return "\(calendar.component(.day, from: date))"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
