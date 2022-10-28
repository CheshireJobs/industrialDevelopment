import Foundation
import XCTest
import StorageService

@testable import VK

class DataBaseManagerTests: XCTestCase {
    var dataBaseManager: DataBaseManager = DataBaseManager.shared
    var handler: DataBaseManagerHandlerMock!
    
    override func setUp() {
        super.setUp()
        
        handler = DataBaseManagerHandlerMock()
        dataBaseManager.dataBaseManagerHelper = handler
    }
    
    func testSavePost_verifyPostAlradyExist() {
        var post = MyPost(author: "Elon Mask", image: "teslaBot", likes: 999, views: 222, description: "Это будет компаньон-помощник человека в повседневных делах. Его первая версия не сможет работать на производстве из-за определенных ограничений. Робот будет обучен с помощью ИИ выполнять полезные задачи в домашней среде людей или на улице, в том числе брать на себя опасные, повторяющиеся и скучные задания — ловить кошку, ходить в магазин, встречать курьера.")
        
        dataBaseManager.saveToFavorites(post: post)
        
        XCTAssertTrue(handler.isAlradyExist)
        XCTAssertFalse(handler.wasNotAdded)
    }
    
    func testSavePost_verifyPostDoesntExist() {
        var post = MyPost(author: "Chesrire Cat", image: "cheshireCat", likes: 19567, views: 10, description: "Понимать меня необязательно. Обязательно любить и кормить вовремя.")
        
        dataBaseManager.saveToFavorites(post: post)
        
        XCTAssertFalse(handler.isAlradyExist)
        XCTAssertFalse(handler.wasNotAdded)
    }
}

class DataBaseManagerHandlerMock: PostHandler {
    var isAlradyExist = false
    var wasNotAdded = false
    
    func alreadyExist() {
        isAlradyExist = true
    }
    
    func cannotSavePost(error: String) {
        wasNotAdded = true
    }
}
