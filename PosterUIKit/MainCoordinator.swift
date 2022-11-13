//
//  MainCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 08.11.2022.
//

import UIKit

public protocol MainCoordinatorProtocol {
    func start() -> UIViewController
}

protocol RootSceneSwitcher: AnyObject {
    func switchToMainViewScene(for userName: String)

}

//protocol TabNavigatorProtocol: AnyObject {
//    func switchTo(tab: Tab)
//}

public final class MainCoordinator: MainCoordinatorProtocol {

    // MARK: - Properties

    private weak var window: UIWindow?
    private var appDependencyContainer: AppDependencyContainerProtocol!

    // MARK: - LifeCicle

    public init(window: UIWindow) {
        self.window = window

        defer {
            self.appDependencyContainer = AppDependencyContainer(rootSceneSwitcher: self)
        }
    }

    // MARK: - Metods

    public func start() -> UIViewController {
        appDependencyContainer.makeLoginViewController()
    }

    func switchTo(viewController: UIViewController) {
        guard let window = window else { return }

        DispatchQueue.main.async {
            window.rootViewController = viewController
            // add animation
            UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations: nil,
                              completion: nil)
        }
    }
}

extension MainCoordinator: RootSceneSwitcher {
    func switchToMainViewScene(for userName: String) {
        let viewController = appDependencyContainer.makeMainViewController(for: userName)
        switchTo(viewController: viewController)
    }
}
