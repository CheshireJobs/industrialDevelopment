import Foundation
import UIKit

final class AuthSevice: CheckAuthorization {
    static let shared = AuthSevice()
    
    private let login = "Cheshire"
    private let password = "MyPassword"
    
    func checkAuthorization(login: String, password: String) -> Bool {
        return login.hash == self.login.hash && password.hash == self.password.hash
    }
    
    /// Use shared property instead
    private init() {}
}
