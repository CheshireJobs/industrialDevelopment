import Foundation
import UIKit

class LoginInspector: LoginViewControllerDelegate {
    private var checkerService = CheckerService.shared
    
    func checheckCredentials(login: String, password: String, controller: LogInViewController) {
        checkerService.checheckCredentials(login: login, password: password, controller: controller)
    }
    
    func signUp(login: String, password: String,controller: LogInViewController) {
        checkerService.signUp(login: login, password: password, controller: controller)
    }
}
