import Foundation
import RealmSwift
import KeychainAccess

final class AuthRealmService {
    static let shared = AuthRealmService()
    
    private let userDefaults = UserDefaults.standard
    
    func signUp(login: String, password: String, controller: LogInViewController) {
        let authModel = AuthRealmModel()
        authModel.login = login
        authModel.password = password
        
        let configuration = Realm.Configuration(encryptionKey: getKey() as Data)
        let realm = try? Realm(configuration: configuration)
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
        let configuration = Realm.Configuration(encryptionKey: getKey() as Data)
        let realm = try? Realm(configuration: configuration)
        guard let users: Results<AuthRealmModel> = { realm?.objects(AuthRealmModel.self) }() else { fatalError() }
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
        
    private func getKey() -> NSData {
        let keychainIdentifier = "com.cheshireJobs.VK"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }

        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")

        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")

        return keyData
    }
    
    /// Use shared property instead
    private init() {
    }
}
