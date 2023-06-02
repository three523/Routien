//
//  Todo.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

class Todo: Task {
    var identifier: UUID = UUID()
    var title: String = ""
    var taskDate: Date = Date()
    var isDone: Bool = false
}
