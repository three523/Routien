//
//  Routine.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import UserNotifications
import RealmSwift

enum DayOfWeek: String, CaseIterable, PersistableEnum {
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fir = "금"
    case sat = "토"
    case sun = "일"
}

/* MARK: 루틴을 db에 저장하기 위해선 지금처럼 상속하는 방식으로는 해결할수 없음.
    방법1: 모델역할만 하는 클래스들을 따로 만들고(CheckRoutine, CountRoutine, TextRoutine) 그 루틴들을 한곳에 모을수 있는 슈펴 클래스(Routine)를 만듦
 -> Routine에는 myTaskList를 제외시키고 함수로 RoutineTask를 리턴하는 함수를 만듦
    
    방법2: 그냥 별개로 두고 한곳에 모아서 원하는 방식으로 정렬할 수 있게 만듦
*/

protocol Routine {
    var identifier: UUID { get }
    var createTime: Date { get set }
    var title: String { get set }
    var dayOfWeeks: List<DayOfWeek> { get set }
    var startDate: Date { get set }
    var endDate: Date? { get set }
    var notificationTime: Date? { get set }
    var myTasks: [RoutineTask] { get set }
    func createTask(date: Date) -> RoutineTask
}

extension Routine {

    func doneTasks() -> [RoutineTask] {
        return myTasks.filter { $0.isDone }
    }
    
    func goalRate() -> Int {
        var firstAndLastWeekDays = 0 // 첫째주와 마지막주의 날짜 갯수를 표시해줄 변수
        var allTask = 0 // 기간동안 해야할 모든 작업들의 갯수를 표시해줄 변수
        let fromDate = startDate
        var toDate = Date().lastTimeDate
        if let endDate {
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
                self.dayOfWeeks.contains(allCaseWeek)
            }.count
        } else { // 작업기간을 계산할때 처음과 마지막이 모든 요일이 포함되어있는지 빠져있는지 알 수 없기때문에 첫째주와 마지막주에만 시작요일과 종료요일을 구해서
                 // 첫째주와 마지막주는 몇일이 존재하는지 구하고 총 작업기간에서 빼준뒤에 작업을 수행한다.
            firstAndLastWeekDays += allCase[fromDateIndex...].count + allCase[...toDateIndex].count // 첫째주와 마지막주의 날짜만큼 더해준다
            allTask += allCase[fromDateIndex...].filter { allCaseWeek in // 첫째주에 해야할 작업의 갯수 구하기
                self.dayOfWeeks.contains(allCaseWeek)
            }.count
            allTask += allCase[...toDateIndex].filter { allCaseWeek in // 마지막주에 해야할 작업의 갯수 구하기
                self.dayOfWeeks.contains(allCaseWeek)
            }.count
            let middleTerm = (taskTerm - firstAndLastWeekDays) / 7 // 첫째주와 마지막주를 제외하여 7일이 모두 있는 주가 몇번있는지
            allTask += allCase.filter{ allCaseWeek in
                self.dayOfWeeks.contains(allCaseWeek)
            }.count * middleTerm
        }
        
        let goalRate = round((Double(doneTasks().count) / Double(allTask)) * 1000) / 10
        
        return Int(goalRate)
    }
    
    mutating func getTask(date: Date) -> RoutineTask? {
        if startDate > date { return nil }
        if let endDate = endDate,
           endDate < date {
            return nil
        }
        guard let weekDay = date.weekDay else { return nil }
        let isExits = dayOfWeeks.first { $0 == weekDay }
        if isExits == nil { return nil }
        let task = createTask(date: date)
        myTasks.append(task)
        return task
    }
    
    mutating func allTaskTitleUpdate() {
        for index in 0..<myTasks.count {
            myTasks[index].title = self.title
        }
    }
    
    mutating func afterTaskUpdate(date: Date) {
        guard let afterIndex = myTasks.firstIndex(where: { $0.taskDate >= date }) else { return }
        for index in afterIndex..<myTasks.count {
            myTasks[index].title = self.title
        }
    }
    
    func notification() -> [UNNotificationRequest] {
        if notificationTime == nil { return [] }
        let triggers = createTrigger()
        var requestList = [UNNotificationRequest]()
        triggers.forEach { trigger in
            let content = UNMutableNotificationContent()
            content.title = self.title
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
        for weekday in 0..<allDayOfWeek.count where self.dayOfWeeks.contains(allDayOfWeek[weekday]) {
            var weekDayDateComponents = DateComponents(hour: notificationTime?.hour, minute: notificationTime?.minute, weekday: weekday + 1)
            let trigger = UNCalendarNotificationTrigger(dateMatching: weekDayDateComponents, repeats: true)
            triggerWeekly.append(trigger)
        }
        return triggerWeekly
    }

}

final class CheckRoutine: Object, Routine {
        
    @Persisted(primaryKey:true) var identifier: UUID = UUID()
    @Persisted var createTime: Date = Date()
    @Persisted var title: String
    @Persisted var dayOfWeeks: List<DayOfWeek>
    @Persisted var startDate: Date
    @Persisted var endDate: Date?
    @Persisted var notificationTime: Date?
    @Persisted var myTaskList: List<RoutineCheckTask>
    var myTasks: [RoutineTask] {
        get {
            return myTaskList.map{ $0 }
        }
        set {
            if let myTasks = newValue as? RoutineCheckTask {
                myTaskList.removeAll()
                myTaskList.append(myTasks)
            }
        }
    }
    
    convenience init(title: String, dayOfWeeks: List<DayOfWeek>, startDate: Date, endDate: Date? = nil, notificationTime: Date? = nil, myTaskList: List<RoutineCheckTask> = List<RoutineCheckTask>()) {
        self.init()
        self.title = title
        self.dayOfWeeks = dayOfWeeks
        self.startDate = startDate
        self.endDate = endDate
        self.notificationTime = notificationTime
        self.myTaskList = myTaskList
    }
    
