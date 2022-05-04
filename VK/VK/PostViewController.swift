import UIKit
import StorageService

class PostViewController: UIViewController {
    
    var post: Post?
    private lazy var rightItemBarButton: UIBarButtonItem = {
        var rightItemBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showInfoViewController))
        return rightItemBarButton
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = post?.title
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = rightItemBarButton
    }
    
}

extension PostViewController {
    @objc
    private func showInfoViewController() {
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .formSheet
        self.navigationController?.present(infoViewController, animated: true)
    }
}
