import Foundation

struct JsonUser {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    
    init(dictionary: [String: Any]) {
        userId = dictionary["userId"] as! Int
        id = dictionary["id"] as! Int
        title = dictionary["title"] as! String
        completed = dictionary["completed"] as! Bool
    }
}
