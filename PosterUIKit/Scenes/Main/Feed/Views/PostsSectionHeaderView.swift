//
//  PostsSectionHeaderView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit
import Combine

final class PostsSectionHeaderView: UICollectionReusableView {

    // MARK: - Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Constants.UI.smallPadding

        return stackView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .brandTextFont
        label.textColor = .brandTextGrayColor
        label.textAlignment = .center

        return label
    }()

    private lazy var labelContainer: UIView = {
        let view = UILabel()
        view.layer.cornerRadius = Constants.UI.cornerRadius
        view.layer.borderWidth = Constants.UI.separatorHeight
        view.layer.borderColor = UIColor.brandTextGrayColor.cgColor

        return view
    }()

    private lazy var leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandTextGrayColor

        return view
    }()

    private lazy var rightLineView: UIView	 = {
        let view = UIView()
        view.backgroundColor = .brandTextGrayColor

        return view
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
        labelContainer.addSubview(label)

        [leftLineView,
         labelContainer,
         rightLineView
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
        }

        leftLineView.snp.makeConstraints { make in
            make.height.equalTo(Constants.UI.separatorHeight)
        }

        rightLineView.snp.makeConstraints { make in
            make.height.equalTo(Constants.UI.separatorHeight)
            make.width.equalTo(leftLineView)
        }

        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.smallPadding)
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
            make.bottom.equalToSuperview().offset(-Constants.UI.smallPadding)
        }
    }

    func setup(title: String? = nil) {
        label.text = title
    }
}
