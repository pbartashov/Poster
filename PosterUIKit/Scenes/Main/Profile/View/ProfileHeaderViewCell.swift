//
//  ProfileHeaderView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 10.03.2022.
//

import SnapKit
import PosterKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func statusButtonTapped()
    func avatarTapped(sender: UIView)
}

final class ProfileHeaderViewCell: UITableViewCell {

    //MARK: - Properties

    weak var delegate: ProfileHeaderViewDelegate?

    var statusText: String {
        statusTextField.text ?? ""
    }

    //MARK: - Views

    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: ConstantsUI.padding,
                                              y: ConstantsUI.padding,
                                              width: ConstantsUI.avatarImageSize,
                                              height: ConstantsUI.avatarImageSize))
        image.layer.borderWidth = 3
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(avatarTapped))
        image.addGestureRecognizer(tapRecognizer)
        image.isUserInteractionEnabled = true

        return image
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .textColor

        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryTextColor

        return label
    }()

    private let statusTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .textColor
        textField.backgroundColor = .lightBackgroundColor

        let redPlaceholderText = NSAttributedString(string: "statusTextFieldPlaceholderProfileHeaderView".localized,
                                                    attributes: [.foregroundColor: UIColor.placeholderTextColor])
        textField.attributedPlaceholder = redPlaceholderText

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true

        return textField
    }()

    private lazy var setStatusButton: UIButton = {
        let action = UIAction(title: "setStatusButtonProfileHeaderView".localized) { [weak self] _ in
            self?.setStatusButtonTapped()
        }

        let button = LoginViewFactory().makePlainButton(action: action)

        return button
    }()

    //MARK: - LifeCicle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Metods

    private func initialize() {
        backgroundColor = .backgroundColor

        [avatarImageView,
        fullNameLabel,
        statusLabel,
        statusTextField,
        setStatusButton
        ].forEach {
            contentView.addSubview($0)
        }

        setupLayouts()
    }

    func setup(with user: User?) {
        avatarImageView.image = user?.avatar
        fullNameLabel.text = user?.name
        statusLabel.text = user?.status
    }

    private func setupLayouts() {
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(ConstantsUI.padding)
            make.width.height.equalTo(ConstantsUI.avatarImageSize)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(ConstantsUI.padding)
            make.trailing.equalToSuperview().offset(-ConstantsUI.padding)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(ConstantsUI.padding)
            make.trailing.equalToSuperview().offset(-ConstantsUI.padding)
            make.top.equalToSuperview().offset(82)
        }

        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(ConstantsUI.padding / 2)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(ConstantsUI.padding)
            make.trailing.equalToSuperview().offset(-ConstantsUI.padding)
            make.height.equalTo(40)
        }

        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(ConstantsUI.padding)
            make.leading.equalToSuperview().offset(ConstantsUI.padding)
            make.trailing.equalToSuperview().offset(-ConstantsUI.padding)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-ConstantsUI.padding)
        }
    }

    private func setStatusButtonTapped() {
        delegate?.statusButtonTapped()
    }

    @objc private func avatarTapped() {
        delegate?.avatarTapped(sender: avatarImageView)
    }
}
