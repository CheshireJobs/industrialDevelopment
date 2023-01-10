import Foundation
import UIKit

class LoginInspector: CheckerServiceProtocol {
    private(set) var authType: AuthType = .fireBase
    
    private var fireBaseAuthService = FireBaseAuthService.shared
    private var authRealm = AuthRealmService.shared
    
    init(authType: AuthType) {
        self.authType = authType
    }
    
    func signIn(login: String, password: String) -> AuthResponce {
        if authType == .fireBase {
            return fireBaseAuthService.signIn(login: login, password: password)
        } else {
            return authRealm.signIn(login: login, password: password)
        }
    }
    
    func signUp(login: String, password: String) -> AuthResponce {
        if authType == .fireBase {
            return fireBaseAuthService.signUp(login: login, password: password)
        } else {
            return authRealm.signUp(login: login, password: password)
        }
    }
}

extension LoginInspector {
    enum AuthType {
        case fireBase
        case realm
    }
}
