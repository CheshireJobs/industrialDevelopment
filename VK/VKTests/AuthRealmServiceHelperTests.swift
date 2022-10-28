import Foundation
import XCTest

@testable import VK

class AuthRealmServiceHelperTests: XCTestCase {
    var authRealmServiceHelper: AuthRealmServiceHelper!
    var presenter: AuthRealmServicePresenterMock!
    
    override func setUp() {
        super.setUp()
   
        presenter = AuthRealmServicePresenterMock()
        authRealmServiceHelper = AuthRealmServiceHelper(presenter: presenter)
    }
    
    func testCheckCredentials_verifyDisplayProfile() {
        let login = "CheshireSpb@yandex.ru"
        let password = "cheshirespbpassword"
        
        authRealmServiceHelper.checkCredentials(login: login, password: password)
        
        XCTAssertTrue(presenter.didDisplayProfile)
        XCTAssertFalse(presenter.didDisplayErrorAlert)
    }
}

class AuthRealmServicePresenterMock: AuthRealmServicePresenter {
    var didDisplayProfile = false
    var didDisplayErrorAlert = false
    
    func displayProfile(login: String) {
        didDisplayProfile = true
    }
    
    func displayErrorAlert(error: String) {
        didDisplayErrorAlert = true
    }
    
}
