//
//  FollowersViewCell.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import SnapKit
import Combine
import PosterKit

final class StoriesViewCell: UICollectionViewCell {

    // MARK: - Properties

    var subsriptions: Set<AnyCancellable> = []
    
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

    func setup(with story: StoryViewModel) {
        story.fetchData()

        story.$authorAvatarData
            .map { $0?.asImage ?? .avatarPlaceholder }
            .assignOnMain(to: \.image, on: avatarView)
            .store(in: &subsriptions)
    }

    override func prepareForReuse() {
        subsriptions.removeAll()
    }
}

