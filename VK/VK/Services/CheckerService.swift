import Foundation
import FirebaseAuth
import FirebaseCore

class CheckerService: CheckerServiceProtocol {
    static let shared = CheckerService()
    var checkerServiceHelper: CheckerServiceHelper?
    
    func checheckCredentials(login: String, password: String, controller: LogInViewController) {
        Auth.auth().signIn(withEmail: login, password: password, completion: { (authResult, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Sign in error", message: error.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
                alertController.addAction(cancelAction)
                controller.present(alertController, animated: true, completion: nil)
                print(error.localizedDescription)
            } else if let authResult = authResult {
                 print(authResult)
                let currentUserService = CurrentUserService(userLogin: login)
                if  Auth.auth().currentUser != nil {
                    controller.onLoginButtonTapped?(currentUserService, login)
                }
            }
        })
    }
    
    func signUp(login: String, password: String, controller: LogInViewController) {
        checkerServiceHelper = CheckerServiceHelper(presenter: controller)
        
        checkerServiceHelper?.signUp(login: login, password: password)
    }
    
    /// Use shared property instead
    private init() {}
}
