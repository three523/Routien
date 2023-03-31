//
//  RoutineManager.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

class RoutineManager {
    static var routines: [Routine] = [] {
        didSet {
            RoutineManager.update()
        }
    }
    static var update: () -> Void = {}
    var routineCount: Int {
        return RoutineManager.routines.count
    }
    
    static func create(_ routine: Routine) {
        RoutineManager.routines.append(routine)
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
    }
    
    static func update(_ routine: Routine) {
        guard let routineIndex = RoutineManager.routines.firstIndex(where: { $0.identifier == routine.identifier }) else { return }
        //MARK: 완료한 루틴 이전의 내용도 바꿀것인지 현재 내용만 바꿀것인지, 특정날 이후로만 바꿀 것인지 선택 가능하게 하기
        RoutineManager.routines[routineIndex] = routine
        RoutineManager.routines[routineIndex].allDoneTaskUpdate()
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
    
    static func fetchAllTask(to date: Date) -> [Task] {
        var tasks = [Task]()
        let calendar = Calendar.current
        for index in 0..<RoutineManager.routines.count {
            if let routineTask = RoutineManager.routines[index].myTaskList.first(where: { calendar.isDate(date, equalTo: $0.taskDate, toGranularity: .day) }) {
                tasks.append(routineTask)
            } else if let newRoutineTask = RoutineManager.routines[index].createTask(date: date) {
                tasks.append(newRoutineTask)
            }
        }
        return tasks
    }
    
    static func remove(routineIdentifier: UUID) {
        RoutineManager.routines.removeAll { $0.identifier == routineIdentifier }
    }
    
    func remove(routineTask: RoutineTask) {
        for (index, routine) in RoutineManager.routines.enumerated() where routine.identifier == routineTask.routineIdentifier {
            RoutineManager.routines[index].myTaskList.removeAll { $0.identifier == routineTask.identifier }
            return
        }
    }
}
