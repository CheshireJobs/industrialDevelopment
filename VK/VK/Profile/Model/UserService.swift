import Foundation

protocol UserService {
    func getUser(userLogin: String) -> User?
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
