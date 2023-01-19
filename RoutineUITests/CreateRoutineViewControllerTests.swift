//
//  CreateRoutineViewControllerTests.swift
//  Routine
//
//  Created by 김도현 on 2023/01/19.
//

import XCTest

final class CreateRoutineViewControllerTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
        app.buttons["리스트 추가 +"].tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_루틴_제목을_입력해야_저장버튼이_활성화됨() {
        let doneButton = app.buttons["완료"]
        let afterButton = app.buttons["리스트 추가 +"]
        XCTAssertFalse(afterButton.exists, "루탄 제목을 입력안해도 저장 버튼 활성화")
        let textfield = app.textFields["나의 루틴을 입력해주세요."]
        textfield.tap()
        app.typeText("Test")
        doneButton.tap()
        XCTAssert(afterButton.exists, "루틴 제목을 입력해도 저장 버튼이 활성화 되지 않음")
    }
}
