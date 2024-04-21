import Foundation
import FirebaseAuth
import FirebaseCore

class FireBaseAuthService: CheckerServiceProtocol { // FireBaseAuth
    static let shared = FireBaseAuthService()
    
    func signIn(login: String, password: String) -> AuthResponce {
        Auth.auth().signIn(withEmail: login, password: password, completion: { (authResult, error) in
            if let error = error {
//                let alertController = UIAlertController(title: "Sign in error", message: error.localizedDescription, preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
//                alertController.addAction(cancelAction)
//                controller.present(alertController, animated: true, completion: nil)
                print(error.localizedDescription)
                
            } else if let authResult = authResult {
                 print(authResult)
//                let currentUserService = CurrentUserService(userLogin: login)
                if  Auth.auth().currentUser != nil {
//                    controller.onLoginButtonTapped?(currentUserService, login)
                }
            }
        })
        
        return .succes
    }
    
    func signUp(login: String, password: String) -> AuthResponce {
        Auth.auth().createUser(withEmail: login, password: password, completion: { (authDataResult, error) in
            if let error = error {
//                let alertController = UIAlertController(title: "Sign up error", message: error.localizedDescription, preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
//                alertController.addAction(cancelAction)
//                controller.present(alertController, animated: true, completion: nil)
                print(error.localizedDescription)
            } else if let authDataResult = authDataResult {
                print(authDataResult)
           }
        })
        
        return .succes
    }
    
    /// Use shared property instead
    private init() {}
}
