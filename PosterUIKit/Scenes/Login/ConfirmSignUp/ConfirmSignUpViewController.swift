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
        let viewFactory = LoginViewFactory()
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
        setupViewModel()
    }


    private func setupViewModel() {
        buttonTappedSubsription = confirmSignUpView.buttonTappedPublisher
            .sink { [weak self] button in
                guard let self = self else { return }
                switch button {
                    case .signUp:
                        let action = LoginAction.comfirmPhoneNumberWith(code: self.confirmSignUpView.text)
                        self.viewModel.perfomAction(action)

                    default:
                        return
                }
            }
    }

}
