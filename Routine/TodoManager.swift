//
//  TodoManager.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

class TodoManager {
    private var todoList: [Todo] = []
    var todoCount: Int {
        return todoList.count
    }
    
    func append(_ todo: Todo) {
        todoList.append(todo)
    }
    
    func fecth(_ identifier: UUID) -> Todo? {
        return todoList.first(where: { $0.identifier == identifier })
    }
    
    func fetchAllTask(to date: Date) -> [Task] {
        var tasks = [Task]()
        let calendar = Calendar.current
        todoList.forEach { todo in
            if calendar.isDate(date, equalTo: todo.taskDate, toGranularity: .day) {
                tasks.append(todo)
            }
        }
        return tasks
    }
}
