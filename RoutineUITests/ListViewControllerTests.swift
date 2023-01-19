//
//  RoutineUITests.swift
//  RoutineUITests
//
//  Created by 김도현 on 2023/01/19.
//

import XCTest

final class ListViewControllerTests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test셀이_오늘_날짜로_되어있음() throws {
        let cells = app.collectionViews.cells
        let centerCell = cells.element(boundBy: cells.count/2)
        XCTAssertEqual(centerCell.isSelected, true, "오늘 날짜에 맞는 셀이 선택됨")
    }
    
    func test리스트추가버튼_클릭시_새로운_루틴을_추가하는_화면으로_전환됨() {
        app.buttons["리스트 추가 +"].tap()
        XCTAssert(app.staticTexts["루틴 이름"].exists, "루틴 생성 화면으로 넘어가지 못함")
    }
}
