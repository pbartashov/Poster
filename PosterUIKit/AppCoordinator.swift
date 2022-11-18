//
//  MainCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 08.11.2022.
//

import UIKit

public protocol AppCoordinatorProtocol {
    func start() -> UIViewController
}

protocol RootSceneSwitcher: AnyObject {
    func switchToMainViewScene(for userName: String)

}

//protocol TabNavigatorProtocol: AnyObject {
//    func switchTo(tab: Tab)
//}

public final class AppCoordinator: AppCoordinatorProtocol {

    // MARK: - Properties

    private weak var window: UIWindow?
    private unowned var appDependencyContainer: AppDependencyContainerProtocol

    // MARK: - LifeCicle

    public init(window: UIWindow,
                appDependencyContainer: AppDependencyContainerProtocol) {
        self.window = window
        self.appDependencyContainer = appDependencyContainer
//
//        defer {
//            self.appDependencyContainer = AppDependencyContainer(rootSceneSwitcher: self)
//        }
    }

    // MARK: - Metods

    public func start() -> UIViewController {
//        appDependencyContainer.makeLoginViewController()
        appDependencyContainer.makeMainViewController(for: "rwre")
    }

    func switchTo(viewController: UIViewController) {
        guard let window = window else { return }

        window.rootViewController = viewController
        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
    }
}

extension AppCoordinator: RootSceneSwitcher {
    func switchToMainViewScene(for userName: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let viewController = self.appDependencyContainer.makeMainViewController(for: userName)
            self.switchTo(viewController: viewController)
            self.appDependencyContainer.releaseLoginScene()
        }
    }
}
