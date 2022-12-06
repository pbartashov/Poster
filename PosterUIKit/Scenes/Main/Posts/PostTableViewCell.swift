//
//  PostTableViewCell.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit
import PosterKit
import Combine

final class PostTableViewCell: UITableViewCell {

    // MARK: - Properties

    private var subscriptions: Set<AnyCancellable> = []
    private var onAddToFavorites: (() -> Void)?
    
    // MARK: - Views

    private let postCellView = PostViewCell(viewFactory: ViewFactory())

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
    }
}
