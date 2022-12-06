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
//    func makeLoginCoordinator(rootSceneSwitcher: RootSceneSwitcher?) -> LoginCoordinator
    func makeWelcomeViewController() -> UIViewController
    func makeSignUpViewController() -> UIViewController
    func makeSignInViewController() -> UIViewController
    func makeConfirmSignUpViewController(for phoneNumber: String) -> UIViewController
}

struct LoginDependencyContainer: LoginDependencyContainerProtocol {



    // MARK: - Properties

//    private weak var viewControllerSwitcher: ViewControllerSwitcher?
//    private weak var loginSceneSwitcher: LoginSceneSwitcher?

    private var sharedLoginViewModel: LoginViewModel
    private unowned var userService: UserServiceProtocol

    // MARK: - Views

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
            //                              credentialStorage: CredentialStorageService())
        }

        self.sharedLoginViewModel = makeLoginViewModel()
        self.userService = userService
    }

    // MARK: - Metods

    func makeLoginViewController(loginCoordinator: LoginCoordinatorProtocol) -> UINavigationController {
//        let loginViewModel = makeLoginViewModel(loginCoordinator: loginCoordinator)
        let loginViewController = LoginViewController(viewModel: sharedLoginViewModel)

//        rootLoginViewController.setViewControllers([loginViewController], animated: false)

        ErrorPresenter.shared.initialize(with: loginViewController)

        return loginViewController
    }



//    func makeLoginViewModel(loginCoordinator: LoginCoordinatorProtocol) -> LoginViewModelProtocol {
//        let checker = ChekerService()
//        let loginDelegate = LoginInspector(checker: checker)
//        return LoginViewModel(loginDelegate: loginDelegate,
//                              coordinator: loginCoordinator,
//                              errorPresenter: ErrorPresenter.shared)
//        //                              credentialStorage: CredentialStorageService())
//    }

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

