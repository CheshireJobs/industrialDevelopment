import Foundation

class MyLoginFactory: LoginFactory {
    var authType: LoginInspector.AuthType
    
    init(authType: LoginInspector.AuthType) {
        self.authType = authType
    }
    
    func getLoginInspector() -> LoginInspector {
        return LoginInspector(authType: authType)
    }
}
