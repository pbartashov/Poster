//
//  SignUpViewController.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit
import Combine

final class SignUpViewController: SignActionViewController {

    //MARK: - Properties


    //MARK: - Views

    private lazy var signUpView: SignUpView = {
        let viewFactory = LoginViewFactory(textFieldMode: .phoneNumber)
        return SignUpView(viewFactory: viewFactory)
    }()

    //MARK: - LifeCicle

//    init(viewModel: LoginViewModelProtocol) {
//        super.init(viewModel: viewModel)
//    }


    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()



        //        viewModel.perfomAction(.startHintTimer)
        //        viewModel.perfomAction(.autoLogin)
    }


    //MARK: - Metods

    private func initialize() {
        super.addSubView(signUpView)
        setupViewModel()
    }

    private func setupViewModel() {
        buttonTappedSubsription = signUpView.buttonTappedPublisher
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
    }
}
