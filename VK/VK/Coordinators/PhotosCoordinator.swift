import Foundation
import UIKit

final class PhotosCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = PhotosViewModel()
        let photosViewController = PhotosViewController(viewModel: viewModel)
        photosViewController.title = "Photo Gallery"
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}
