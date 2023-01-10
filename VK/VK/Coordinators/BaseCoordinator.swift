import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol FinishingCoordinator: Coordinator {
    var onFinish: (() -> Void)? {get set}
}

class BaseCoordinator {
    private(set) var childCoorditators: [Coordinator] = []
    
    func addDependency(coordinator: Coordinator) {
        for element in childCoorditators {
            if element === coordinator {
                return
            }
            childCoorditators.append(coordinator)
        }
    }
    
    func removeDependency(coordinator: Coordinator?) {
        guard childCoorditators.isEmpty == false,
              let coordinator = coordinator else {return}
        for (index, element) in childCoorditators.enumerated() {
            if element === coordinator {
                childCoorditators.remove(at: index)
                break
            }
        }
    }
    
    func removeAll() {
        childCoorditators.removeAll()
    }
}


//final class PostCoordinator: Coordinator {
//    var navigationController: UINavigationController?
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let postViewController = PostViewController()
//        postViewController.onRightItemBarButtonTapped = {
//            self.showInfo()
//        }
//        self.navigationController?.pushViewController(postViewController, animated: true)
//    }
//
//    func showInfo() {
//        guard let navigationController = navigationController else {
//            return
//        }
//        let infoCoordinator = InfoCoordinator(navigationController: navigationController)
//        infoCoordinator.start()
//    }
//}
//
//final class InfoCoordinator: Coordinator {
//    var navigationController: UINavigationController?
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let infoViewController = InfoViewController()
//        infoViewController.modalPresentationStyle = .formSheet
//        self.navigationController?.present(infoViewController, animated: true)
//    }
//}
//
//final class MapCoordinator: Coordinator {
//    var navigationController = UINavigationController()
//
//    func start() {
//        let mapViewController = MapViewController()
//
//        navigationController.setViewControllers([mapViewController], animated: false)
//        navigationController.tabBarItem = UITabBarItem(title: "map".localized, image: UIImage(systemName: "map.circle.fill"), tag: 0)
//    }
//}
