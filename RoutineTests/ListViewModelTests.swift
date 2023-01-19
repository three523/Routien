//
//  ListViewModelTests.swift
//  RoutineTests
//
//  Created by 김도현 on 2023/01/19.
//

import XCTest
@testable import Routine

final class TaskListViewModelTests: XCTestCase {
    
    var sut: ListViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testRoutine_추가시_정보가_저장됨() {
        let routine = Routine(description: "title")
        sut.create(routine: routine)
        if let fetchRoutine = sut.fetch(routineIdentifier: routine.identifier) {
            XCTAssertEqual(fetchRoutine.identifier, routine.identifier, "루틴이 저장되지 않음")
            return
        }
        XCTAssert(false , "루틴 값이 nil")
    }
    
    func testTodo_추가시_정보가_저장됨() {
        let todo = Todo(descrpition: "Test", taskDate: Date())
        sut.append(todo: todo)
        if let fetchTodo = sut.fetchTask(todoIdentifier: todo.identifier) {
            XCTAssertEqual(fetchTodo.identifier, todo.identifier)
            return
        }
        XCTAssert(false, "투두 값이 nil")
    }
    
    func test루틴_할일_성공시_저장() {
        let routine = Routine(description: "TestRoutine")
        sut.create(routine: routine)
        let routineTask = RoutineTextTask(routine: routine, text: "TestTask", taskDate: Date())
        sut.append(routinTask: routineTask)
        if let fetchTask = sut.fetchTask(routineTask: routineTask) {
            XCTAssertEqual(fetchTask.identifier, routineTask.identifier, "루틴 작업을 제대로 가져오지 못함")
            return
        }
        XCTAssert(false, "루틴 작업이 nil")
    }
    
    func test맞는날짜에_대한_할일들_불러오기() {
        let routine = Routine(description: "TestRoutine")
        sut.create(routine: routine)
        
        let todo = Todo(descrpition: "TestTodo", taskDate: Date())
        sut.append(todo: todo)
        
        let routineTask = RoutineTextTask(routine: routine, text: "TestTask", taskDate: Date())
        sut.append(routinTask: routineTask)
        let tasks = sut.fetchAllTask(to: Date())
        
        XCTAssertEqual(tasks.count, 2, "오늘 해야할 일들을 가져오지 못함")
        XCTAssertEqual(tasks.filter({ $0.identifier == routineTask.identifier }).isEmpty, false, "오늘 할일을 가져오지 못함")
    }
    
    func test오늘_할일을_가져올때_어제_할일을_가져오면_안됨() {
        let routine = Routine(description: "TestRoutine")
        sut.create(routine: routine)
        
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            let yesterdayRoutineTask = RoutineTextTask(routine: routine, text: "TestYesterday", taskDate: yesterday)
            sut.append(routinTask: yesterdayRoutineTask)
        } else {
            XCTAssert(false, "yesterday is nil")
        }
        let fetchTasks = sut.fetchAllTask(to: Date())
        XCTAssertEqual(fetchTasks.count, 0, "오늘 할일만 가져와야 하는데 어제 할일을 가져옴")
    }
    
}
