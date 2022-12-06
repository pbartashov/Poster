//
//  PostService.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import Combine

//public class PostService: PostServiceProtocol {
//
//    // MARK: - Properties
//    let postSubject = CurrentValueSubject<[Post], Never>([])
//    public var postsPublisher: AnyPublisher<[Post], Never> {
//        postSubject.eraseToAnyPublisher()
//    }
//
//    let repository: PostRepositoryInterface
//
//    // MARK: - Views
//
//    // MARK: - LifeCicle
//    public init(repository: PostRepositoryInterface) {
//        self.repository = repository
//    }
//    // MARK: - Metods
//
//
//    public func store(post: Post) async throws {
//        try await repository.save(post: post)
//        try await repository.saveChanges()
//    }
//
//    public func remove(post: Post) async throws {
//        try await repository.delete(post: post)
//        try await repository.saveChanges()
//    }
//
//    public func startFetchingPosts(filteredBy filter: Filter) async throws { }
//}
