import Foundation
import UIKit

final class AuthSevice: CheckAuthorization {
    static let shared = AuthSevice()
    
    private let login = "Cheshire"
    private let password = "MyPassword"
    
    func checkAuthorization(login: String, password: String) -> Bool {
        if login.hash == self.login.hash && password.hash == self.password.hash {
            return true
        } else {
            return false
        }
    }
    
    /// Use shared property instead
    private init() {}
}
