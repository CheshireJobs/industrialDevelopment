import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    var post: Post?
    private var model: Model?
    
    private lazy var feedView: FeedView = {
        var view = FeedView()
        view.delegate = self
        return view
    }()
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setLabel), name: .answerChanged, object: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        post?.title = "Пост"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        let postViewController = PostViewController()
        postViewController.post = post
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func checkWord(word: String) {
        model?.check(word: word)
    }
}
