//
//  PostCollectionViewCell.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import SnapKit
import PosterKit
import Combine
//import iOSIntPackage

final class PostCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private var subscriptions: Set<AnyCancellable> = []
    private var onAddToFavorites: (() -> Void)?

    // MARK: - Views

    private let postCellView = PostViewCell(viewFactory: ViewFactory())

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods
    private func initialize() {
        contentView.addSubview(postCellView)
        setupLayouts()
        bindToView()
    }

    private func setupLayouts() {
        postCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindToView() {
        postCellView.buttonTappedPublisher
            .sink { [weak self] button in
                if case .addToFavorites = button {
                    self?.onAddToFavorites?()
                }
            }
            .store(in: &subscriptions)
    }

    func setup(with post: PostViewModel,
              onAddToFavorites: (() -> Void)?
    ) {
        postCellView.setup(with: post)
        self.onAddToFavorites = onAddToFavorites
    }

    override func prepareForReuse() {
        postCellView.reset()
        onAddToFavorites = nil
        #warning("other")
    }
}
