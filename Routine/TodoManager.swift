//
//  TodoManager.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

class TodoManager {
    static var todoList: [Todo] = []
    var todoCount: Int {
        return TodoManager.todoList.count
    }
    
    func append(_ todo: Todo) {
        TodoManager.todoList.append(todo)
    }
    
    func fecth(_ identifier: UUID) -> Todo? {
        return TodoManager.todoList.first(where: { $0.identifier == identifier })
    }
    
    func fetchAllTask(to date: Date) -> [Task] {
        var tasks = [Task]()
        let calendar = Calendar.current
        TodoManager.todoList.forEach { todo in
            if calendar.isDate(date, equalTo: todo.taskDate, toGranularity: .day) {
                tasks.append(todo)
            }
        }
        return tasks
    }
    
    func remove(_ todo: Todo) {
        TodoManager.todoList.removeAll { $0.identifier == todo.identifier }
    }
}
