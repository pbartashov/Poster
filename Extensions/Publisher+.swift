//
//  Publisher+.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import Combine

extension Publisher where Output: Equatable {
    func eraseTypeAndDuplicates() -> AnyPublisher<Void, Self.Failure> {
        self.removeDuplicates()
            .eraseType()
    }

    func eraseType() -> AnyPublisher<Void, Self.Failure> {
        self.map { _ in }
            .eraseToAnyPublisher()
    }
}
