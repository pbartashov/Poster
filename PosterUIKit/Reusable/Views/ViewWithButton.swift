//
//  ViewWithButton.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 12.11.2022.
//

import UIKit
import Combine

class ViewWithButton<T>: UIView {

    // MARK: - Properties

    var buttonTappedPublisher: AnyPublisher<T, Never> {
        buttonTappedSubject.eraseToAnyPublisher()
    }

    private var buttonTappedSubject = PassthroughSubject<T, Never>()

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods

    func sendButtonTapped(_ button: T) {
        buttonTappedSubject.send(button)
    }
}
