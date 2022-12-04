//
//  UserInfoView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 30.11.2022.
//

import UIKit

protocol UserInfoViewFactory {
    func makeAuthorNameLabel() -> UILabel
    func makeAuthorStatusLabel() -> UILabel
}

class UserInfoView: UIView {

    // MARK: - Properties

    private let viewFactory: UserInfoViewFactory

    var padding: CGFloat {
        didSet{
            setupLayouts()
        }
    }

    var avatarImageSize: CGFloat {
        didSet{
            setupLayouts()
        }
    }

    var name: String? {
        get { authorNameLabel.text }
        set { authorNameLabel.text = newValue }
    }

    var status: String? {
        get { authorStatusLabel.text }
        set { authorStatusLabel.text = newValue }
    }

    var avatar: UIImage? {
        get { avatarView.image }
        set { avatarView.image = newValue }
    }

    // MARK: - Views

    lazy var avatarView: UIImageView = {
        let imageView = UIImageView(
//            frame: CGRect(x: 0,
//                                                  y: 0,
//                                                  width: Constants.UI.authorAvatarImageSize,
//                                                  height: Constants.UI.authorAvatarImageSize)
        )
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.tintColor = .brandYellowColor
        imageView.layer.masksToBounds = true

        return imageView
    }()

    lazy var authorNameLabel: UILabel = {
        let label = viewFactory.makeAuthorNameLabel()

        return label
    }()

    lazy var authorStatusLabel: UILabel = {
        let label = viewFactory.makeAuthorStatusLabel()

        return label
    }()

    private lazy var authorTextStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorNameLabel, authorStatusLabel])
        stack.axis = .vertical
        stack.spacing = Constants.UI.padding

        return stack
    }()

    // MARK: - LifeCicle

    init(viewFactory: UserInfoViewFactory,
         padding: CGFloat = 0,
         authorAvatarImageSize: CGFloat = 0
    ) {
        self.viewFactory = viewFactory
        self.padding = padding
        self.avatarImageSize = authorAvatarImageSize
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.layer.cornerRadius = avatarView.bounds.width / 2
    }

    // MARK: - Metods
    private func initialize() {

        [avatarView,
         authorTextStack
        ].forEach {
            addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        avatarView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(avatarImageSize)
        }

        authorTextStack.snp.remakeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(padding)
            make.centerY.equalToSuperview()
        }
    }
}

