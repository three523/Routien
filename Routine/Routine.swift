//
//  Routine.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

enum DayOfWeek: String, CaseIterable {
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fir = "금"
    case sat = "토"
    case sun = "일"
    
    static let allCases: [DayOfWeek] = [.mon, .tue, .wed, .thu, .fir, .sat, .sun]
}

protocol RoutineTask: Task {
    var routineIdentifier: UUID { get }
}

struct Routine {
    let identifier: UUID = UUID()
    var description: String
    var dayOfWeek: [DayOfWeek] = [.mon, .tue, .wed, .thu, .fir, .sat, .sun]
    var startDate: Date = Date()
    var endDate: Date?
    var notificationTime: Date?
    var type: RoutineType = .check
    var myTaskList: [RoutineTask] = []
    
    func createTask(date: Date) -> RoutineTask? {
        guard let weekDay = date.weekDay else { return nil }
        let isExits = dayOfWeek.first { $0 == weekDay }
        return isExits == nil ? nil : RoutineCheckTask(routine: self, taskDate: date )
    }
}

struct RoutineTextTask: RoutineTask {
    var routineIdentifier: UUID
    var identifier: UUID = UUID()
    var descrpition: String
    var text: String {
        didSet {
            isDone = false == text.isEmpty
        }
    }
    var taskDate: Date
    var isDone: Bool = false
    
    init(routine: Routine, text: String, taskDate: Date, isDone: Bool = false) {
        self.routineIdentifier = routine.identifier
        self.descrpition = routine.description
        self.text = text
        self.taskDate = taskDate
    }
}

struct RoutineCountTask: RoutineTask {
    var routineIdentifier: UUID
    var identifier: UUID = UUID()
    var descrpition: String
    private var description: String
    var text: String {
        return description + "\(count)"
    }
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
        self.descrpition = routine.description
        self.description = description
        self.goal = goal
        self.taskDate = taskDate
    }
}

struct RoutineCheckTask: RoutineTask {
    var routineIdentifier: UUID
    var identifier: UUID = UUID()
    var descrpition: String
    var taskDate: Date
    var isDone: Bool = false
    
    init(routine: Routine, taskDate: Date) {
        self.routineIdentifier = routine.identifier
        self.descrpition = routine.description
        self.taskDate = taskDate
    }
}
