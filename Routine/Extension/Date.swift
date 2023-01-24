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
}
