//
//  AppDependencyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 08.11.2022.
//

import UIKit
import PosterKit

protocol AppDependencyContainerProtocol {
//    func makeLoginViewController() -> UIViewController
//    func makeLoginCoordinator(loginNavigationController: UINavigationController) -> LoginCoordinatorProtocol
    func makeLoginViewController() -> UIViewController
    func makeMainViewController(for userName: String) -> UIViewController
}

public class AppDependencyContainer: AppDependencyContainerProtocol {
    
    // MARK: - Properties

    private weak var rootSceneSwitcher: RootSceneSwitcher?
    //    private var feedCoordinator: FeedCoordinator?
    private var loginCoordinator: LoginCoordinator?
    //    private var profileCoordinator: ProfileCoordinator?
    //    private var profilePostsCoordinator: PostsCoordinator?
    //    private var favoritesCoordinator: PostsCoordinator?
    // MARK: - Views
    
    // MARK: - LifeCicle

    init(rootSceneSwitcher: RootSceneSwitcher) {
        self.rootSceneSwitcher = rootSceneSwitcher
    }
    
    // MARK: - Metods

    func makeLoginViewController() -> UIViewController {
        let switchToMainScene = { [weak self] userName -> Void in
            self?.rootSceneSwitcher?.switchToMainViewScene(for: userName)
        }
        let loginCoordinator = LoginCoordinator(switchToMainScene: switchToMainScene)
        let loginDependencyContainer = LoginDependencyContainer(loginCoordinator: loginCoordinator)
        let loginViewController = loginDependencyContainer.makeLoginViewController(loginCoordinator: loginCoordinator)

        loginCoordinator.navigationController = loginViewController
        loginCoordinator.dependencyContainer = loginDependencyContainer
        self.loginCoordinator = loginCoordinator

        return loginViewController
    }

//    func makeLoginCoordinator() -> LoginCoordinator {
//        let switchToMainScene = { [weak self] userName -> Void in
//            self?.rootSceneSwitcher?.switchToMainViewScene(for: userName)
//        }
//
//        return LoginCoordinator(switchToMainScene: switchToMainScene)
//    }
//
//    func makeLoginCoordinator(loginNavigationController: UINavigationController) -> LoginCoordinatorProtocol {
//        let switchToMainScene = { [weak self] userName -> Void in
//            self?.viewControllerSwitcher?.switchToMainViewController(for: userName)
//        }
//
//        let loginCoordinator = LoginCoordinator(navigationController: loginNavigationController,
//                                                switchToMainScene: switchToMainScene)
//        return loginCoordinator
//    }
//
//    func makeLoginViewModel() -> LoginViewModelProtocol {
//        let checker = ChekerService()
//        let loginDelegate = LoginInspector(checker: checker)
//        return LoginViewModel(loginDelegate: loginDelegate,
//                              coordinator: loginCoordinator,
//                              errorPresenter: ErrorPresenter.shared)
////                              credentialStorage: CredentialStorageService())
//    }

    func makeMainViewController(for userName: String) -> UIViewController {
//        let feedNavigationController = UINavigationController()
//        feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
//
//        let feedViewController = ViewControllerFactory.create.feedViewController(tag: Tab.feed.index)
//        feedViewController.coordinator = feedCoordinator
//        feedNavigationController.setViewControllers([feedViewController], animated: false)
//
//        let profileNavigationController = UINavigationController()
//        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
//        profilePostsCoordinator = PostsCoordinator(navigationController: profileNavigationController)
//
//        let profileViewController = ViewControllerFactory
//            .create.profileViewController(userName: userName,
//                                          profileCoordinator: profileCoordinator,
//                                          profilePostsCoordinator: profilePostsCoordinator,
//                                          tag: Tab.profile.index)
//        profileNavigationController.setViewControllers([profileViewController], animated: false)
//
//        let favoritesNavigationController = UINavigationController()
//        favoritesCoordinator = PostsCoordinator(navigationController: favoritesNavigationController)
//        let favoritesViewController = ViewControllerFactory
//            .create.favoritesViewController(coordinator: favoritesCoordinator,
//                                            tag: Tab.favorites.index)
//        favoritesNavigationController.setViewControllers([favoritesViewController], animated: false)
//
//        let mapViewController = ViewControllerFactory.create.mapViewController(tag: Tab.map.index)
//
//        let tabBarController = ViewControllerFactory.create.tabBarController(with: [
//            feedNavigationController,
//            profileNavigationController,
//            favoritesNavigationController,
//            mapViewController
//        ])
//
//        ErrorPresenter.shared.initialize(with: tabBarController)
//
//        mainTabController = tabBarController
//
//        return tabBarController

        return UIViewController()
    }
}
