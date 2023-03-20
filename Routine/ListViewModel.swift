//
//  TaskListViewModel.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

final class ListViewModel {
    private let routineManager: RoutineManager = RoutineManager()
    private let todoManager: TodoManager = TodoManager()
    var update: ()->() = {}
    
    func create(routine: Routine) {
        RoutineManager.create(routine)
        update()
    }
    
    func append(routinTask: RoutineTask) {
        RoutineManager.append(routinTask)
        update()
    }
    
    func append(todo: Todo) {
        todoManager.append(todo)
        update()
    }
    
    func fetch(routineIdentifier: UUID) -> Routine? {
        return routineManager.fetch(routineIdentifier)
    }
    
    func fetchTask(todoIdentifier: UUID) -> Task? {
        return todoManager.fecth(todoIdentifier)
    }
    
    func fetchTask(routineTask: RoutineTask) -> RoutineTask? {
        return routineManager.fetch(routineTask: routineTask)
    }
    
    func fetchAllTask(to date: Date) -> [Task] {
        var tasks = RoutineManager.fetchAllTask(to: date)
        tasks.append(contentsOf: TodoManager.fetchAllTask(to: date))
        return tasks
    }
    
    func remove(routine: Routine) {
        RoutineManager.remove(routine: routine)
        update()
    }
    
    func remove(routineTask: RoutineTask) {
        routineManager.remove(routineTask: routineTask)
        update()
    }
    
    func remove(todo: Todo) {
        TodoManager.remove(todo)
        update()
    }
}
