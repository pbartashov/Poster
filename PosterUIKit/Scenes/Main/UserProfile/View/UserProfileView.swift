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

final class UserProfileView: UIView {

    // MARK: - Properties

    private weak var imagePickerViewDelegate: ImagePickerViewDelegate?

    let viewFactory: ViewFactoryProtocol

    var datePlaceHolder: String? {
        get { birthDateView.view.placeholder }
        set { birthDateView.view.placeholder = newValue }
    }

    var gender: Gender? {
        didSet {
            setGenderSelectorIndex()
        }
    }

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
        set { avatarImageView.image = newValue }
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
    ) {
        self.viewFactory = viewFactory
        self.imagePickerViewDelegate = imagePickerViewDelegate
        super.init(frame: .zero)

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        [avatarImageView,
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
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.padding)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.UI.avatarImageSize).priority(.required)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
            
            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
        }
    }

    private func setGenderSelectorIndex() {
        switch gender {
            case .male:
                genderView.view.selectedSegmentIndex = 0

            case .female:
                genderView.view.selectedSegmentIndex = 1

            case .none:
                genderView.view.selectedSegmentIndex = -1
        }
    }
}
