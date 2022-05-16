import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    var post: Post?
    private var model: Model?
    var onOpenPostButtonTapped: (() -> Void)?
    
    private lazy var feedView: FeedView = {
        var view = FeedView()
        view.delegate = self
        return view
    }()
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        post?.title = "Пост"
        NotificationCenter.default.addObserver(self, selector: #selector(setLabel), name: .answerChanged, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    private func setLabel(notification: Notification) {
        if let answer = notification.object as? Bool {
            feedView.setResultLabel(answer: answer)
        }
    }
}

extension FeedViewController: FeedViewDelegate {
    func openPostViewController() {
        onOpenPostButtonTapped?()
    }
    
    func checkWord(word: String) {
        model?.check(word: word)
    }
}
