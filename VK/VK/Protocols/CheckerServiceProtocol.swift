import Foundation
import UIKit

enum AuthResponce {
    case error(String)
    case succes
}

protocol CheckerServiceProtocol {
    func signIn(login: String, password: String) -> AuthResponce
    func signUp(login: String, password: String) -> AuthResponce
}
