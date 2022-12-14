//
//  SignUpViewController.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit
import Combine

final class SignUpViewController: ScrollableViewController<LoginViewModelProtocol> {

    // MARK: - Views

    private lazy var signUpView: SignUpView = {
        let viewFactory = LoginViewFactory()
        return SignUpView(viewFactory: viewFactory)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        super.addSubViewToScrollView(signUpView)
        bindViewModel()
    }

    private func bindViewModel() {
        signUpView.buttonTappedPublisher
            .sink { [weak self] button in
                guard let self = self else { return }
                switch button {
                    case .next:
                        let action = LoginAction.signUpWith(phoneNumber: self.signUpView.text)
                        self.viewModel.perfomAction(action)

                    default:
                        return
                }
            }
            .store(in: &subsriptions)

        viewModel.statePublisher
            .sink { [weak self] state in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.signUpView.isBusy = false
                    switch state {
                        case .initial:
                            break

                        case .missingPhoneNumber, .missingCode:
                            self.signUpView.shakeTextField()

                        case .authFailed:
                            self.signUpView.shakeActionButton()

                        case .processing:
                            self.signUpView.isBusy = true
                    }
                }
            }
            .store(in: &subsriptions)
    }
}
