//
//  PostView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 18.11.2022.
//

import UIKit
import Combine
import PosterKit

enum PostViewButton {
    case addToFavorites
}

class PostViewCell: ViewWithButton<PostViewButton> {

    // MARK: - Properties

    var subsriptions: Set<AnyCancellable> = []
    private let viewFactory: ViewFactoryProtocol&UserInfoViewFactory

    // MARK: - Views

//    private let headerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .backgroundColor
//
//        return view
//    }()

    private lazy var headerView: UserInfoView = {
        let view = UserInfoView(viewFactory: viewFactory,
                                padding: Constants.UI.padding,
                                authorAvatarImageSize: Constants.UI.authorAvatarImageSize)
        view.backgroundColor = .brandBackgroundColor

        return view
    }()

//    private let authorAvatarView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0,
//                                              y: 0,
//                                              width: Constants.UI.authorAvatarImageSize,
//                                              height: Constants.UI.authorAvatarImageSize))
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = imageView.bounds.width / 2
//        imageView.tintColor = .brandYellowColor
//        imageView.layer.masksToBounds = true
//
//        return imageView
//    }()
//
//    private lazy var authorNameLabel: UILabel = {
//        let label = viewFactory.makeH3Label()
//
//        return label
//    }()
//
//    private lazy var authorStatusLabel: UILabel = {
//        let label = viewFactory.makeSmallTextLabel()
//
//        return label
//    }()
//
//    private lazy var authorTextStack: UIStackView = {
//        let textStack = UIStackView(arrangedSubviews: [authorNameLabel, authorStatusLabel])
//        textStack.axis = .vertical
//        textStack.spacing = Constants.UI.padding
//
////        let stack = UIStackView(arrangedSubviews: [authorAvatarView, textStack])
////        stack.axis = .horizontal
////        stack.alignment = .fill
////        stack.distribution = .fill
////        stack.spacing = Constants.UI.padding
//        //        stack.backgroundColor = .yellow
//
//        return textStack
//    }()

    private lazy var postImageView: UIImageView = {
        let imageView = viewFactory.makeImageView()
        imageView.contentMode = .scaleAspectFill
     
        return imageView
    }()

    private lazy var contentLabel: UILabel = {
        let label = viewFactory.makeTextLabel()
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    
    private lazy var likesView: ImagedLabel = {
        let imagedLabel = viewFactory.makeImagedLabel(imageSystemName: "heart")

        return imagedLabel
    }()

    private lazy var viewsView: ImagedLabel = {
        let imagedLabel = viewFactory.makeImagedLabel(imageSystemName: "message")

        return imagedLabel
    }()

    private lazy var likesAndViewsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likesView, viewsView])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = Constants.UI.padding

        return stack
    }()

    lazy var activityView: UIActivityIndicatorView = {
        let activity = viewFactory.makeActivityIndicatorView()

        return activity
    }()

    lazy var addToFavoritesButton: UIButton = {
        let image = UIImage(systemName: "bookmark")
        let action = UIAction(image: image) { [weak self] _ in
            self?.sendButtonTapped(.addToFavorites)
        }
        let button = viewFactory.makePlainButton(action: action)
        button.isEnabled = false

        return button
    }()

    // MARK: - LifeCicle

    init(viewFactory: ViewFactoryProtocol&UserInfoViewFactory) {
        self.viewFactory = viewFactory
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        authorAvatarView.layer.cornerRadius = authorAvatarView.bounds.width / 2
//    }

    // MARK: - Metods
    private func initialize() {
        backgroundColor = .brandBackgroundGrayColor

//        [authorAvatarView,
//         authorTextStack
//        ].forEach {
//            headerView.addSubview($0)
//        }

        [headerView,
         postImageView,
         contentLabel,
         likesAndViewsStack,
         addToFavoritesButton,
         activityView
        ].forEach {
            addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.UI.postHeaderHeight)
        }

//        authorAvatarView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(Constants.UI.padding)
//            make.centerY.equalToSuperview()
//            make.height.width.equalTo(Constants.UI.authorAvatarImageSize)
//        }
//
//        authorTextStack.snp.makeConstraints { make in
//            make.leading.equalTo(authorAvatarView.snp.trailing).offset(Constants.UI.padding)
//            //.offset(Constants.UI.padding)
//            //            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
//            make.centerY.equalToSuperview()
//        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
            make.height.equalTo(Constants.UI.postContentLabelHeight)
        }

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
            make.height.equalTo(postImageView.snp.width).multipliedBy(Constants.UI.postImageAcpectRatio)
        }

        activityView.snp.makeConstraints { make in
            make.center.equalTo(postImageView)
        }

        addToFavoritesButton.snp.makeConstraints { make in
            make.centerY.equalTo(likesAndViewsStack)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
        }

        likesAndViewsStack.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(Constants.UI.padding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)

            make.bottom.equalToSuperview().offset(-Constants.UI.padding)
        }
    }

    func setup(with post: PostViewModel) {
        post.fetchData()

        contentLabel.text = post.content

        //        let likesString = "postLikesCount".localized
        //        likesView.text = String.localizedStringWithFormat(likesString, post.likes)
        likesView.text = "\(post.likes)"

        //        let viewsString = "postViewsCount".localized
        //        viewsView.text = String.localizedStringWithFormat(viewsString, post.views)
        viewsView.text = "\(post.views)"

        post.$authorName
            .assignOnMain(to: \.name, on: headerView)
            .store(in: &subsriptions)

        post.$authorStatus
            .receive(on: DispatchQueue.main)
            .assign(to: \.status, on: headerView)
            .store(in: &subsriptions)

        post.$authorAvatarData
            .map { $0?.asImage ?? .avatarPlaceholder }
            .assignOnMain(to: \.avatar, on: headerView)
            .store(in: &subsriptions)

        post.$imageData
            .receive(on: DispatchQueue.main)
            .sink { [postImageView, activityView] imageData in
                guard let image = imageData?.asImage else {
                    postImageView.image = nil
                    activityView.isHidden = false
                    return
                }

                activityView.isHidden = true
                postImageView.image = image
            }
            .store(in: &subsriptions)

        let isFavoritePublisher = post.$isFavorite
            .compactMap { $0 }

        isFavoritePublisher
            .map { _ in true }
            .assignOnMain(to: \.isEnabled, on: addToFavoritesButton)
            .store(in: &subsriptions)

        isFavoritePublisher
            .assignOnMain(to: \.isHighlighted, on: addToFavoritesButton)
            .store(in: &subsriptions)
    }

    func reset() {
        subsriptions.removeAll()
    }
}
