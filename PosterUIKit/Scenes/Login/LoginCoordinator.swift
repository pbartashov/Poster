//
//  LiginCoordinator.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit

//protocol LoginSceneSwitcher: AnyObject {
//    func switchToWelcomeScene()
//    func switchToSignUpScene()
//    func switchToConfirmSignUpScene()
//    func switchToSignInScene()
//}

final class LoginCoordinator: NavigationCoordinator, LoginCoordinatorProtocol {

    //MARK: - Properties

    private let switchToMainScene: (User) -> Void
    var dependencyContainer: LoginDependencyContainerProtocol?

    //MARK: - LifeCicle

    init(//navigationController: UINavigationController,
         switchToMainScene: @escaping (User) -> Void
//         dependencyContainer: LoginDependencyContainerProtocol// = LoginDependencyContainer()
    ) {

        self.switchToMainScene = switchToMainScene
//             self.dependencyContainer = dependencyContainer
//        super.init(navigationController: navigationController)
             super.init()
//        self.navigationController = navigationController
    }

    //MARK: - Metods

    func showMainScene(for user: User) {
        switchToMainScene(user)
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

    private func pushViewController(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }


//    func showCreateAccount(for login: String,
//                           completion: (()-> Void)? = nil) {
//
//        let alert = UIAlertController(title: "createAccountPromptTitleLoginCoordinator".localized,
//                                      message: "\("createAccountPromptMessageLoginCoordinator".localized) \(login)?",
//                                      preferredStyle: .alert)
//
//        let yes = UIAlertAction(title: "yesAnswerLoginCoordinator".localized,
//                                style: .default,
//                                handler: { _ in completion?() })
//        let no = UIAlertAction(title: "noAnswerLoginCoordinator".localized,
//                               style: .cancel)
//        alert.addAction(yes)
//        alert.addAction(no)
//
//        navigationController?.present(alert, animated: true)
//    }

    


//    func showNeedBiometricAccess() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            showGoTo(url: url,
//                     dialogTitle: "needBiometricAccessLoginCoordinator".localized,
//                     buttonTitle: "settingsLoginCoordinator".localized)
//        }
//    }
//
//    func showEnrollBiometric() {
//        if let url = URL(string: "App-Prefs:root=TOUCHID_PASSCODE") {
//            showGoTo(url: url,
//                     dialogTitle: "enrollBiometricsLoginCoordinator".localized,
//                     buttonTitle: "settingsLoginCoordinator".localized)
//        }
//    }
//
//    private func showGoTo(url: URL, dialogTitle: String, buttonTitle: String) {
//        let alert = UIAlertController(title: dialogTitle,
//                                      message: nil,
//                                      preferredStyle: .alert)
//
//        let setting = UIAlertAction(title: buttonTitle,
//                                    style: .default) { _ in
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            }
//        }
//
//        let ok = UIAlertAction(title: "cancelLoginCoordinator".localized,
//                               style: .default)
//        [setting, ok].forEach {
//            alert.addAction($0)
//        }
//
//        navigationController?.present(alert, animated: true)
//    }
}
//
//
//extension LoginCoordinator: LoginSceneSwitcher {
//    func switchToWelcomeScene() {
//        let welcomeViewController = dependencyContainer.makeWelcomeViewController()
//
//        navigationController?.pushViewController(welcomeViewController, animated: true)
//    }
//
//    func switchToSignUpScene() {
//
//    }
//
//    func switchToConfirmSignUpScene() {
//
//    }
//
//    func switchToSignInScene() {
//
//    }
//
//
//}
