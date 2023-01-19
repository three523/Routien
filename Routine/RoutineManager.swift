//
//  RoutineManager.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

class RoutineManager {
    static var routines: [Routine] = []
    var routineCount: Int {
        return RoutineManager.routines.count
    }
    
    func create(_ routine: Routine) {
        RoutineManager.routines.append(routine)
    }
    
    func append(_ task: RoutineTask) {
        guard let index = RoutineManager.routines.firstIndex( where: { $0.identifier == task.routineIdentifier }) else {
            print("Routine does not exist")
            return
        }
        RoutineManager.routines[index].myTaskList.append(task)
    }
    
    func update(_ task: RoutineTask) {
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
    
    func fetch(_ identifier: UUID) -> Routine? {
        return RoutineManager.routines.first(where: { $0.identifier == identifier })
    }
    
    func fetch(routineTask: RoutineTask) -> RoutineTask? {
        guard let routine = RoutineManager.routines.first(where: { $0.identifier == routineTask.routineIdentifier }) else {
            print("routine does not exits")
            return nil
        }
    return routine.myTaskList.first(where: { $0.identifier == routineTask.identifier })
    }
    
    func fetchAllTask(to date: Date) -> [Task] {
        var tasks = [Task]()
        let calendar = Calendar.current
        print(RoutineManager.routines)
        RoutineManager.routines.forEach { routine in
            let routineTask = routine.myTaskList.first( where: { calendar.isDate(date, equalTo: $0.taskDate, toGranularity: .day) })
            tasks.append(routineTask ?? routine.createTask(date: date))
        }
        return tasks
    }
}
