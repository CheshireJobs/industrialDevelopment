import Foundation
import UIKit

protocol CheckerServiceProtocol {
    func checheckCredentials(login: String, password: String, controller: LogInViewController)
    func signUp(login: String, password: String, controller: LogInViewController)
}
