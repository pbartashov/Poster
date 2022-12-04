//
//  UserProfileView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 28.11.2022.
//

import UIKit
import Combine
import SnapKit
import PosterKit

//enum SaveCancelButton {
//    case save
//    case cancel
////    case avatar
//}

final class UserProfileView: UIView {
//    ViewWithButton<SaveCancelButton> {

    // MARK: - Properties

//    private let dateFormatter: DateFormatter

    private weak var imagePickerViewDelegate: ImagePickerViewDelegate?

    let viewFactory: ViewFactoryProtocol

    var datePlaceHolder: String? {
        get { birthDateView.view.placeholder }
        set { birthDateView.view.placeholder = newValue }
    }

    var gender: Gender?

    var firstName: String? {
        get { firstNameView.view.text }
        set { firstNameView.view.text = newValue }
    }

    var lastName: String? {
        get { lastNameView.view.text }
        set { lastNameView.view.text = newValue }
    }

    var phoneNumber: String? {
        get { phoneNumberView.view.text }
        set { phoneNumberView.view.text = newValue }
    }

    var status: String? {
        get { statusView.view.text }
        set { statusView.view.text = newValue }
    }

    var nativeTown: String? {
        get { nativeTownView.view.text }
        set { nativeTownView.view.text = newValue }
    }

    var birthDate: String? {
        get { birthDateView.view.text }
        set { birthDateView.view.text = newValue }
    }

    var avatarData: Data? {
        get { avatarImageView.image?.asAvatarData }
        set { avatarImageView.image = newValue?.asImage }
    }

    var avatarImage: UIImage? {
        get { avatarImageView.image }
        set { avatarImageView.image = newValue
//            setAvatarViewBorderWidth()
        }
    }

    var isBusy: Bool {
        get {
            !activityView.isHidden
        }
        set {
            activityView.isHidden = !newValue
        }
    }

    // MARK: - Views

    private lazy var avatarImageView: ImagePickerView = {
        let imageView = viewFactory.makeAvatarPickerView(delegate: imagePickerViewDelegate)

        return imageView
    }()

//    private lazy var avatarImageView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0,
//                                                  y: 0,
//                                                  width: Constants.UI.avatarImageSize,
//                                                  height: Constants.UI.avatarImageSize))
//        //        let imageView = UIImageView()
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.brandYellowColor.cgColor
//        imageView.layer.cornerRadius = imageView.frame.width / 2
//        imageView.layer.masksToBounds = true
//
//        let tapRecognizer = UITapGestureRecognizer(target: self,
//                                                   action: #selector(avatarTapped))
//        imageView.addGestureRecognizer(tapRecognizer)
//        imageView.isUserInteractionEnabled = true
//
//        return imageView
//    }()

//    private lazy var tapImageLabel: UILabel = {
//        let label = viewFactory.makeSmallTextLabel()
//        label.numberOfLines = 0
//        label.text = "tapImageLabelUserProfileView".localized
////        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
////        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//
//        return label
//    }()

//    lazy var clearAvatarButton: UIButton = {
//        let config = UIImage.SymbolConfiguration(pointSize: 10)
//        let image = UIImage(systemName: "xmark", withConfiguration: config)
//        let action = UIAction(image: image) { [weak self] _ in
//            self?.avatarImageView.image = nil
//        }
//
//        var configuration = UIButton.Configuration.plain()
//        configuration.baseForegroundColor = .brandYellowColor
//
//        return UIButton(configuration: configuration, primaryAction: action)
//    }()

    private lazy var firstNameView: LabeledView<UITextField> = {
        let view = viewFactory.makeLabeledTextField(label: "firstNameLabelUserProfileView".localized,
                                                    placeholder: "firstNamePlaceholderUserProfileView".localized)
        return view
    }()

    private lazy var lastNameView: LabeledView<UITextField> = {
        let view = viewFactory.makeLabeledTextField(label: "lastNameLabelUserProfileView".localized,
                                                    placeholder: "lastNamePlaceholderUserProfileView".localized)
        return view
    }()

    private lazy var genderView: LabeledView<UISegmentedControl> = {
        let label = viewFactory.makeBoldTextLabel()
        label.textAlignment = .left
        label.text = "genderLabelUserProfileView".localized

        let male = UIAction(title: Gender.male.title) { _ in
            self.gender = .male
        }

        let female = UIAction(title: Gender.female.title) { _ in
            self.gender = .female
        }

        let control = UISegmentedControl(items: [male, female])

        return LabeledView(label: label, view: control, spacing: Constants.UI.smallPadding)
    }()

    private lazy var genderSelector: UISegmentedControl = {
        let male = UIAction(title: Gender.male.title) { _ in
            self.gender = .male
        }

        let female = UIAction(title: Gender.female.title) { _ in
            self.gender = .female
        }

        let control = UISegmentedControl(items: [male, female])

        return control
    }()

    private lazy var birthDateView: LabeledView<UITextField> = {
        let view = viewFactory.makeLabeledTextField(label: "birthDateLabelUserProfileView".localized,
                                                    placeholder: "")
        return view
    }()

    private lazy var nativeTownView: LabeledView<UITextField> = {
        let view = viewFactory.makeLabeledTextField(label: "nativeTownLabelUserProfileView".localized,
                                                    placeholder: "nativeTownPlaceholderUserProfileView".localized)
        return view
    }()

    private lazy var phoneNumberView: LabeledView<UITextField> = {
        let view = viewFactory.makeLabeledPhoneField(label: "phoneNumberLabelUserProfileView".localized,
                                                    placeholder: "phoneNumberPlaceholderUserProfileView".localized)
        return view
    }()

    private lazy var statusView: LabeledView<UITextField> = {
        let view = viewFactory.makeLabeledTextField(label: "statusLabelUserProfileView".localized,
                                                    placeholder: "statusPlaceholderUserProfileView".localized)

        return view
    }()

    lazy var activityView: UIActivityIndicatorView = {
        let activity = viewFactory.makeActivityIndicatorView()

        return activity
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Constants.UI.padding

        return stack
    }()





    // MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol,
         imagePickerViewDelegate: ImagePickerViewDelegate?
//         dateFormatter: DateFormatter
    ) {
        self.viewFactory = viewFactory
        self.imagePickerViewDelegate = imagePickerViewDelegate
//        self.dateFormatter = dateFormatter
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        [
            //tapImageLabel,
         avatarImageView,
//         clearAvatarButton,
         stackView,
         activityView
        ].forEach {
            self.addSubview($0)
        }

        [firstNameView,
         lastNameView,
         genderView,
         birthDateView,
         nativeTownView,
         phoneNumberView,
         statusView
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
//        tapImageLabel.snp.makeConstraints { make in
//            make.top.leading.equalTo(avatarImageView).offset(Constants.UI.padding)
//            make.trailing.bottom.equalTo(avatarImageView).offset(-Constants.UI.padding)
//        }
        
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.padding)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.UI.avatarImageSize).priority(.required)
        }

//        clearAvatarButton.snp.makeConstraints { make in
//            make.centerX.equalTo(avatarImageView.snp.trailing)
//            make.centerY.equalTo(avatarImageView.snp.top)
//        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)

            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
        }
    }

//    @objc private func avatarTapped() {
//        sendButtonTapped(.avatar)
//    }

//    private func setAvatarViewBorderWidth() {
//        switch avatarImageView.image {
//            case .none:
//                avatarImageView.layer.borderWidth = 1
//
//            case .some:
//                avatarImageView.layer.borderWidth = 0
//        }
//    }
}
