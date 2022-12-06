//
//  LiginCoordinator.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit

final class LoginCoordinator: NavigationCoordinator, LoginCoordinatorProtocol {

    // MARK: - Properties

    private let switchToMainScene: (User) -> Void
    var dependencyContainer: LoginDependencyContainerProtocol?

    // MARK: - LifeCicle

    init(switchToMainScene: @escaping (User) -> Void) {
        self.switchToMainScene = switchToMainScene
        super.init(navigationController: nil)
    }

    // MARK: - Metods

    func showMainScene(for user: User) {
        DispatchQueue.main.async {
            self.switchToMainScene(user)
        }
    }

    func showWelcomeScene() {
        let welcomeViewController = dependencyContainer?.makeWelcomeViewController()
        pushViewController(welcomeViewController)
    }

    func showSignUpScene() {
        let signUpViewController = dependencyContainer?.makeSignUpViewController()
        pushViewController(signUpViewController)
    }

    func showConfirmSignUpScene(for phoneNumber: String) {
        let showConfirmSignUpViewController = dependencyContainer?.makeConfirmSignUpViewController(for: phoneNumber)
        pushViewController(showConfirmSignUpViewController)
    }

    func showSignInScene() {
        let signInViewController = dependencyContainer?.makeSignInViewController()
        pushViewController(signInViewController)
    }
}
