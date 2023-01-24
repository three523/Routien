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
    
    func create(routine: Routine) {
        routineManager.create(routine)
    }
    
    func append(routinTask: RoutineTask) {
        routineManager.append(routinTask)
    }
    
    func append(todo: Todo) {
        todoManager.append(todo)
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
        var tasks = routineManager.fetchAllTask(to: date)
        tasks.append(contentsOf: todoManager.fetchAllTask(to: date))
        return tasks
    }
    
    func remove(routine: Routine) {
        routineManager.remove(routine: routine)
    }
    
    func remove(routineTask: RoutineTask) {
        routineManager.remove(routineTask: routineTask)
    }
    
    func remove(todo: Todo) {
        todoManager.remove(todo)
    }
}
