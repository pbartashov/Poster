//
//  FollowersViewCell.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import SnapKit
import PosterKit

final class StoriesViewCell: UICollectionViewCell {

    // MARK: - Views

    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.brandYellowColor.cgColor

        return imageView
    }()

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.layer.cornerRadius = bounds.width / 2
    }

    // MARK: - Metods

    private func initialize() {
        contentView.addSubview(avatarView)
        setupLayouts()
    }

    private func setupLayouts() {
        avatarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup(with story: Story) {
        avatarView.image = story.author.avatarData?.asImage
    }
}

