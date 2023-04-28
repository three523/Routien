//
//  Routine.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation
import UserNotifications

enum DayOfWeek: String, CaseIterable {
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fir = "금"
    case sat = "토"
    case sun = "일"
    
    static let allCases: [DayOfWeek] = [.sun, .mon, .tue, .wed, .thu, .fir, .sat]
    static let monStartAllCases: [DayOfWeek] = [.mon, .tue, .wed, .thu, .fir, .sat, .sun]
}

protocol RoutineTask: Task {
    var routineIdentifier: UUID { get }
}

protocol Routine {
    var identifier: UUID { get }
    var description: String { get set }
    var dayOfWeek: [DayOfWeek] { get set }
    var startDate: Date { get set }
    var endDate: Date? { get set }
    var notificationTime: Date? { get set }
    var myTaskList: [RoutineTask] { get set }
    
    mutating func createTask(date: Date) -> RoutineTask?
    mutating func allDoneTaskUpdate()
    mutating func afterTaskUpdate(date: Date)
}

extension Routine {
    mutating func allDoneTaskUpdate() {
        for index in 0..<myTaskList.count {
            myTaskList[index].description = self.description
        }
    }
    mutating func afterTaskUpdate(date: Date) {
        guard let afterIndex = myTaskList.firstIndex(where: { $0.taskDate >= date }) else { return }
        for index in afterIndex..<myTaskList.count {
            myTaskList[index].description = self.description
        }
    }
    func notification() -> [UNNotificationRequest] {
        if notificationTime == nil { return [] }
        let triggers = createTrigger()
        var requestList = [UNNotificationRequest]()
        triggers.forEach { trigger in
            let content = UNMutableNotificationContent()
            content.title = self.description
            content.sound = UNNotificationSound.default
            guard let weekday = trigger.dateComponents.weekday else { return }
            requestList.append(UNNotificationRequest(identifier: self.identifier.uuidString + String(weekday), content: content, trigger: trigger))
        }
        return requestList
    }
    //TODO: 루틴 업데이트시 기존 루틴 제거방법 생각하기
    private func createTrigger() -> [UNCalendarNotificationTrigger] {
        var triggerWeekly = [UNCalendarNotificationTrigger]()
        let allDayOfWeek = DayOfWeek.allCases
        for weekday in 0..<allDayOfWeek.count where self.dayOfWeek.contains(allDayOfWeek[weekday]) {
            var weekDayDateComponents = DateComponents(hour: notificationTime?.hour, minute: notificationTime?.minute, weekday: weekday + 1)
            let trigger = UNCalendarNotificationTrigger(dateMatching: weekDayDateComponents, repeats: true)
            triggerWeekly.append(trigger)
        }
        return triggerWeekly
    }
}

struct CheckRoutine: Routine {
    let identifier: UUID = UUID()
    var description: String
    var dayOfWeek: [DayOfWeek]
    var startDate: Date
    var endDate: Date?
    var notificationTime: Date?
    var myTaskList: [RoutineTask] = []
    
    mutating func createTask(date: Date) -> RoutineTask? {
        if let endDate = endDate,
           endDate < date || startDate > date {
            return nil
        }
        guard let weekDay = date.weekDay else { return nil }
        let isExits = dayOfWeek.first { $0 == weekDay }
        let task = RoutineCheckTask(routine: self, taskDate: date )
        myTaskList.append(task)
        return isExits == nil ? nil : task
    }
}

struct TextRoutine: Routine {
    let identifier: UUID = UUID()
    var description: String
    var dayOfWeek: [DayOfWeek]
    var startDate: Date
    var endDate: Date?
    var notificationTime: Date?
    var myTaskList: [RoutineTask] = []
    
    mutating func createTask(date: Date) -> RoutineTask? {
        if let endDate = endDate,
           endDate < date || startDate > date {
            return nil
        }
        guard let weekDay = date.weekDay else { return nil }
        let isExits = dayOfWeek.first { $0 == weekDay }
        let task = RoutineTextTask(routine: self, text: "", taskDate: date)
        myTaskList.append(task)
        return isExits == nil ? nil : task
    }
}

struct CountRoutine: Routine {
    let identifier: UUID = UUID()
    var description: String
    var dayOfWeek: [DayOfWeek]
    var startDate: Date
    var endDate: Date?
    var notificationTime: Date?
    var goal: Int
    var myTaskList: [RoutineTask] = []
    
    mutating func createTask(date: Date) -> RoutineTask? {
        if let endDate = endDate,
           endDate < date || startDate > date {
            return nil
        }
        guard let weekDay = date.weekDay else { return nil }
        let isExits = dayOfWeek.first { $0 == weekDay }
        let task = RoutineCountTask(routine: self, description: description, goal: goal, taskDate: date )
        myTaskList.append(task)
        return isExits == nil ? nil : task
    }
}

struct RoutineTextTask: RoutineTask {
    var routineIdentifier: UUID
    var identifier: UUID = UUID()
    var description: String
    var text: String {
        didSet {
            isDone = false == text.isEmpty
        }
    }
    var taskDate: Date
    var isDone: Bool = false
    
    init(routine: Routine, text: String, taskDate: Date, isDone: Bool = false) {
        self.routineIdentifier = routine.identifier
        self.description = routine.description
        self.text = text
        self.taskDate = taskDate
    }
}

struct RoutineCountTask: RoutineTask {
    var routineIdentifier: UUID
    var identifier: UUID = UUID()
    var description: String
    private var taskDescription: String
    var goal: Int
    var count: Int = 0 {
        didSet {
            if goal == count { isDone = true }
        }
    }
    var taskDate: Date
    var isDone: Bool = false
    
    init(routine: Routine, description: String, goal: Int, taskDate: Date) {
        self.routineIdentifier = routine.identifier
        self.description = routine.description
        self.taskDescription = description
        self.goal = goal
        self.taskDate = taskDate
    }
}

struct RoutineCheckTask: RoutineTask {
    var routineIdentifier: UUID
    var identifier: UUID = UUID()
    var description: String
    var taskDate: Date
    var isDone: Bool = false
    
    init(routine: Routine, taskDate: Date) {
        self.routineIdentifier = routine.identifier
        self.description = routine.description
        self.taskDate = taskDate
    }
}
