import Foundation
import UIKit

final class ProfileCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var userService: UserService
    var userLogin: String
    var onExitTapped: (() -> Void)?
    
    init(userService: UserService, userLogin: String) {
        self.userService = userService
        self.userLogin = userLogin
    }
    
    func start() {
        let profileViewModel = ProfileViewModel(userService: userService, userLogin: userLogin)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        
        profileViewModel.onPhotosRowSelected = {
            self.showPhotos()
        }
        profileViewModel.onExitTapped = {
            self.onExitTapped?()
        }
        
        self.navigationController.setViewControllers([profileViewController] , animated: true)
        navigationController.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(systemName: "person.circle"), tag: 1)
    }
    
    func showPhotos() {
        let photosCoordinator = PhotosCoordinator(navigationController: navigationController)
        photosCoordinator.start()
    }
}
