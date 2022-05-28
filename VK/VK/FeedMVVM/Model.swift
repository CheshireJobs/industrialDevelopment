import Foundation

class Model {
    private var word = "Password"
    private var answer: Bool? {
        didSet {
            NotificationCenter.default.post(name: .answerChanged, object: answer)
        }
    }
    
    func check(word: String) {
        answer = self.word == word
    }
}

extension NSNotification.Name {
    static var answerChanged: Notification.Name {
        return .init(rawValue: "answerChanged")
    }
}
