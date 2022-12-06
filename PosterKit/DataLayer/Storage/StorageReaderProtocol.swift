//
//  StorageReaderProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

import Combine

public protocol StorageReaderProtocol {
    var postsPublisher: AnyPublisher<[Post], Never> { get }
    func startFetchingPosts(filteredBy filter: Filter) async throws

    var storiesPublisher: AnyPublisher<[Story], Never>? { get }
    func startFetchingStories(filteredBy filter: Filter?) async throws

    func getUser(byId uid: String) async throws -> User?
    func getImageData(byId uid: String) async throws -> Data?
}

extension StorageReaderProtocol {
    func startFetchingStories(filteredBy filter: Filter? = nil) async throws {
        try await startFetchingStories(filteredBy: filter)
    }
}
