//
//  AppDependencyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 08.11.2022.
//

import UIKit
import PosterKit

public protocol AppDependencyContainerProtocol: AnyObject {
//    func makeLoginViewController() -> UIViewController
//    func makeLoginCoordinator(loginNavigationController: UINavigationController) -> LoginCoordinatorProtocol
    func makeAppCoordinator(window: UIWindow) -> AppCoordinatorProtocol

    func makeLoginViewController() -> UIViewController
    func releaseLoginScene()

    func makeMainViewController(for userName: String) -> UIViewController
}

public final class AppDependencyContainer: AppDependencyContainerProtocol {
    
    // MARK: - Properties

//    private weak var rootSceneSwitcher: RootSceneSwitcher?
    private var appCoordinator: AppCoordinator?
    //    private var feedCoordinator: FeedCoordinator?
    private var loginCoordinator: LoginCoordinator?
    //    private var profileCoordinator: ProfileCoordinator?
    //    private var profilePostsCoordinator: PostsCoordinator?
    //    private var favoritesCoordinator: PostsCoordinator?

    private var mainDependancyContainer: MainDependancyContainer?
    // MARK: - Views
    
    // MARK: - LifeCicle

    public init() {
        
    }

//    init(rootSceneSwitcher: RootSceneSwitcher) {
//        self.rootSceneSwitcher = rootSceneSwitcher
//    }
    
    // MARK: - Metods

    public func makeAppCoordinator(window: UIWindow) -> AppCoordinatorProtocol {
        let appCoordinator = AppCoordinator(window: window, appDependencyContainer: self)
        self.appCoordinator = appCoordinator

        return appCoordinator
    }

    public func makeLoginViewController() -> UIViewController {
        let switchToMainScene = { [weak self] userName -> Void in
            self?.appCoordinator?.switchToMainViewScene(for: userName)
        }
        let loginCoordinator = LoginCoordinator(switchToMainScene: switchToMainScene)
        let loginDependencyContainer = LoginDependencyContainer(loginCoordinator: loginCoordinator)
        let loginViewController = loginDependencyContainer.makeLoginViewController(loginCoordinator: loginCoordinator)

        loginCoordinator.navigationController = loginViewController
        loginCoordinator.dependencyContainer = loginDependencyContainer
        self.loginCoordinator = loginCoordinator

        return loginViewController
    }

    public func releaseLoginScene() {
        loginCoordinator = nil
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

    public func makeMainViewController(for userName: String) -> UIViewController {
        let mainDependancyContainer = MainDependancyContainer()
        self.mainDependancyContainer = mainDependancyContainer

        return mainDependancyContainer.makeMainViewController(userName: userName)
    }


    func releaseMainScene() {
//        mainCoordinator = nil
    }
}
