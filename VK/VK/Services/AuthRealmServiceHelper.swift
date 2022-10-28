import RealmSwift
import FirebaseAuth

protocol AuthRealmServicePresenter {
    func displayProfile(login: String)
    func displayErrorAlert(error: String)
}

class AuthRealmServiceHelper {
    var presenter: AuthRealmServicePresenter?
    var users: Results<AuthRealmModel>?
    
    init(presenter: AuthRealmServicePresenter?) {
        self.presenter = presenter
        users = AuthRealmService.shared.getUsers()
    }
    
    func checkCredentials(login: String, password: String) {
        guard let user = users?.filter({$0.login == login}).first else {
            presenter?.displayErrorAlert(error: "login_error_text".localized)
            return
        }
         guard user.password == password else {
             presenter?.displayErrorAlert(error: "password_error_text".localized)
            return
        }
        
        presenter?.displayProfile(login: login)
        
        UserDefaults.standard.set(true, forKey: "isAuthorized")
        UserDefaults.standard.set(login, forKey: "userInfo")
    }
}
