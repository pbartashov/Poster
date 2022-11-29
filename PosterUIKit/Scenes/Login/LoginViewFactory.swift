//
//  LoginViewFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit

struct LoginViewFactory: ViewFactoryProtocol {




    // MARK: - Properties

    let viewFactory: ViewFactory

    // MARK: - Views

    // MARK: - LifeCicle

    init(viewFactory: ViewFactory = ViewFactory()) {
        self.viewFactory = viewFactory
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
        viewFactory.makeFilledButton(action: action)
    }

    func makePlainButton(action: UIAction?) -> UIButton {
        viewFactory.makePlainButton(action: action)
    }

    // MARK: - Labels

    func makeH2Label() -> UILabel {
        viewFactory.makeH2Label()
    }

    func makeH3Label() -> UILabel {
        viewFactory.makeH3Label()
    }

    func makeTextLabel() -> UILabel {
        viewFactory.makeTextLabel()
    }

    func makeBoldTextLabel() -> UILabel {
        viewFactory.makeBoldTextLabel()
    }

    func makeSmallTextLabel() -> UILabel {
        viewFactory.makeSmallTextLabel()
    }

    func makeTextField() -> UITextField {
        let phoneTextField = PhoneTextField()
        let textField = viewFactory.configured(textField: phoneTextField)
        textField.keyboardType = .phonePad

        return textField
    }

    func makeImagedLabel(imageSystemName: String) -> ImagedLabel {
        viewFactory.makeImagedLabel(imageSystemName: imageSystemName)
    }

    func makeLabeledTextField(label: String, placeholder: String?) -> LabeledView<UITextField> {
        viewFactory.makeLabeledPhoneField(label: label, placeholder: placeholder)
    }

    func makeLabeledPhoneField(label: String, placeholder: String?) -> LabeledView<UITextField> {
        viewFactory.makeLabeledPhoneField(label: label, placeholder: placeholder)
    }
}
