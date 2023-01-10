import UIKit
import StorageService

class PostViewController: UIViewController {
    
    var onRightItemBarButtonTapped: (() -> Void)?
    private lazy var rightItemBarButton: UIBarButtonItem = {
        var rightItemBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showInfoViewController))
        return rightItemBarButton
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        onRightItemBarButtonTapped?()
    }
}
