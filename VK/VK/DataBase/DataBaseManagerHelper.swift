import Foundation
import StorageService

protocol PostHandler {
    func alreadyExist()
    func cannotSavePost(error: String)
}

class DataBaseManagerHelper: PostHandler {
    func alreadyExist() {
        print("already exist")
    }
    
    func cannotSavePost(error: String) {
        print(error)
    }
}
