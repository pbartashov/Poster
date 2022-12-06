//
//  ProfileHeaderView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 10.03.2022.
//

import SnapKit
import PosterKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func editUserProfileButtonTapped()
    func addPostButtonTapped()
    func addStoryButtonTapped()
    func addPhotoButtonTapped()
    func avatarTapped(sender: UIView)
}

final class ProfileHeaderViewCell: UITableViewCell {

    // MARK: - Properties

    let viewFactory: ViewFactoryProtocol&UserInfoViewFactory = ViewFactory()
    weak var delegate: ProfileHeaderViewDelegate?

//
//    var statusText: String {
//        statusTextField.text ?? ""
//    }

    // MARK: - Views

    private lazy var userInfoView: UserInfoView = {
        let view = UserInfoView(viewFactory: viewFactory,
                                padding: Constants.UI.padding,
                                authorAvatarImageSize: Constants.UI.avatarImageSize)
        view.backgroundColor = .brandBackgroundColor

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(avatarTapped))
        view.avatarView.addGestureRecognizer(tapRecognizer)
        view.avatarView.isUserInteractionEnabled = true

        return view
    }()

    private lazy var editUserProfileButton: UIButton = {
        let action = UIAction(title: "editButtonProfileHeaderView".localized) { [weak self] _ in
            self?.delegate?.editUserProfileButtonTapped()
        }

        return viewFactory.makeYellowFilledButton(action: action)
    }()

    private lazy var userActivityPanel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            publishedPostsCountLabel,
            subsribesCountLabel,
            followersCountLabel
        ])
        stack.distribution = .fillEqually

        return stack
    }()
    
    private lazy var publishedPostsCountLabel: UILabel = {
        let label = viewFactory.makeTextLabel()
        label.numberOfLines = 0

        return label
    }()

    private lazy var subsribesCountLabel: UILabel = {
        let label = viewFactory.makeTextLabel()
        label.numberOfLines = 0

        return label
    }()

    private lazy var followersCountLabel: UILabel = {
        let label = viewFactory.makeTextLabel()
        label.numberOfLines = 0

        return label
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .brandLightGray

        return view
    }()

    private lazy var userActionsPanel: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            addPostButton,
//            UIView(),
            addStoryButton,
            addPhotoButton
        ])
        stack.spacing = Constants.UI.padding
        stack.distribution = .fillEqually

        return stack
    }()

    private lazy var addPostButton: UIButton = {
        let image = UIImage(systemName: "square.and.pencil")
        let action = UIAction(title: "addPostProfileHeaderView".localized, image: image) { [weak self] _ in
            self?.delegate?.addPostButtonTapped()
        }

        return viewFactory.makeVerticalPlainButton(action: action)
     }()

    private lazy var addStoryButton: UIButton = {
        let image = UIImage(systemName: "camera")
        let action = UIAction(title: "addStoryProfileHeaderView".localized, image: image) { [weak self] _ in
            self?.delegate?.addStoryButtonTapped()
        }

        return viewFactory.makeVerticalPlainButton(action: action)
    }()

    private lazy var addPhotoButton: UIButton = {
        let image = UIImage(systemName: "photo")
        let action = UIAction(title: "eaddPhotoProfileHeaderView".localized, image: image) { [weak self] _ in
            self?.delegate?.addPhotoButtonTapped()
        }

        return viewFactory.makeVerticalPlainButton(action: action)
    }()

    // MARK: - LifeCicle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Metods

    private func initialize() {
        backgroundColor = .brandBackgroundColor

        [editUserProfileButton,
         userActivityPanel,
         separator,
         userActionsPanel,
         userInfoView
        ].forEach {
            contentView.addSubview($0)
        }

        setupLayouts()
    }

    func setup(with user: UserViewModel?) {
        guard let user = user else { return }
        userInfoView.avatar = user.avatarData?.asImage
        userInfoView.name = user.displayedName
        userInfoView.status = user.status

        publishedPostsCountLabel.text = user.publishedPostsCountText
        subsribesCountLabel.text = user.subsribesCountText
        followersCountLabel.text = user.followersCountText
    }

    private func setupLayouts() {
        userInfoView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
            make.height.equalTo(Constants.UI.avatarImageSize)
        }

        editUserProfileButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
//            make.height.equalTo(50)
        }

        userActivityPanel.snp.makeConstraints { make in
            make.top.equalTo(editUserProfileButton.snp.bottom).offset(Constants.UI.padding)
            make.leading.trailing.equalTo(editUserProfileButton)
            make.height.equalTo(Constants.UI.userActivityPanelHeight)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(userActivityPanel.snp.bottom).offset(Constants.UI.padding)
            make.leading.trailing.equalTo(editUserProfileButton)
            make.height.equalTo(Constants.UI.separatorHeight)
        }

        userActionsPanel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(Constants.UI.padding)
            make.leading.trailing.equalTo(editUserProfileButton)
//            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.UI.userActivityPanelHeight)

            make.bottom.equalToSuperview().offset(-Constants.UI.padding).priority(.low)
        }
    }

    @objc private func avatarTapped() {
        delegate?.avatarTapped(sender: userInfoView.avatarView)
    }
}
