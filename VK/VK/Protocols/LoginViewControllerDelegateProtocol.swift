import Foundation
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func checheckCredentials(login: String, password: String, controller: LogInViewController)
    func signUp(login: String, password: String, controller: LogInViewController)
}
