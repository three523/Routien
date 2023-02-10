//
//  Date.swift
//  Routine
//
//  Created by 김도현 on 2023/01/19.
//

import Foundation

extension Date {
    var timeToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:ss"
        return formatter.string(from: self)
    }
    
    var dateToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var weekDay: DayOfWeek? {
        let index = Calendar.current.component(.weekday, from: self) - 1
        let weekDays = DayOfWeek.allCases
        return index < 0 ? weekDays.last : weekDays[index]
    }
    
    var defaultDays: [Date] {
        var days = [Date]()
        days.append(contentsOf: previousWeek ?? [])
        days.append(contentsOf: weekDays(weekInDate: self))
        days.append(contentsOf: nextWeek ?? [])
        return days
    }
    
    var previousWeek: [Date]? {
        let calendar = Calendar.current
        guard let dateInWeek = calendar.date(byAdding: .day, value: -7, to: self) else { return nil }
        return weekDays(weekInDate: dateInWeek)
    }
    
    var nextWeek: [Date]? {
        let calendar = Calendar.current
        guard let dateInWeek = calendar.date(byAdding: .day, value: 7, to: self) else { return nil }
        return weekDays(weekInDate: dateInWeek)
    }
    
    func weekDays(weekInDate date: Date) -> [Date] {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekdays = calendar.range(of: .weekday, in: .weekOfMonth, for: date) ?? Range(uncheckedBounds: (lower: 1, upper: 8))
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: date) }
        return days
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
}
