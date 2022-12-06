//
//  LoginDependencyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit

protocol LoginDependencyContainerProtocol {
    func makeLoginViewController(loginCoordinator: LoginCoordinatorProtocol) -> UINavigationController
    func makeWelcomeViewController() -> UIViewController
    func makeSignUpViewController() -> UIViewController
    func makeSignInViewController() -> UIViewController
    func makeConfirmSignUpViewController(for phoneNumber: String) -> UIViewController
}

struct LoginDependencyContainer: LoginDependencyContainerProtocol {

    // MARK: - Properties

    private var sharedLoginViewModel: LoginViewModel
    private unowned var userService: UserServiceProtocol

    // MARK: - LifeCicle

    init(loginCoordinator: LoginCoordinatorProtocol,
         userService: UserServiceProtocol
    ) {
        func makeLoginViewModel() -> LoginViewModel {
            let checker = ChekerService()
            let loginDelegate = LoginInspector(checker: checker, userService: userService)
            return LoginViewModel(loginDelegate: loginDelegate,
                                  coordinator: loginCoordinator,
                                  errorPresenter: ErrorPresenter.shared)
        }

        self.sharedLoginViewModel = makeLoginViewModel()
        self.userService = userService
    }

    // MARK: - Metods

    func makeLoginViewController(loginCoordinator: LoginCoordinatorProtocol) -> UINavigationController {
        let loginViewController = LoginViewController(viewModel: sharedLoginViewModel)
        ErrorPresenter.shared.initialize(with: loginViewController)

        return loginViewController
    }

    func makeWelcomeViewController() -> UIViewController {
        WelcomeViewController(viewModel: sharedLoginViewModel)
    }

    func makeSignUpViewController() -> UIViewController {
        SignUpViewController(viewModel: sharedLoginViewModel)
    }

    func makeSignInViewController() -> UIViewController {
        SignInViewController(viewModel: sharedLoginViewModel)
    }

    func makeConfirmSignUpViewController(for phoneNumber: String) -> UIViewController {
        ConfirmSignUpViewController(viewModel: sharedLoginViewModel, phoneNumber: phoneNumber)
    }
}
