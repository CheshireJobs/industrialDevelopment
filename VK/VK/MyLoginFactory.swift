import Foundation

class MyLoginFactory: LoginFactory {
    func getLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
    
}
