//
//  ConfirmSignUpViewController.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 13.11.2022.
//

import UIKit
import PosterKit
import Combine

final class ConfirmSignUpViewController: SignActionViewController {

    //MARK: - Properties

    let phoneNumber: String

    //MARK: - Views

    private lazy var confirmSignUpView: ConfirmSignUpView = {
        let viewFactory = ViewFactory()
        return ConfirmSignUpView(viewFactory: viewFactory)
    }()


    //MARK: - LifeCicle

    init(viewModel: LoginViewModelProtocol,
         phoneNumber: String) {
        self.phoneNumber = phoneNumber

        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        confirmSignUpView.phoneNumber = phoneNumber
    }


    //MARK: - Metods

    private func initialize() {
        super.addSubView(confirmSignUpView)
        bindViewModel()
    }

    private func bindViewModel() {
        confirmSignUpView.buttonTappedPublisher
            .sink { [weak self] button in
                guard let self = self else { return }
                switch button {
                    case .signUp:
                        let phoneNumberAndCode = (phoneNumber: self.phoneNumber, code: self.confirmSignUpView.text)
                        let action = LoginAction.comfirm(phoneNumberAndCode)
                        self.viewModel.perfomAction(action)

                    default:
                        return
                }
            }
            .store(in: &subsriptions)

        viewModel.statePublisher
            .sink { [weak self] state in
                DispatchQueue.main.async {
                    self?.confirmSignUpView.isBusy = false
                    switch state {
                        case .initial:
                            break
                            
                        case .missingPhoneNumber, .missingCode:
                            self?.confirmSignUpView.shakeTextField()
                            
                        case .authFailed:
                            self?.confirmSignUpView.shakeActionButton()
                            
                        case .processing:
                            self?.confirmSignUpView.isBusy = true
                    }
                }
            }
            .store(in: &subsriptions)
    }

}
