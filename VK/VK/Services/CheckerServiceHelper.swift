import Foundation
import FirebaseAuth
import FirebaseCore

protocol CheckerHelperPresenter {
    func signUp()
    func displayErrorAlert(error: String)
}

class CheckerServiceHelper {
    var presenter: CheckerHelperPresenter?
    
    init(presenter: CheckerHelperPresenter?) {
        self.presenter = presenter
    }
    
    func signUp(login: String, password: String) {
        Auth.auth().createUser(withEmail: login, password: password, completion: { (authDataResult, error) in
            if let error = error {
                self.presenter?.displayErrorAlert(error: error.localizedDescription)
            } else if authDataResult != nil {
                self.presenter?.signUp()
           }
        })
    }
}


