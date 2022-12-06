//
//  AppDependencyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 08.11.2022.
//

import UIKit
import PosterKit

public protocol AppDependencyContainerProtocol: AnyObject {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinatorProtocol

    func makeLoginViewController() -> UIViewController
    func releaseLoginScene()

    func makeMainViewController(for user: User) -> UIViewController
    func releaseMainScene()
}

public final class AppDependencyContainer: AppDependencyContainerProtocol {
    
    // MARK: - Properties

    private var appCoordinator: AppCoordinator?
    private var loginCoordinator: LoginCoordinator?

    private var mainDependancyContainer: MainDependancyContainer?
    private var userService: UserServiceProtocol

    // MARK: - LifeCicle

    public init() {
        let userStorage = UserCloudStorage()
        userService = UserService(userStorage: userStorage)
    }

    // MARK: - Metods

    public func makeAppCoordinator(window: UIWindow) -> AppCoordinatorProtocol {
        let appCoordinator = AppCoordinator(window: window, appDependencyContainer: self)
        self.appCoordinator = appCoordinator

        return appCoordinator
    }

    public func makeLoginViewController() -> UIViewController {
        let switchToMainScene = { [weak self] user -> Void in
            self?.appCoordinator?.switchToMainViewScene(for: user)
        }
        let loginCoordinator = LoginCoordinator(switchToMainScene: switchToMainScene)
        let loginDependencyContainer = LoginDependencyContainer(loginCoordinator: loginCoordinator,
                                                                userService: userService)
        let loginViewController = loginDependencyContainer.makeLoginViewController(loginCoordinator: loginCoordinator)

        loginCoordinator.navigationController = loginViewController
        loginCoordinator.dependencyContainer = loginDependencyContainer
        self.loginCoordinator = loginCoordinator

        return loginViewController
    }

    public func releaseLoginScene() {
        loginCoordinator = nil
    }

    public func makeMainViewController(for user: User) -> UIViewController {
        let mainDependancyContainer = MainDependancyContainer(userService: userService)
        self.mainDependancyContainer = mainDependancyContainer

        return mainDependancyContainer.makeMainViewController(user: user)
    }


    public func releaseMainScene() {
        mainDependancyContainer = nil
    }
}
