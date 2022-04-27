import Foundation

class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return AuthSevice.shared.checkAuthorization(login: login, password: password)
    }
}
