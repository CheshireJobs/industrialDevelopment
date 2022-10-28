import Foundation
import XCTest
import StorageService

@testable import VK

class CheckerServiceTests: XCTestCase {
    var checkerServiceHelper: CheckerServiceHelper!
    var presenter: CheckerServiceHelperMock!
    
    override func setUp() {
        super.setUp()
        
        presenter = CheckerServiceHelperMock()
        checkerServiceHelper = CheckerServiceHelper(presenter: presenter)
    }
    
    func testSavePost_verifyErrorSignUp() {
        let login = "Cheshire2@yandex.ru"
        let password = "cheshirespbpassword"
        
        let expectation = expectation(description: "wait for complition")
        
        checkerServiceHelper.signUp(login: login, password: password)
        
        expectation.fulfill()
        
        XCTAssertFalse(presenter.isSignUp)
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class CheckerServiceHelperMock: CheckerHelperPresenter {
    var isSignUp = true
    
    func signUp() {
        isSignUp = true
    }
    
    func displayErrorAlert(error: String) {
        isSignUp = false
    }
}
