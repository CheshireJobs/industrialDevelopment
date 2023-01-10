import Foundation
import UIKit

final class FavoritesCoordinator: Coordinator {
    var navigationController = UINavigationController()
    
    func start() {
        var viewModel = FavoritesViewModel()
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
    
        navigationController.setViewControllers([favoritesViewController], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "favorites".localized, image: UIImage(systemName: "star.circle.fill"), tag: 0)
    }
}
