import Foundation
import UIKit

final class LoginCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var startMainFlow: ((String) -> Void)?
    
    func start() {
        let myLoginFactory = MyLoginFactory(authType: .realm)
        
        let viewModel = LoginViewModel(loginInspector: myLoginFactory.getLoginInspector())
        viewModel.onSuccesLogin = { login in
            self.startMainFlow?(login)
        }
        let loginViewController = LogInViewController(viewModel: viewModel)
        
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}
