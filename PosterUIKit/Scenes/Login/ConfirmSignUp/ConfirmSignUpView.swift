//
//  ConfirmSignUpView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 13.11.2022.
//

import UIKit
import Combine
import SnapKit

final class ConfirmSignUpView: SignActionView {

    //MARK: - Properties

    var phoneNumber: String {
        get {
            phoneNumberLabel.text ?? ""
        }
        set {
            phoneNumberLabel.text = newValue
        }
    }

    //MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = viewFactory.makeH2Label()
        label.textColor = .brandYellowColor
        label.text = "titleLabelConfirmSignUpView".localized

        return label
    }()

    private lazy var explainLabel: UILabel = {
        let label = viewFactory.makeTextLabel()
        label.textColor = .brandTextBlackColor
        label.text = "explainLabelConfirmSignUpView".localized

        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = viewFactory.makeBoldTextLabel()
        label.textColor = .brandTextBlackColor

        return label
    }()

    private lazy var enterCodeLabel: UILabel = {
        let label = viewFactory.makeSmallTextLabel()
        label.textColor = .brandTextGrayColor
        label.textAlignment = .left
        label.text = "enterCodeLabelConfirmSignUpView".localized

        return label
    }()

    private let logoImageView = UIImageView(image: UIImage(named: "CheckMark"))


    //MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol) {
        super.init(viewFactory: viewFactory, loginButton: LoginButton.signUp)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        [titleLabel,
         explainLabel,
         phoneNumberLabel,
         enterCodeLabel,
         logoImageView
        ].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }

        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.UI.padding)
            make.centerX.equalToSuperview()
        }

        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        enterCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(118)
            make.leading.equalToSuperview().offset(Constants.UI.phoneTextFieldPadding)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(enterCodeLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(Constants.UI.phoneTextFieldPadding)
            make.trailing.equalToSuperview().offset(-Constants.UI.phoneTextFieldPadding)
            make.height.equalTo(Constants.UI.phoneTextFieldHeight)
        }

        actionButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(86)
            make.centerX.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(43)
            make.centerX.equalToSuperview()

            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
        }
    }
}

