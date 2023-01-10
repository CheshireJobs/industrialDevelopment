import Foundation
import UIKit

final class FeedCoordinator: Coordinator {
    var navigationController = UINavigationController()
    
    func start() {
//        feedViewController.viewModel.onOpenPostButtonTapped = {
//            self.showPost()
//        }
        let feedViewController = ModuleFactory.makeFeedModule()
    
        navigationController.setViewControllers([feedViewController], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "feed".localized, image: UIImage(systemName: "house.circle"), tag: 0)
    }
    
//    func showPost() {
//        let postCoordinator = PostCoordinator(navigationController: navigationController)
//        postCoordinator.start()
//    }
}
