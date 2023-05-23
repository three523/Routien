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

class Routine {
    let identifier: UUID = UUID()
    let createTime: Date = Date()
    var description: String
    var dayOfWeek: [DayOfWeek]
    var startDate: Date
    var endDate: Date?
    var notificationTime: Date?
    var myTaskList: [RoutineTask]
    
    init(description: String, dayOfWeek: [DayOfWeek], startDate: Date, endDate: Date? = nil, notificationTime: Date? = nil, myTaskList: [RoutineTask] = []) {
        self.description = description
        self.dayOfWeek = dayOfWeek
        self.startDate = startDate
        self.endDate = endDate
        self.notificationTime = notificationTime
        self.myTaskList = myTaskList
    }
    
    var goalTask: [RoutineTask] {
        return myTaskList.filter { task in
            task.isDone
        }
    }
    var goalRate: Int {
        var firstAndLastWeekDays = 0 // 첫째주와 마지막주의 날짜 갯수를 표시해줄 변수
        var allTask = 0 // 기간동안 해야할 모든 작업들의 갯수를 표시해줄 변수
        let fromDate = startDate
        var toDate = Date()
        if let endDate,
           endDate < toDate {
            toDate = endDate
        }
        guard let fromDateWeek = fromDate.weekDay,
              let toDateWeek = toDate.weekDay,
              let differnceDay = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day else { return 0 }
        //taskTerm: 작업기간
        let taskTerm = differnceDay + 1
        
        let allCase = DayOfWeek.allCases
        guard let fromDateIndex = allCase.firstIndex(of: fromDateWeek),
              let toDateIndex = allCase.firstIndex(of: toDateWeek) else { return 0 }
        
        // 작업기간이 한주에 모두 포함되어 있는 경우
        if taskTerm < 7 && fromDateIndex < toDateIndex {
            allTask = allCase[fromDateIndex...toDateIndex].filter { allCaseWeek in
                self.dayOfWeek.contains(allCaseWeek)
            }.count
        } else { // 작업기간을 계산할때 처음과 마지막이 모든 요일이 포함되어있는지 빠져있는지 알 수 없기때문에 첫째주와 마지막주에만 시작요일과 종료요일을 구해서
                 // 첫째주와 마지막주는 몇일이 존재하는지 구하고 총 작업기간에서 빼준뒤에 작업을 수행한다.
            firstAndLastWeekDays += allCase[fromDateIndex...].count + allCase[...toDateIndex].count // 첫째주와 마지막주의 날짜만큼 더해준다
            allTask += allCase[fromDateIndex...].filter { allCaseWeek in // 첫째주에 해야할 작업의 갯수 구하기
                self.dayOfWeek.contains(allCaseWeek)
            }.count
            allTask += allCase[...toDateIndex].filter { allCaseWeek in // 마지막주에 해야할 작업의 갯수 구하기
                self.dayOfWeek.contains(allCaseWeek)
            }.count
            let middleTerm = (taskTerm - firstAndLastWeekDays) / 7 // 첫째주와 마지막주를 제외하여 7일이 모두 있는 주가 몇번있는지
            allTask += allCase.filter{ allCaseWeek in
                self.dayOfWeek.contains(allCaseWeek)
            }.count * middleTerm
        }
        
        let goalRate = round((Double(goalTask.count) / Double(allTask)) * 1000) / 10
        
        return Int(goalRate)
    }
    
    fileprivate func createTask(date: Date) -> RoutineTask {
        return RoutineCheckTask(routine: self, taskDate: date)
    }
    //MARK: get은 좋지않음 다른 단어 생각해보기
    func getTask(date: Date) -> RoutineTask? {
        if startDate > date { return nil }
        if let endDate = endDate,
           endDate < date {
            return nil
        }
        guard let weekDay = date.weekDay else { return nil }
        let isExits = dayOfWeek.first { $0 == weekDay }
        if isExits == nil { return nil }
        let task = createTask(date: date)
        myTaskList.append(task)
        return task
    }
    func allDoneTaskUpdate() {
        for index in 0..<myTaskList.count {
            myTaskList[index].description = self.description
        }
    }
    func afterTaskUpdate(date: Date) {
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

class TextRoutine: Routine {
    
    override func createTask(date: Date) -> RoutineTask {
        return RoutineTextTask(routine: self, taskDate: date)
    }
}

class CountRoutine: Routine {
    var goal: Int
    
    init(description: String, dayOfWeek: [DayOfWeek], startDate: Date, endDate: Date? = nil, notificationTime: Date? = nil, myTaskList: [RoutineTask] = [], goal: Int) {
        self.goal = goal
        super.init(description: description, dayOfWeek: dayOfWeek, startDate: startDate)
    }
    
    override func createTask(date: Date) -> RoutineTask {
        return RoutineCountTask(routine: self, description: self.description, goal: self.goal, taskDate: date)
    }
}

class RoutineTextTask: RoutineCheckTask {
    var text: String {
        didSet {
            isDone = false == text.isEmpty
        }
    }
    
    init(routine: Routine, text: String = "", taskDate: Date, isDone: Bool = false) {
        self.text = text
        super.init(routine: routine, taskDate: taskDate)
    }
}

class RoutineCountTask: RoutineCheckTask {
    private var taskDescription: String
    var goal: Int
    var count: Int = 0 {
        didSet {
            if goal == count { isDone = true }
        }
    }
    
    init(routine: Routine, description: String, goal: Int, taskDate: Date) {
        self.taskDescription = description
        self.goal = goal
        super.init(routine: routine, taskDate: taskDate)
    }
}

class RoutineCheckTask: RoutineTask {
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
