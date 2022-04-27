import Foundation

protocol CheckAuthorization {
    func checkAuthorization(login: String, password: String) -> Bool
}
