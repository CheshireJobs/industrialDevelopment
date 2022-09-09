import Foundation
import RealmSwift

final class AuthRealmService {
    static let shared = AuthRealmService()
    
    private let userDefaults = UserDefaults.standard
    
    func signUp(login: String, password: String, controller: LogInViewController) {
        let authModel = AuthRealmModel()
        authModel.login = login
        authModel.password = password
        
        let realm = try? Realm()
        do {
            try? realm?.write {
                realm?.add(authModel)
            }
            userDefaults.set(true, forKey: "isAuthorized")
            userDefaults.set(login, forKey: "userInfo")
            let currentUserService = CurrentUserService(userLogin: login)
            controller.onLoginButtonTapped?(currentUserService, login)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signIn(login: String, password: String, controller: LogInViewController) {
        let realm = try? Realm()
        let users: Results<AuthRealmModel> = { realm?.objects(AuthRealmModel.self) }()!
        guard let user = users.filter({$0.login == login }).first else {
            let alertController = UIAlertController(title: "Sign ip error", message: "Пользователя с таким логином не существует", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
            alertController.addAction(cancelAction)
            controller.present(alertController, animated: true, completion: nil)
            return
        }
         guard user.password == password else {
            let alertController = UIAlertController(title: "Sign ip error", message: "Неверный пароль", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
            alertController.addAction(cancelAction)
            controller.present(alertController, animated: true, completion: nil)
            return
        }
        let currentUserService = CurrentUserService(userLogin: login)
        controller.onLoginButtonTapped?(currentUserService, login)
        userDefaults.set(true, forKey: "isAuthorized")
        userDefaults.set(login, forKey: "userInfo")
        
    }
    
    func signOut() {
        userDefaults.set(false, forKey: "isAuthorized")
        userDefaults.removeObject(forKey: "userInfo")
    }
    
    /// Use shared property instead
    private init() {}
}
