//
//  Todo.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

struct Todo: Task {
    var identifier: UUID = UUID()
    var descrpition: String
    var taskDate: Date
    var isDone: Bool = false
}
