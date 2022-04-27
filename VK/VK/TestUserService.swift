import Foundation

class TestUserService: UserService {
    private var user = User(userLogin: "testCheshire", fullName: "Steve Jobs", photo: "Jobs", statusString: "I'm Steve Jobs")
    
    func getUser(userLogin: String) -> User? {
        if userLogin == self.user.userLogin {
            return self.user
        } else {
            return nil
        }
    }
}
