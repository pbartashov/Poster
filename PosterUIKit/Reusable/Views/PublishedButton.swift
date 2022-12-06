//
//  PublishedButton.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit
import Combine

class PublishedButton<T>: UIButton {

    // MARK: - Properties

    private let publishedValue: T

    private let tapped = PassthroughSubject<T, Never>()
    var tappedPublisher: AnyPublisher<T, Never> {
        tapped.eraseToAnyPublisher()
    }

    // MARK: - LifeCicle

    init(publishedValue: T) {
        self.publishedValue = publishedValue
        super.init(frame: .zero)

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    @objc private func buttonTapped() {
        tapped.send(publishedValue)
    }
}
