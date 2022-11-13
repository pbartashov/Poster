//
//  WelcomeView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit
import Combine
import SnapKit

final class WelcomeView: ViewWithButton<LoginButton> {

    //MARK: - Properties

    let viewFactory: LoginViewFactory

    //MARK: - Views

    private let logoImageView = UIImageView(image: UIImage(named: "Logo"))

    private lazy var signUpViewButton: UIButton = {
        let action = UIAction(title: LoginButton.signUp.title) { [weak self] _ in
            self?.sendButtonTapped(.signUp)
        }

        return viewFactory.makeFilledButton(action: action)
    }()

    private lazy var signInViewButton: UIButton = {
        let action = UIAction(title: LoginButton.signIn.title) { [weak self] _ in
            self?.sendButtonTapped(.signIn)
        }

        return viewFactory.makePlainButton(action: action)
    }()



    //MARK: - LifeCicle

    init(viewFactory: LoginViewFactory) {
        self.viewFactory = viewFactory
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        [logoImageView,
         signUpViewButton,
         signInViewButton
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
//            make.leading.greaterThanOrEqualToSuperview().offset(Constants.padding)//.priority(.required)
//            make.trailing.greaterThanOrEqualToSuperview().offset(-Constants.padding)//.priority(.required)
            make.height.equalTo(logoImageView.snp.width)//.priority(.high)
        }

        signUpViewButton.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
//            make.leading.trailing.height.equalTo(loginTextField)
        }

        signInViewButton.snp.makeConstraints { make in
            make.top.equalTo(signUpViewButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()

            make.bottom.equalToSuperview().offset(-Constants.padding)
        }
    }
}

