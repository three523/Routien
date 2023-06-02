//
//  TaskListViewModel.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation
import RealmSwift

final class ListViewModel {
    private let routineManager: RoutineManager = RoutineManager.shared
    private let todoManager: TodoManager = TodoManager()
    var viewUpdate: ()->() = {}
    
    func create<T: Object & Routine>(routine: T) {
        routineManager.create(routine)
        viewUpdate()
    }
    
    func append(routinTask: RoutineTask) {
        routineManager.append(routinTask)
        viewUpdate()
    }
    
    func append(todo: Todo) {
        todoManager.append(todo)
        viewUpdate()
    }
    
    func update<T: Object & Routine>(routine: T.Type, routineTask: RoutineTask) {
        routineManager.update(routineType: routine, routineTask)
        viewUpdate()
    }
    
    func fetch(routineIdentifier: UUID) -> (any Routine)? {
        return routineManager.fetch(routineIdentifier)
    }
    
    func fetchTask(todoIdentifier: UUID) -> Task? {
        return todoManager.fecth(todoIdentifier)
    }
    
    func fetchTask(routineTask: RoutineTask) -> RoutineTask? {
        return routineManager.fetch(routineTask: routineTask)
    }
    
    func fetchAllTask(to date: Date) -> [Task] {
        var tasks = routineManager.fetchAllTask(to: date, isSortAndFilter: true)
        tasks.append(contentsOf: TodoManager.fetchAllTask(to: date))
        return tasks
    }
    
    func delete(routineIdentifier: UUID) {
        routineManager.delete(routineIdentifier: routineIdentifier)
        viewUpdate()
    }
    
    func delete(routineTask: RoutineTask) {
        routineManager.delete(routineTask: routineTask)
        viewUpdate()
    }
    
    func delete(todo: Todo) {
        TodoManager.remove(todo)
        viewUpdate()
    }
}