    func createTask(date: Date) -> RoutineTask {
        let task = RoutineCheckTask(routine: self, taskDate: date)
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            try realm.write {
                myTaskList.append(task)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return task
    }
    
    func doneTasks() -> [RoutineTask] {
        return myTaskList.filter { task in
            task.isDone
        }
    }
}

final class TextRoutine: Object, Routine {
    @Persisted(primaryKey: true) var identifier: UUID = UUID()
    @Persisted var createTime: Date = Date()
    @Persisted var title: String
    @Persisted var dayOfWeeks: List<DayOfWeek>
    @Persisted var startDate: Date
    @Persisted var endDate: Date?
    @Persisted var notificationTime: Date?
    @Persisted var myTaskList: List<RoutineTextTask>
    var myTasks: [RoutineTask] {
        get {
            return myTaskList.map{ $0 }
        }
        set {
            if let myTasks = newValue as? RoutineTextTask {
                myTaskList.removeAll()
                myTaskList.append(myTasks)
            }
        }
    }
    
    convenience init(title: String, dayOfWeeks: List<DayOfWeek>, startDate: Date, endDate: Date? = nil, notificationTime: Date? = nil, myTaskList: List<RoutineTextTask> = List<RoutineTextTask>()) {
        self.init()
        self.title = title
        self.dayOfWeeks = dayOfWeeks
        self.startDate = startDate
        self.endDate = endDate
        self.notificationTime = notificationTime
        self.myTaskList = myTaskList
    }
    
    func createTask(date: Date) -> RoutineTask {
        let task = RoutineTextTask(routine: self, taskDate: date)
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            try realm.write {
                myTaskList.append(task)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return task
    }
    
    func doneTasks() -> [RoutineTask] {
        return myTaskList.filter { task in
            task.isDone
        }
    }
}

final class CountRoutine: Object, Routine {
    @Persisted(primaryKey: true) var identifier: UUID = UUID()
    @Persisted var createTime: Date = Date()
    @Persisted var title: String
    @Persisted var dayOfWeeks: List<DayOfWeek>
    @Persisted var startDate: Date
    @Persisted var endDate: Date?
    @Persisted var notificationTime: Date?
    @Persisted var myTaskList: List<RoutineCountTask> = List<RoutineCountTask>()
    @Persisted var goal: Int
    var myTasks: [RoutineTask] {
        get {
            return myTaskList.map{ $0 }
        }
        set {
            if let myTasks = newValue as? RoutineCountTask {
                myTaskList.removeAll()
                myTaskList.append(myTasks)
            }
        }
    }
    
    convenience init(title: String, dayOfWeeks: List<DayOfWeek>, startDate: Date, endDate: Date? = nil, notificationTime: Date? = nil, goal: Int) {
        self.init()
        self.title = title
        self.dayOfWeeks = dayOfWeeks
        self.startDate = startDate
        self.endDate = endDate
        self.notificationTime = notificationTime
        self.myTaskList = myTaskList
        self.goal = goal
    }
    
    func createTask(date: Date) -> RoutineTask {
        let task = RoutineCountTask(routine: self, goal: goal, taskDate: date)
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            try realm.write {
                myTaskList.append(task)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return task
    }
    
    func doneTasks() -> [RoutineTask] {
        return myTaskList.filter { task in
            task.isDone
        }
    }
}

protocol RoutineTask: Task {
    var routineIdentifier: UUID { get }
    var identifier: UUID { get }
    var title: String { get set }
    var taskDate: Date { get set }
    var isDone: Bool { get set }
}

final class RoutineCheckTask: EmbeddedObject, RoutineTask {
    @Persisted var routineIdentifier: UUID
    @Persisted var identifier: UUID = UUID()
    @Persisted var title: String
    @Persisted var taskDate: Date
    @Persisted var isDone: Bool = false
    
    convenience init(routine: Routine, taskDate: Date) {
        self.init()
        self.routineIdentifier = routine.identifier
        self.title = routine.title
        self.taskDate = taskDate
    }
}

final class RoutineTextTask: EmbeddedObject, RoutineTask {
    @Persisted var routineIdentifier: UUID
    @Persisted var identifier: UUID = UUID()
    @Persisted var title: String
    @Persisted var taskDate: Date
    @Persisted var isDone: Bool
    @Persisted private var _text: String = ""
    var text: String {
        get {
            return _text
        }
        set {
            do {
                let realm = try Realm(configuration: .defaultConfiguration)
                try realm.write({
                    _text = newValue
                    isDone = false == newValue.isEmpty
                })
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    convenience init(routine: Routine, taskDate: Date, isDone: Bool = false) {
        self.init()
        self.routineIdentifier = routine.identifier
        self.title = routine.title
        self.taskDate = taskDate
    }
}

final class RoutineCountTask: EmbeddedObject, RoutineTask {
    @Persisted var routineIdentifier: UUID
    @Persisted var identifier: UUID = UUID()
    @Persisted var title: String
    @Persisted var taskDate: Date
    @Persisted var isDone: Bool
    @Persisted var goal: Int
    @Persisted private var _count: Int = 0
    var count: Int {
        get {
            return _count
        }
        set {
            do {
                let realm = try Realm(configuration: .defaultConfiguration)
                try realm.write {
                    _count = newValue
                    isDone = goal <= newValue
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    convenience init(routine: Routine, goal: Int, taskDate: Date, count: Int = 0) {
        self.init()
        self.routineIdentifier = routine.identifier
        self.title = routine.title
        self.taskDate = taskDate
        self.goal = goal
    }
}
