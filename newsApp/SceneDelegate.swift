//
//  SceneDelegate.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        let networkManager = NewsAPIManger()
        let userDefaultManager = UserDefaultManager()
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
        
        
        let headlinesSceneNavigationController = UINavigationController()
        let headlinesSceneViewController = HeadlinesSceneViewController(
            headlinesSceneViewModel: .init(
                navigator: HeadlinesSceneNavigator(
                    navigator: headlinesSceneNavigationController
                ),
                networkManager: networkManager,
                userDefaultManager: userDefaultManager
            )
        )
        headlinesSceneNavigationController.pushViewController(headlinesSceneViewController, animated: false)
        headlinesSceneNavigationController.tabBarItem = .init(title: "Headlines", image: UIImage(systemName: "doc.plaintext"), tag: 0)
        
        let sourceSceneViewController = UINavigationController(rootViewController: SourceSceneViewController()) 
        sourceSceneViewController.tabBarItem = .init(title: "Sources", image: UIImage(systemName: "book"), tag: 1)
        
        let savedSceneNavigationController = UINavigationController()
        let savedSceneViewController = SavedSceneViewController(
            savedSceneViewModel: .init(
                navigator: HeadlinesSceneNavigator(
                    navigator: savedSceneNavigationController
                ),
                userDefaultManager: userDefaultManager
            )
        )
        savedSceneNavigationController.pushViewController(savedSceneViewController, animated: false)
        savedSceneViewController.tabBarItem = .init(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 2)
        
        tabBarController.viewControllers = [
            headlinesSceneNavigationController,
            sourceSceneViewController,
            savedSceneNavigationController
        ]
        
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

