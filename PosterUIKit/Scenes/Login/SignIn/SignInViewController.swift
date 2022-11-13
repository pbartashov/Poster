//
//  SignInViewController.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import PosterKit
import Combine

final class SignInViewController: SignActionViewController {
    
    //MARK: - Properties

    //MARK: - Views
    
    private lazy var signInView: SignInView = {
        let viewFactory = LoginViewFactory(textFieldMode: .phoneNumber)
        return SignInView(viewFactory: viewFactory)
   }()
    

    //MARK: - LifeCicle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        


        //        viewModel.perfomAction(.startHintTimer)
        //        viewModel.perfomAction(.autoLogin)
    }
    

    //MARK: - Metods

    private func initialize() {
        super.addSubView(signInView)
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
                    self?.signInView.isBusy = false
                    switch state {
                        case .initial:
                            break
                            
                        case .missingPhoneNumber, .missingCode:
                            self?.signInView.shakeTextField()
                            
                        case .authFailed:
                            self?.signInView.shakeActionButton()
                            
                        case .processing:
                            self?.signInView.isBusy = true
                    }
                }
            }
            .store(in: &subsriptions)
    }
}
