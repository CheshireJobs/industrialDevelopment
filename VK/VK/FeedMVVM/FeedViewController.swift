import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    var post: Post?
    var viewModel: FeedViewModel
    
    private lazy var feedView: FeedView = {
        var view = FeedView()
        view.delegate = self
        return view
    }()
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupViewModel()
        post?.title = "Пост"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .initial:
                ()
            case .loadingCheckResult:
                ()
            case let .answerChanged(answer: answer):
                self?.feedView.setResultLabel(answer: answer)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FeedViewController: FeedViewDelegate {
    func checkWord(word: String) {
        viewModel.send(action: .onCheckButtonPressed(word: word))
    }
    
    func openPostViewController() {
        viewModel.send(action: .onPostButtonPressed)
    }
}
