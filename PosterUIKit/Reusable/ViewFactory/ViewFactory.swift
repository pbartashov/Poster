//
//  ViewFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit

protocol ViewFactoryProtocol {
    func makeFilledButton(action: UIAction?) -> UIButton
    func makePlainButton(action: UIAction?) -> UIButton

    func makeH2Label() -> UILabel
    func makeH3Label() -> UILabel
    func makeTextLabel() -> UILabel
    func makeBoldTextLabel() -> UILabel
    func makeSmallTextLabel() -> UILabel

    func makeTextField() -> UITextField

    func makeImagedLabel(imageSystemName: String) -> ImagedLabel
    func makeLabeledTextField(label: String, placeholder: String?) -> LabeledView<UITextField>
    func makeLabeledPhoneField(label: String, placeholder: String?) -> LabeledView<UITextField>
}

//extension ViewFactoryProtocol {
//    func makeTextField(textField: UITextField = UITextField()) -> UITextField {
//        makeTextField(textField: textField)
//    }
//}

struct ViewFactory: ViewFactoryProtocol {



    // MARK: - Properties


    // MARK: - Views

    // MARK: - LifeCicle

//    init(textFieldMode: TextFieldMode = .default) {
//        self.textFieldMode = textFieldMode
//    }

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
            top: Constants.UI.buttonVerticalPadding,
            leading: Constants.UI.buttonHorizontalPadding,
            bottom: Constants.UI.buttonVerticalPadding,
            trailing: Constants.UI.buttonHorizontalPadding
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
        let textField = UITextField()
        return configured(textField: textField)
    }

    func configured(textField: UITextField) -> UITextField {
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

    func makeImagedLabel(imageSystemName: String) -> ImagedLabel {
        let label = makeTextLabel()

        let image = UIImage(systemName: imageSystemName)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .brandTextBlackColor

        return ImagedLabel(imageView: imageView, label: label, spacing: Constants.UI.smallPadding)
    }

    func makeLabeledTextField(label: String, placeholder: String?) -> LabeledView<UITextField> {
        makeLabeledTextField(with: TextFieldWithPadding(), label: label, placeholder: placeholder)
    }

    func makeLabeledPhoneField(label: String, placeholder: String?) -> LabeledView<UITextField> {
        makeLabeledTextField(with: PhoneTextField(), label: label, placeholder: placeholder)
    }

    private func makeLabeledTextField(with textField: TextFieldWithPadding,
                                      label: String,
                                      placeholder: String?
    ) -> LabeledView<UITextField> {
        let labelView = makeBoldTextLabel()
        labelView.text = label
        labelView.textAlignment = .left

        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.backgroundColor = .backgroundGrayColor
        textField.placeholder = placeholder
        textField.textPadding = UIEdgeInsets(top: Constants.UI.padding / 2,
                                             left: Constants.UI.padding,
                                             bottom: Constants.UI.padding / 2,
                                             right: Constants.UI.padding)

        return LabeledView(label: labelView, view: textField, spacing: Constants.UI.smallPadding)
    }
}

