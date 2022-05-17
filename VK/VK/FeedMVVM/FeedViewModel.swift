import Foundation

final class FeedViewModel {
    
    private var model: Model?
    var onStateChanged: ((State) -> Void)?
    var onOpenPostButtonTapped: (() -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    init(model: Model) {
        self.model = model
        
        NotificationCenter.default.addObserver(self, selector: #selector(answerChanged), name: .answerChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func send(action: Action) {
        switch action {
        case let .onCheckButtonPressed(word):
            state = .loadingCheckResult
            model?.check(word: word)
        case .onPostButtonPressed:
            onOpenPostButtonTapped?()
        }
    }
}

extension FeedViewModel {
    enum Action {
        case onCheckButtonPressed(word: String)
        case onPostButtonPressed
    }
    
    enum State {
        case initial
        case loadingCheckResult
        case answerChanged(answer: Bool)
    }
    
    @objc
    private func answerChanged(notification: Notification) {
        guard let answer = notification.object as? Bool else {
            return
        }
        state = .answerChanged(answer: answer)
    }
}
