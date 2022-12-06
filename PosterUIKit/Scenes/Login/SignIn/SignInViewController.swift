//
//  SignInViewController.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit
import Combine

final class SignInViewController: ScrollableViewController<LoginViewModelProtocol> {
    
    // MARK: - Views
    
    private lazy var signInView: SignInView = {
        let viewFactory = LoginViewFactory()
        return SignInView(viewFactory: viewFactory)
    }()

    // MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        super.addSubViewToScrollView(signInView)
        bindViewModel()
    }

    private func bindViewModel() {
        signInView.buttonTappedPublisher
            .sink { [weak self] button in
                guard let self = self else { return }
                switch button {
                    case .confirm:
                        let action = LoginAction.authWith(phoneNumber: self.signInView.text)
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
                    self.signInView.isBusy = false
                    switch state {
                        case .initial:
                            break
                            
                        case .missingPhoneNumber, .missingCode:
                            self.signInView.shakeTextField()
                            
                        case .authFailed:
                            self.signInView.shakeActionButton()
                            
                        case .processing:
                            self.signInView.isBusy = true
                    }
                }
            }
            .store(in: &subsriptions)
    }
}
