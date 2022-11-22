//
//  SignInViewView.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import Combine
import SnapKit

final class SignInView: SignActionView {

    //MARK: - Properties


    //MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = viewFactory.makeH2Label()
        label.textColor = .brandYellowColor
        label.text = "titleLabelSignUpView".localized
        
        return label
    }()

    private lazy var enterNumberLabel: UILabel = {
        let label = viewFactory.makeH3Label()
        label.textColor = .brandTextBlackColor
        label.numberOfLines = 0
        label.text = "enterNumberLabelSignUpView".localized

        return label
    }()


   

    //MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol) {
        super.init(viewFactory: viewFactory, loginButton: LoginButton.confirm)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        [titleLabel,
         enterNumberLabel
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(177)
            make.centerX.equalToSuperview()
        }

        enterNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(enterNumberLabel.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.phoneTextFieldPadding)
            make.trailing.equalToSuperview().offset(-Constants.UI.phoneTextFieldPadding)
            make.height.equalTo(Constants.UI.phoneTextFieldHeight)
        }

        actionButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(70)
            make.centerX.equalToSuperview()

            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
        }
    }
}
