//
//  MainCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 08.11.2022.
//

import UIKit
import PosterKit

public protocol AppCoordinatorProtocol {
    func start() -> UIViewController
}

protocol RootSceneSwitcher: AnyObject {
    func switchToMainViewScene(for user: User)
    
}

public final class AppCoordinator: AppCoordinatorProtocol {
    
    // MARK: - Properties
    
    private weak var window: UIWindow?
    private unowned var appDependencyContainer: AppDependencyContainerProtocol
    
    // MARK: - LifeCicle
    
    public init(window: UIWindow,
                appDependencyContainer: AppDependencyContainerProtocol) {
        self.window = window
        self.appDependencyContainer = appDependencyContainer
    }
    
    // MARK: - Metods
    
    public func start() -> UIViewController {
        appDependencyContainer.makeLoginViewController()
    }
    
    func switchTo(viewController: UIViewController) {
        guard let window = window else { return }
        
        window.rootViewController = viewController
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
    }
}

extension AppCoordinator: RootSceneSwitcher {
    func switchToMainViewScene(for user: User) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let viewController = self.appDependencyContainer.makeMainViewController(for: user)
            self.switchTo(viewController: viewController)
            self.appDependencyContainer.releaseLoginScene()
        }
    }
}
