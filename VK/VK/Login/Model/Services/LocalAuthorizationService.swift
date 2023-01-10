import Foundation
import LocalAuthentication

class LocalAuthorizationService {
    static let shared = LocalAuthorizationService()
    
    var context = LAContext()
    var canUseBiometrics = false
    var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    var biometryType: LABiometryType?
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, String) -> Void) {
        var error: NSError?
        
        canUseBiometrics = context.canEvaluatePolicy(policy, error: &error)
        
        if let error = error {
            authorizationFinished(false, error.localizedDescription)
            return
        }
        
        guard canUseBiometrics else {
            authorizationFinished(false, "Что-то пошло не так")
            return
        }
        
        context.evaluatePolicy(policy, localizedReason: "Авторизуйтесь для входа") { success, error in
            if let error = error {
                authorizationFinished(false, error.localizedDescription)
            } else if success {
                authorizationFinished(true, "succces")
            } else {
                authorizationFinished(false, "Что-то пошло не так")
            }
        }
    }
    
    /// Use shared property instead
    private init() {
        var error: NSError?
        context.canEvaluatePolicy(policy, error: &error)
        
        biometryType = context.biometryType
    }
}
