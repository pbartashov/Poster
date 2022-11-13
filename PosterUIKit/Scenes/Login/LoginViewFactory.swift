//
//  LoginViewFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit

struct LoginViewFactory {

    enum TextFieldMode {
        case `default`
        case phoneNumber
    }

    // MARK: - Properties

    let textFieldMode: TextFieldMode

    // MARK: - Views

    // MARK: - LifeCicle

    init(textFieldMode: TextFieldMode = .default) {
        self.textFieldMode = textFieldMode
    }

    // MARK: - Metods




    // MARK: - Buttons

    //    func button(withTitle title: String) -> ClosureBasedButton {
    //        let button = ClosureBasedButton(title: title,
    //                                        titleColor: .lightTextColor,
    //                                        backgroundColor: .systemBlue)
    //
    //        button.layer.cornerRadius = 14
    //
    //        button.layer.shadowOffset = .init(width: 4, height: 4)
    //        button.layer.shadowRadius = 4
    //        button.layer.shadowColor = UIColor.shadowColor.cgColor
    //        button.layer.shadowOpacity = 0.7
    //
    //        return button
    //    }

    func makeFilledButton(action: UIAction?) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .brandTextBlackColor
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.buttonVerticalPadding,
            leading: Constants.buttonHorizontalPadding,
            bottom: Constants.buttonVerticalPadding,
            trailing: Constants.buttonHorizontalPadding
        )

        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .fixed

        return UIButton(configuration: configuration, primaryAction: action)
    }

    func makePlainButton(action: UIAction?) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .brandTextBlackColor

        return UIButton(configuration: configuration, primaryAction: action)
    }

    // MARK: - Labels

    func makeH2Label() -> UILabel {
        let label = UILabel()
        label.font = .brandH2Font
        label.textAlignment = .center

        return label
    }

    func makeH3Label() -> UILabel {
        let label = UILabel()
        label.font = .brandH3Font
        label.textAlignment = .center

        return label
    }

    func makeTextLabel() -> UILabel {
        let label = UILabel()
        label.font = .brandTextFont
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeBoldTextLabel() -> UILabel {
        let label = UILabel()
        label.font = .brandBoldTextFont
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeSmallTextLabel() -> UILabel {
        let label = UILabel()
        label.font = .brandSmallTextFont
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }



    func makeTextField() -> UITextField {
        let textField: UITextField

        switch textFieldMode {
            case .default:
                textField = UITextField()

            case .phoneNumber:
                textField = PhoneTextField()
                textField.keyboardType = .phonePad
        }

        textField.layer.borderColor = UIColor.brandTextBlackColor.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true

//        textField.backgroundColor = .backgroundColor
        textField.textColor = .brandTextGrayColor
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none

        textField.textAlignment = .center

        

//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
//        textField.rightView = paddingView
//        textField.rightViewMode = .always

        return textField
    }
}
