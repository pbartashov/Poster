//
//  SignUpViewView.swift
//  Poster
//
//  Created by Павел Барташов on 09.11.2022.
//

import UIKit
import Combine
import SnapKit

final class SignUpView: SignActionView {

    //MARK: - Properties

    //MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = viewFactory.makeH2Label()
        label.textColor = .brandTextBlackColor
        label.text = "titleLabelSignInView".localized

        return label
    }()

    private lazy var enterNumberLabel: UILabel = {
        let label = viewFactory.makeH3Label()
        label.textColor = .brandLightGray
        label.text = "enterNumberLabelSignInView".localized

        return label
    }()

    private lazy var explainNumberLabel: UILabel = {
        let label = viewFactory.makeSmallTextLabel()
        label.textColor = .brandTextGrayColor
        label.text = "explainNumberLabelSignInView".localized

        return label
    }()

    private lazy var explainButtonLabel: UILabel = {
        let label = viewFactory.makeSmallTextLabel()
        label.textColor = .brandTextGrayColor
        label.text = "explainButtonLabelSignInView".localized

        return label
    }()


    //MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol) {
        super.init(viewFactory: viewFactory, loginButton: LoginButton.next)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        [titleLabel,
         enterNumberLabel,
         explainNumberLabel,
         explainButtonLabel
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(61)
            make.centerX.equalToSuperview()
        }

        enterNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }

        explainNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(enterNumberLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(explainNumberLabel.snp.bottom).offset(ConstantsUI.padding)
            make.leading.equalToSuperview().offset(ConstantsUI.phoneTextFieldPadding)
            make.trailing.equalToSuperview().offset(-ConstantsUI.phoneTextFieldPadding)
            make.height.equalTo(ConstantsUI.phoneTextFieldHeight)
        }

        actionButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }

        explainButtonLabel.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()

            make.bottom.equalToSuperview().offset(-ConstantsUI.padding)
        }
//
//        activityView.snp.makeConstraints { make in
//            make.centerY.equalTo(phoneNumberTextField)
//            make.centerX.equalToSuperview()
//        }
    }
}
