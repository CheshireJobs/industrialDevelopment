import Foundation
import UIKit

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
        
        if UserDefaults.standard.bool(forKey: "isAuthorized") {
            let userInfo = UserDefaults.standard.string(forKey: "userInfo")
            startMainFlow(userLogin: userInfo ?? "error")
        } else {
            startLoginFlow()
        }
    }
    
    private func initWindow() {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func startLoginFlow() {
        let loginCoordinator = LoginCoordinator()
        
        loginCoordinator.startMainFlow = { login in
            self.startMainFlow(userLogin: login)
        }
        addDependency(coordinator: loginCoordinator)
        
        tabBarController.viewControllers = [loginCoordinator.navigationController]
        loginCoordinator.start()
    }
    
    private func startMainFlow(userLogin: String) {
        let feedCoordinator = FeedCoordinator()
        
        let userService = CurrentUserService(userLogin: userLogin)
        let profileCoordinator = ProfileCoordinator(userService: userService, userLogin: userLogin)
        
        let favoritesCoordinator = FavoritesCoordinator()
        
        profileCoordinator.onExitTapped = {
            self.startLoginFlow()
        }
        
        addDependency(coordinator: feedCoordinator)
        addDependency(coordinator: profileCoordinator)
        addDependency(coordinator: favoritesCoordinator)

        tabBarController.viewControllers = [feedCoordinator.navigationController, profileCoordinator.navigationController, favoritesCoordinator.navigationController]
        
        feedCoordinator.start()
        profileCoordinator.start()
        favoritesCoordinator.start()
    }
}
