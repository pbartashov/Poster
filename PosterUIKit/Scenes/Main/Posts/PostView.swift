//
//  PostView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 18.11.2022.
//

import UIKit
import PosterKit
import iOSIntPackage

class PostView: UIView {

    //MARK: - Views

    private let authorLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .textColor
        label.numberOfLines = 2

        return label
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0

        return label
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .textColor

        return label
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .textColor
        label.textAlignment = .right

        return label
    }()

    private lazy var likesAndViewsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likesLabel, viewsLabel])

        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually

        return stack
    }()

    //MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Metods
    private func initialize() {
        [authorLabel,
         postImageView,
         descriptionLabel,
         likesAndViewsStack].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setupLayouts()
    }

    private func setupLayouts() {
#warning("snp")
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.UI.padding),
            authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.UI.padding),
            authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.UI.padding),

            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: self.widthAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Constants.UI.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),

            likesAndViewsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.UI.padding),
            likesAndViewsStack.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            likesAndViewsStack.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),

            self.bottomAnchor.constraint(equalTo: likesAndViewsStack.bottomAnchor)
        ])
    }

    func setup(with post: Post, filter: ColorFilter? = nil) {
        authorLabel.text = post.author.name
        descriptionLabel.text = post.description

        let likesString = "postLikesCount".localized
        likesLabel.text = String.localizedStringWithFormat(likesString, post.likes)

        let viewsString = "postViewsCount".localized
        viewsLabel.text = String.localizedStringWithFormat(viewsString, post.views)

        guard let image = post.imageData?.asImage else {
            postImageView.image = .placeholder
            return
        }

        guard let filter = filter else {
            postImageView.image = image
            return
        }

        Task {
            postImageView.image = await Task.detached {
                await withCheckedContinuation { continuation in
                    ImageProcessor()
                        .processImage(sourceImage: image, filter: filter) { processed in
                            continuation.resume(returning: processed)
                        }
                }
            }
            .value
        }
    }
}
