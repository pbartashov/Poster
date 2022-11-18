//
//  FollowersSectionHeaderView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit
import Combine

final class StoriesSectionHeaderView: UICollectionReusableView {
    enum Button {
        case button
    }

    // MARK: - Properties

    var buttonTappedPublisher: AnyPublisher<Button, Never> {
        button.tappedPublisher
    }

    // MARK: - Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center

        return stackView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .brandTextBlackColor

        return label
    }()

    private lazy var button: PublishedButton<Button> = {
        let button = PublishedButton(publishedValue: Button.button)
        button.setTitleColor(.brandTextBlackColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setContentHuggingPriority(.required, for: .horizontal)

        return button
    }()

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
        addSubview(stackView)

        [label, button].forEach {
            stackView.addArrangedSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setup(labelTitle: String? = nil,
               buttonTitle: String? = nil
    ) {
        label.text = labelTitle
//        button.setUnderlinedTitle(buttonTitle, for: .normal)
    }
}
