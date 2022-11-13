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
        setupViewModel()
    }
    

    private func setupViewModel() {
        buttonTappedSubsription = signInView.buttonTappedPublisher
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
    }

}
