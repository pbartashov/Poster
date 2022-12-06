//
//  StorageService.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

import Combine

final public class LocalStorageReader: StorageReaderProtocol {

    // MARK: - Properties
    
    private let repository: PostRepositoryInterface

    public var postsPublisher: AnyPublisher<[Post], Never> {
        repository.postsPublisher
            .eraseToAnyPublisher()
    }

    // MARK: - LifeCicle

    public init(repository: PostRepositoryInterface) {
        self.repository = repository
    }

    // MARK: - Metods
    public func startFetchingPosts(filteredBy filter: Filter) throws {
        var predicate: NSPredicate? = nil
        if let text = filter.content {
            predicate = NSPredicate(format: "content CONTAINS[c] %@", text)
        }
        try repository.startFetchingWith(predicate: predicate, sortDescriptors: nil)
    }

    public func getUser(byId uid: String) async throws -> User? {
        #warning("TODO")
        return nil
    }

    public func getImageData(byId uid: String) async throws -> Data? {
#warning("TODO")
        return nil
    }
}
