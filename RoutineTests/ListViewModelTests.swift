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
    var taskCount: Int!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testRoutine_추가시_정보가_저장됨() {
        let routine = CheckRoutine(description: "title", dayOfWeek: DayOfWeek.allCases, startDate: Date())
        sut.create(routine: routine)
        if let fetchRoutine = sut.fetch(routineIdentifier: routine.identifier) {
            XCTAssertEqual(fetchRoutine.identifier, routine.identifier, "루틴이 저장되지 않음")
            sut.remove(routineIdentifier: fetchRoutine.identifier)
            return
        }
        XCTAssert(false , "루틴 값이 nil")
    }
    
    func testTodo_추가시_정보가_저장됨() {
        let todo = Todo(description: "Test", taskDate: Date())
        sut.append(todo: todo)
        if let fetchTodo = sut.fetchTask(todoIdentifier: todo.identifier) {
            XCTAssertEqual(fetchTodo.identifier, todo.identifier)
            sut.remove(todo: todo)
            return
        }
        XCTAssert(false, "투두 값이 nil")
    }
    
    func test루틴_할일_성공시_저장() {
        let routine = CheckRoutine(description: "title", dayOfWeek: DayOfWeek.allCases, startDate: Date())
        sut.create(routine: routine)
        let routineTask = RoutineTextTask(routine: routine, text: "TestTask", taskDate: Date())
        sut.append(routinTask: routineTask)
        if let fetchTask = sut.fetchTask(routineTask: routineTask) {
            XCTAssertEqual(fetchTask.identifier, routineTask.identifier, "루틴 작업을 제대로 가져오지 못함")
            sut.remove(routineIdentifier: fetchTask.routineIdentifier)
            return
        }
        XCTAssert(false, "루틴 작업이 nil")
    }
    
    func test맞는날짜에_대한_할일들_불러오기() {
        var taskCount = 0
        guard let weekDay = Date().weekDay else {
            XCTAssert(false, "오늘 요일을 가져오지 못함")
            return
        }
        
        var routines: [Routine] = []
        routines.append(CheckRoutine(description: "title", dayOfWeek: DayOfWeek.allCases, startDate: Date()))
        routines.append(CheckRoutine(description: "title", dayOfWeek: [.mon, .wed, .fir], startDate: Date()))
        routines.append(CheckRoutine(description: "title", dayOfWeek: [.tue, .thu], startDate: Date()))
        
        routines.forEach { routine in
            sut.create(routine: routine)
        }
        taskCount += routines.compactMap { routine in
            routine.dayOfWeek.first(where: { $0 == weekDay })
        }.count
        
        let todo = Todo(description: "TestTodo", taskDate: Date())
        sut.append(todo: todo)
        
        taskCount += 1
        
        let listViewModelTasks = sut.fetchAllTask(to: Date())
        let taskFilter = listViewModelTasks.filter { $0.taskDate.weekDay == weekDay }
        print(taskFilter)
        XCTAssertEqual(taskCount, taskFilter.count, "원하는 요일에 맞는 일을 가져오지 못함")
    }
    
}
