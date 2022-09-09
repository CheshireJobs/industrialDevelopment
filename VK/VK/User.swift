import Foundation
import UIKit

protocol UserService {
    func getUser(userLogin: String) -> User?
}

class User {
    var userLogin: String
    var fullName: String
    var photo: String
    var statusString: String
    
    init(userLogin: String, fullName: String, photo: String, statusString: String ) {
        self.userLogin = userLogin
        self.fullName = fullName
        self.photo = photo
        self.statusString = statusString
    }
}

class CurrentUserService: UserService {
    var currentUser: User
    
    init(userLogin: String) {
        currentUser = User(userLogin: userLogin, fullName: "Cheshire Cat", photo: "cheshireCat", statusString: "I'm cheshire cat")
    }
    
    func getUser(userLogin: String) -> User? {
        if userLogin == currentUser.userLogin {
            return currentUser
        } else {
            return nil
        }
    }
    
}
