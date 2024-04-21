import Foundation

class LoginViewModel {
    var onStateChanged: ((State) -> Void)?
    var onSuccesLogin: ((String) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private var loginInspector: CheckerServiceProtocol
    private let userDefaults = UserDefaults.standard

    init(loginInspector: CheckerServiceProtocol) {
        self.loginInspector = loginInspector
    }
    
    func send(_ action: Action) {
        switch action {
        case .viewIsReady:
            ()
            
        case .signinButtonTapped(login: let login, password: let password):
            checkCredentials(login: login, password: password)
            state = .checkingCredentials
            
        case .singUpButtonTapped(login: let login, password: let password):
            signUp(login: login, password: password)
            
        case .biometricsButtonTapped:
            LocalAuthorizationService.shared.authorizeIfPossible(biometricsAuthorizationFinished)
        }
    }
    
    func checkCredentials(login: String, password: String) {
        let responce = loginInspector.signIn(login: login, password: password)
        switch responce {
        case .succes:
            userDefaults.set(true, forKey: "isAuthorized")
            userDefaults.set(login, forKey: "userInfo")
            userDefaults.set(password, forKey: "userPassword")
            onSuccesLogin?(login)
            
        case .error(let error):
            state = .error(error)
        }
    }
    
    func signUp(login: String, password: String) {
        let responce = loginInspector.signUp(login: login, password: password)
        switch responce {
        case .succes:
            userDefaults.set(true, forKey: "isAuthorized")
            userDefaults.set(login, forKey: "userInfo")
            userDefaults.set(password, forKey: "userPassword")
            onSuccesLogin?(login)
            
        case .error(let error):
            state = .error(error)
        }
    }
    
    func biometricsAuthorizationFinished(success: Bool, error: String) -> Void {
        DispatchQueue.main.async {
            if success {
                let login = self.userDefaults.string(forKey: "userInfo")
                let password = self.userDefaults.string(forKey: "userPassword")
                
                self.checkCredentials(login: login ?? "error", password: password ?? "error")
                self.state = .checkingCredentials
            } else {
                self.state = .error(error)
            }
        }
    }
}

extension LoginViewModel {
    enum State {
        case initial
        case loading
        case loaded
        case checkingCredentials
        case error(String)
    }
    
    enum Action {
        case viewIsReady
        case signinButtonTapped(login: String, password: String)
        case singUpButtonTapped(login: String, password: String)
        case biometricsButtonTapped
    }
}
