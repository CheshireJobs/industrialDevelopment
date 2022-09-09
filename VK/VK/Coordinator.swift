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

class ApplicationCoordinator: BaseCoordinator, Coordinator {
    private var tabBarController = UITabBarController()
    private var window: UIWindow?
    private var scene: UIWindowScene
    
    init(scene: UIWindowScene) {
        self.scene = scene
        super.init()
    }
    
    func start() {
        initWindow()
        startMainFlow()
    }
    
    private func initWindow() {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func startMainFlow() {
        let feedCoordinator = FeedCoordinator()
        let loginCoordinator = loginCoordinator()
        addDependency(coordinator: feedCoordinator)
        addDependency(coordinator: loginCoordinator)
        
        tabBarController.viewControllers = [feedCoordinator.navigationController, loginCoordinator.navigationController]
        
        feedCoordinator.start()
        loginCoordinator.start()
    }
}
 
final class FeedCoordinator: Coordinator {
    var navigationController = UINavigationController()
    
    func start() {
        let feedViewController = ModuleFactory.makeFeedModule()
        feedViewController.viewModel.onOpenPostButtonTapped = {
            self.showPost()
        }
    
        navigationController.setViewControllers([feedViewController], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.circle"), tag: 0)
    }
    
    func showPost() {
        let postCoordinator = PostCoordinator(navigationController: navigationController)
        postCoordinator.start()
    }
}

final class loginCoordinator: Coordinator {
    var navigationController = UINavigationController()
    
    func start() {
        let loginViewController = LogInViewController()
        loginViewController.onLoginButtonTapped = { (userService, login) in
            self.showProfile(userService: userService, login: login)
        }
        let myLoginFactory = MyLoginFactory()
        loginViewController.delegate = myLoginFactory.getLoginInspector()
        navigationController.setViewControllers([loginViewController], animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        if UserDefaults.standard.bool(forKey: "isAuthorized") {
            let userInfo = UserDefaults.standard.string(forKey: "userInfo")
            let currentUserService = CurrentUserService(userLogin: userInfo ?? "error")
            showProfile(userService: currentUserService, login: userInfo ?? "error")
        }
    }
    
    func showProfile(userService: UserService, login: String) {
        let profileCoordinator = ProfileCoordinator(navogationController: navigationController, userService: userService, userLogin: login)
        profileCoordinator.start()
    }
}

final class PostCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let postViewController = PostViewController()
        postViewController.onRightItemBarButtonTapped = {
            self.showInfo()
        }
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func showInfo() {
        guard let navigationController = navigationController else {
            return
        }
        let infoCoordinator = InfoCoordinator(navigationController: navigationController)
        infoCoordinator.start()
    }
}

final class InfoCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .formSheet
        self.navigationController?.present(infoViewController, animated: true)
    }
}

final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var userService: UserService
    var userLogin: String
    
    init(navogationController: UINavigationController, userService: UserService, userLogin: String) {
        self.navigationController = navogationController
        self.userService = userService
        self.userLogin = userLogin
    }
    
    func start() {
        let profileViewController = ProfileViewController(userService: userService, userLogin: userLogin)
        profileViewController.onPhotosRowSelected = {
            self.showPhotos()
        }
        self.navigationController?.pushViewController(profileViewController , animated: true)
    }
    
    func showPhotos() {
        guard let navigationController = navigationController else {
            return
        }
        let photosCoordinator = PhotosCoordinator(navigationController: navigationController)
        photosCoordinator.start()
    }
}

final class PhotosCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let photosViewController = PhotosViewController()
        photosViewController.title = "Photo Gallery"
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}
