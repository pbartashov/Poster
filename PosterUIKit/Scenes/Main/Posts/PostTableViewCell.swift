//
//  PostTableViewCell.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit
import PosterKit
import iOSIntPackage

#warning("final")
final class PostTableViewCell: UITableViewCell {

    //MARK: - Views

    private let postCellView = PostViewCell(viewFactory: ViewFactory())

//    private let authorLabel: UILabel = {
//        let label = UILabel()
//
//        label.font = .systemFont(ofSize: 20, weight: .bold)
//        label.textColor = .textColor
//        label.numberOfLines = 2
//
//        return label
//    }()
//
//    private let postImageView: UIImageView = {
//        let imageView = UIImageView()
//
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .black
//
//        return imageView
//    }()
//
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//
//        label.font = .systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .secondaryTextColor
//        label.numberOfLines = 0
//
//        return label
//    }()
//
//    private let likesLabel: UILabel = {
//        let label = UILabel()
//
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//        label.textColor = .textColor
//
//        return label
//    }()
//
//    private let viewsLabel: UILabel = {
//        let label = UILabel()
//
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//        label.textColor = .textColor
//        label.textAlignment = .right
//
//        return label
//    }()
//
//    private lazy var likesAndViewsStack: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [likesLabel, viewsLabel])
//
//        stack.axis = .horizontal
//        stack.alignment = .fill
//        stack.distribution = .fillEqually
//
//        return stack
//    }()

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
//        [authorLabel,
//         postImageView,
//         descriptionLabel,
//         likesAndViewsStack
//        ].forEach {
//            contentView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        contentView.addSubview(postCellView)
        setupLayouts()
    }

    private func setupLayouts() {
        postCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        NSLayoutConstraint.activate([
//            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.UI.padding),
//            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.UI.padding),
//            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.UI.padding),
//
//            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
//            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            postImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
//
//            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Constants.UI.padding),
//            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
//            descriptionLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
//
//            likesAndViewsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.UI.padding),
//            likesAndViewsStack.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
//            likesAndViewsStack.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
//
//            contentView.bottomAnchor.constraint(equalTo: likesAndViewsStack.bottomAnchor)
//        ])
    }

    func setup(with post: PostViewModel, filter: ColorFilter?) {
        postCellView.setup(with: post, filter: filter)
        
//        authorLabel.text = post.author
//        descriptionLabel.text = post.description
//
//        let likesString = "postLikesCount".localized
//        likesLabel.text = String.localizedStringWithFormat(likesString, post.likes)
//
//        let viewsString = "postViewsCount".localized
//        viewsLabel.text = String.localizedStringWithFormat(viewsString, post.views)
//
//        guard let image = post.image else {
//            postImageView.image = .placeholder
//            return
//        }
//
//        guard let filter = filter else {
//            postImageView.image = image
//            return
//        }
//
//        Task {
//            postImageView.image = await Task.detached {
//                await withCheckedContinuation { continuation in
//                    ImageProcessor()
//                        .processImage(sourceImage: image, filter: filter) { processed in
//                            continuation.resume(returning: processed)
//                        }
//                }
//            }
//            .value
//        }
    }

    override func prepareForReuse() {
        postCellView.reset()
    }
}
