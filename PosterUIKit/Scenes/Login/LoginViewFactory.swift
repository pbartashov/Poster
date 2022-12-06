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

    // MARK: - LifeCicle

    init(viewFactory: ViewFactory = ViewFactory()) {
        self.viewFactory = viewFactory
    }

    // MARK: - Buttons

    func makeBlackFilledButton(action: UIAction?) -> UIButton {
        viewFactory.makeBlackFilledButton(action: action)
    }

    func makeYellowFilledButton(action: UIAction?) -> UIButton {
        viewFactory.makeYellowFilledButton(action: action)
    }

    func makePlainButton(action: UIAction?) -> UIButton {
        viewFactory.makePlainButton(action: action)
    }

    func makeVerticalPlainButton(action: UIAction?) -> UIButton {
        viewFactory.makeVerticalPlainButton(action: action)
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

    // MARK: - UITextFields

    func makeTextField() -> UITextField {
        let phoneTextField = PhoneTextField()
        let textField = viewFactory.configured(textField: phoneTextField)
        textField.keyboardType = .phonePad

        return textField
    }

    // MARK: - ImagedLabels

    func makeImagedLabel(imageSystemName: String) -> ImagedLabel {
        viewFactory.makeImagedLabel(imageSystemName: imageSystemName)
    }

    // MARK: - LabeledViews
    
    func makeLabeledTextField(label: String, placeholder: String?) -> LabeledView<UITextField> {
        viewFactory.makeLabeledPhoneField(label: label, placeholder: placeholder)
    }

    func makeLabeledPhoneField(label: String, placeholder: String?) -> LabeledView<UITextField> {
        viewFactory.makeLabeledPhoneField(label: label, placeholder: placeholder)
    }

    // MARK: - UITextViews
    
    func makeTextView() -> UITextView {
        viewFactory.makeTextView()
    }

    // MARK: - UIImageViews

    func makeImageView() -> UIImageView {
        viewFactory.makeImageView()
    }

    // MARK: - ImagePickerViews

    func makeAvatarPickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView {
        viewFactory.makeAvatarPickerView(delegate: delegate)
    }

    func makePostImagePickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView {
        viewFactory.makePostImagePickerView(delegate: delegate)
    }

    // MARK: - UIActivityIndicatorView

    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        viewFactory.makeActivityIndicatorView()
    }

    // MARK: - UIViews

    func makeContainerView() -> UIView {
        viewFactory.makeContainerView()
    }
}

