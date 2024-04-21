import Foundation
import UIKit

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
