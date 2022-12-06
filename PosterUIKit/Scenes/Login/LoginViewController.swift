//
//  LoginViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit
import PosterKit

final class LoginViewController<T: LoginViewModelProtocol>: UINavigationController {

    typealias ViewModelType = T

    // MARK: - Properties

    private var viewModel: ViewModelType

    // MARK: - Views

    // MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        setupViewModel()

        viewModel.perfomAction(.start)
    }

    // MARK: - Metods

    private func setupViewModel() {
        //        viewModel.stateChanged = { [weak self] state in
        //            DispatchQueue.main.async {
        //                self?.loginView.isBusy = false
        //
        //                switch state {
        //                    case .initial:
        //                        break
        //                    case .missingLogin:
        //                        self?.loginView.shakeLoginTextField()
        //
        //                    case .wrongPassword:
        //                        self?.loginView.shakePasswordTextField()
        //
        //                    case .authFailed:
        //                        self?.loginView.shakeSignInButton()
        //
        //                    case let .processing(login, password):
        //                        self?.loginView.isBusy = true
        //                        self?.loginView.login = login
        //                        self?.loginView.password = password
        //
        //                    case .bruteForceFinishedWith(password: let password):
        //                        self?.loginView.finishBrutePassword(with: password)
        //
        //                    case .bruteForceCancelled:
        //                        self?.loginView.cancelBrutePassword()
        //
        //                    case .bruteForceProgress(password: let password):
        //                        self?.loginView.updateBruteProgress(with: password)
        //                }
        //            }
        //        }
    }
}
