import RealmSwift

class AuthRealmModel: Object {
    @Persisted var login: String = ""
    @Persisted var password: String = ""
}
