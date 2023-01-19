//
//  Task.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import Foundation

protocol Task {
    var identifier: UUID { get }
    var descrpition: String { get }
    var taskDate: Date { get set }
    var isDone: Bool { get set }
}
