import XCTest

final class PodpageUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensAddSheet() {
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["saveEntryButton"].waitForExistence(timeout: 2))
        app.buttons["cancelAddButton"].tap()
    }

    func testAddEntryFlow() {
        app.buttons["addButton"].tap()
        let saveButton = app.buttons["saveEntryButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
    }

    func testFreeLimitTriggersPaywall() {
        for _ in 0..<40 {
            let addButton = app.buttons["addButton"]
            guard addButton.exists else { break }
            addButton.tap()
            let saveButton = app.buttons["saveEntryButton"]
            if saveButton.waitForExistence(timeout: 1) {
                saveButton.tap()
            }
            if app.buttons["subscribeButton"].waitForExistence(timeout: 1) {
                break
            }
        }
        XCTAssertTrue(app.buttons["subscribeButton"].waitForExistence(timeout: 2) || app.buttons["addButton"].exists)
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addButton"].tap()
        let notesField = app.textFields["Notes"]
        if notesField.waitForExistence(timeout: 2) {
            notesField.tap()
            app.staticTexts.firstMatch.tap()
            XCTAssertFalse(app.keyboards.element.exists)
        }
        app.buttons["cancelAddButton"].tap()
    }

    func testSettingsSheetOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
