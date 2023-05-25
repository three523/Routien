//
//  RoutineManager.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation
import UserNotifications

enum SortType: String {
    case createTimeAscending = "생성시간순(오름차순)"
    case createTimeDescending = "생성시간순(내림차순)"
    case textAscending = "글자순(오름차순)"
    case textDescending = "글자순(내림차순)"
    case notificationTimeAscending = "알람시간순(오름차순)"
    case notificationTimeDescending = "알람시간순(내림차순)"
    
    static let allCase: [SortType] = [.createTimeAscending, .createTimeDescending, .notificationTimeAscending, .notificationTimeDescending, .textAscending, .textDescending]
}

enum FilterType: String {
    case none = "모두 보기"
    case unDoneRoutine = "완료되지 않은 루틴만 보기"
    case doneRoutine = "완료된 루틴만 보기"
    
    static let allCase: [FilterType] = [.none, .doneRoutine, .unDoneRoutine]
}

class RoutineManager {
    static var routines: [Routine] = []
    static var arrayViewUpdates: [() -> Void] = []
    
    static var sortType: SortType = .createTimeAscending {
        didSet {
            viewUpdate()
        }
    }
    
    static var filterType: FilterType = .none {
        didSet {
            viewUpdate()
        }
    }
    
    var routineCount: Int {
        return RoutineManager.routines.count
    }
    
    static func viewUpdate() {
        RoutineManager.arrayViewUpdates.forEach { viewUpdate in
            viewUpdate()
        }
    }
    
    static func create(_ routine: Routine) {
        RoutineManager.routines.append(routine)
        viewUpdate()
    }
    
    static func append(_ task: RoutineTask) {
        guard let index = RoutineManager.routines.firstIndex( where: { $0.identifier == task.routineIdentifier }) else {
            print("Routine does not exist")
            return
        }
        let isExist = RoutineManager.routines[index].myTaskList.contains { $0.identifier == task.identifier }
        if isExist {
            RoutineManager.update(task)
            return
        }
        RoutineManager.routines[index].myTaskList.append(task)
        viewUpdate()
    }
    
    static func update(_ task: RoutineTask) {
        guard let routineIndex = RoutineManager.routines.firstIndex( where: { $0.identifier == task.routineIdentifier }) else {
            print("Routine does not exist")
            return
        }
        let myTaskList = RoutineManager.routines[routineIndex].myTaskList
        guard let taskIndex = myTaskList.firstIndex(where: { $0.identifier == task.identifier }) else {
            print("RoutineTask does not exist")
            return
        }
        RoutineManager.routines[routineIndex].myTaskList[taskIndex] = task
        viewUpdate()
    }
    
    static func update(_ routine: Routine) {
        guard let routineIndex = RoutineManager.routines.firstIndex(where: { $0.identifier == routine.identifier }) else { return }
        //MARK: 완료한 루틴 이전의 내용도 바꿀것인지 현재 내용만 바꿀것인지, 특정날 이후로만 바꿀 것인지 선택 가능하게 하기
        RoutineManager.routines[routineIndex] = routine
        RoutineManager.routines[routineIndex].allDoneTaskUpdate()
        viewUpdate()
    }
    
    static func fetch(_ identifier: UUID) -> Routine? {
        return RoutineManager.routines.first(where: { $0.identifier == identifier })
    }
    
    func fetch(routineTask: RoutineTask) -> RoutineTask? {
        guard let routine = RoutineManager.routines.first(where: { $0.identifier == routineTask.routineIdentifier }) else {
            print("routine does not exits")
            return nil
        }
        return routine.myTaskList.first(where: { $0.identifier == routineTask.identifier })
    }
    
    static func fetchAllTask(to date: Date, isSortAndFilter: Bool) -> [Task] {
        var routines = RoutineManager.routines
        var tasks = [Task]()
        let calendar = Calendar.current
        if isSortAndFilter { routines = sorted(routines: routines) }
        for index in 0..<RoutineManager.routines.count {
            if let routineTask = routines[index].myTaskList.first(where: { calendar.isDate(date, equalTo: $0.taskDate, toGranularity: .day) }) {
                tasks.append(routineTask)
            } else if let newRoutineTask = routines[index].getTask(date: date) {
                tasks.append(newRoutineTask)
            }
        }
        if isSortAndFilter { tasks = filter(tasks: tasks) }
        return tasks
    }
    
    static private func sorted(routines: [Routine]) -> [Routine] {
        switch RoutineManager.sortType {
        case .createTimeAscending:
            return routines.sorted{ $0.createTime < $1.createTime }
        case .createTimeDescending:
            return routines.sorted{ $0.createTime > $1.createTime }
        case .notificationTimeAscending:
            return routines.sorted{ routine1, routine2 in
                guard let date1 = routine1.notificationTime else { return true }
                guard let date2 = routine2.notificationTime else { return false }
                return date1 < date2
            }
        case .notificationTimeDescending:
            return routines.sorted{ routine1, routine2 in
                guard let date1 = routine1.notificationTime else { return true }
                guard let date2 = routine2.notificationTime else { return false }
                return date1 > date2
            }
        case .textAscending:
            return routines.sorted{ $0.description < $1.description }
        case .textDescending:
            return routines.sorted{ $0.description > $1.description }
        }
    }
    
    static private func filter(tasks: [Task]) -> [Task] {
        switch RoutineManager.filterType {
        case .none:
            return tasks
        case .doneRoutine:
            return tasks.filter{ $0.isDone }
        case .unDoneRoutine:
            return tasks.filter{ false == $0.isDone }
        }
    }
        
    static func remove(routineIdentifier: UUID) {
        RoutineManager.routines.removeAll { $0.identifier == routineIdentifier }
        viewUpdate()
    }
    
    func remove(routineTask: RoutineTask) {
        for (index, routine) in RoutineManager.routines.enumerated() where routine.identifier == routineTask.routineIdentifier {
            RoutineManager.routines[index].myTaskList.removeAll { $0.identifier == routineTask.identifier }
            return
        }
    }
}
