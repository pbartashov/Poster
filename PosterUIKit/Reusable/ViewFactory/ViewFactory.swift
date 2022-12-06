//
//  ViewFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit

protocol ViewFactoryProtocol {
    func makeBlackFilledButton(action: UIAction?) -> UIButton
    func makeYellowFilledButton(action: UIAction?) -> UIButton
    func makePlainButton(action: UIAction?) -> UIButton
    func makeVerticalPlainButton(action: UIAction?) -> UIButton

    func makeH2Label() -> UILabel
    func makeH3Label() -> UILabel
    func makeTextLabel() -> UILabel
    func makeBoldTextLabel() -> UILabel
    func makeSmallTextLabel() -> UILabel

    func makeTextField() -> UITextField
    func makeTextView() -> UITextView

    func makeImagedLabel(imageSystemName: String) -> ImagedLabel
    func makeLabeledTextField(label: String, placeholder: String?) -> LabeledView<UITextField>
    func makeLabeledPhoneField(label: String, placeholder: String?) -> LabeledView<UITextField>

    func makeContainerView() -> UIView
    func makeImageView() -> UIImageView
    func makePostImagePickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView
    func makeAvatarPickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView

    func makeActivityIndicatorView() -> UIActivityIndicatorView
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

    func makeBlackFilledButton(action: UIAction?) -> UIButton {
        makeFilledButton(action: action, backGroundColor: .brandTextBlackColor)
    }

    func makeYellowFilledButton(action: UIAction?) -> UIButton {
        makeFilledButton(action: action, backGroundColor: .brandYellowColor)
    }

    private func makeFilledButton(action: UIAction?, backGroundColor: UIColor) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = backGroundColor
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.UI.buttonVerticalPadding,
            leading: Constants.UI.buttonHorizontalPadding,
            bottom: Constants.UI.buttonVerticalPadding,
            trailing: Constants.UI.buttonHorizontalPadding
        )

        configuration.background.cornerRadius = Constants.UI.cornerRadius
        configuration.cornerStyle = .fixed

        return UIButton(configuration: configuration, primaryAction: action)
    }

    func makePlainButton(action: UIAction?) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.baseForegroundColor = button.isHighlighted ?
                .brandYellowColor : .brandTextBlackColor
            button.configuration = config
        }

        return button
    }

    func makeVerticalPlainButton(action: UIAction?) -> UIButton {
        var configuration = UIButton.Configuration.plain()
//        configuration.contentInsets = NSDirectionalEdgeInsets(
//            top: Constants.UI.buttonVerticalPadding,
//            leading: Constants.UI.buttonHorizontalPadding,
//            bottom: Constants.UI.buttonVerticalPadding,
//            trailing: Constants.UI.buttonHorizontalPadding
//        )

//        configuration.background.backgroundColor = .yellow



        configuration.baseForegroundColor = .brandTextBlackColor
        configuration.background.cornerRadius = Constants.UI.cornerRadius
        configuration.cornerStyle = .fixed
        configuration.imagePadding = Constants.UI.padding
        configuration.imagePlacement = .top

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

    // MARK: - ImagedLabels

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
        textField.backgroundColor = .brandBackgroundGrayColor
        textField.placeholder = placeholder
        textField.textPadding = UIEdgeInsets(top: Constants.UI.padding / 2,
                                             left: Constants.UI.padding,
                                             bottom: Constants.UI.padding / 2,
                                             right: Constants.UI.padding)

        return LabeledView(label: labelView, view: textField, spacing: Constants.UI.smallPadding)
    }

    // MARK: - UITextViews

    func makeTextView() -> UITextView {
        let textview = UITextView()
        textview.isScrollEnabled = false;
        textview.font = .brandTextFont
        textview.layer.cornerRadius = Constants.UI.cornerRadius
        textview.layer.masksToBounds = true
        
        return textview
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.UI.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.brandYellowColor.cgColor
        imageView.layer.borderWidth = 1

        return imageView
    }

    // MARK: - ImagePickerViews

    func makeAvatarPickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView {
        let imagePickerView = makeImagePickerView(delegate: delegate)
//        imagePickerView.clearButtonOffset = 15
        imagePickerView.text = "tapImageLabelUserProfileView".localized

        return imagePickerView
    }

    func makePostImagePickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView {
        let imagePickerView = makeImagePickerView(delegate: delegate)
        imagePickerView.cornerRadius = .fixed(Constants.UI.cornerRadius)
        imagePickerView.clearButtonOffset = 15
        imagePickerView.clearButtonBackgroundColor = .brandBackgroundGrayColor
        imagePickerView.text = "tapImageLabelDetailedPostViewController".localized

        return imagePickerView
    }

    private func makeImagePickerView(delegate: ImagePickerViewDelegate?) -> ImagePickerView {
        let imagePickerView = ImagePickerView(delegate: delegate,
                                              foregroundColor: .brandYellowColor)
        imagePickerView.font = .brandSmallTextFont

        return imagePickerView
    }

    // MARK: - UIActivityIndicatorView

    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        activity.isHidden = true
        activity.color = .brandYellowColor

        return activity
    }
}

extension ViewFactory: UserInfoViewFactory {
    func makeAuthorNameLabel() -> UILabel {
        let label = makeH3Label()
        label.textAlignment = .left

        return label
    }

    func makeAuthorStatusLabel() -> UILabel {
        let label = makeSmallTextLabel()
        label.textAlignment = .left
        label.textColor = .brandTextGrayColor

        return label
    }

    func makeContainerView() -> UIView {
        let view = UIView()
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / 500
        view.layer.sublayerTransform = transform3D

        return view
    }
}
