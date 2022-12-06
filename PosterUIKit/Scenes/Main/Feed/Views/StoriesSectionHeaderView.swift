//
//  FollowersSectionHeaderView.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit
import Combine

final class StoriesSectionHeaderView: UICollectionReusableView {

    // MARK: - Properties

    @Published var isRecommended: Bool = false

    // MARK: - Views

    private lazy var selector: UISegmentedControl = {
        let all = UIAction(title: "allStoriesSectionHeaderView".localized) { _ in
            self.isRecommended = false
        }

        let recommended = UIAction(title: "recommendedStoriesSectionHeaderView".localized) { _ in
            self.isRecommended = true
        }

        let control = UISegmentedControl(items: [all, recommended])
        control.selectedSegmentIndex = 0

        return control
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
        addSubview(selector)
        setupLayouts()
    }

    private func setupLayouts() {
        selector.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.UI.padding)
            make.trailing.equalToSuperview().offset(-Constants.UI.padding)
        }
    }
}
