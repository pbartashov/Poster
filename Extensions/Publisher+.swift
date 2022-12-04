//
//  Publisher+.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import Foundation
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

    func assignOnMain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root
    ) -> AnyCancellable where Self.Failure == Never {
        self.receive(on: DispatchQueue.main)
            .assign(to: keyPath, on: object)
    }
}
