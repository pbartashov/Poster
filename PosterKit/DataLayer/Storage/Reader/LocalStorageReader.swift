//
//  StorageService.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

import Combine

final public class LocalStorageReader: StorageReaderProtocol {

    // MARK: - Properties

    public var storiesPublisher: AnyPublisher<[Story], Never>?

    private let repository: PostRepositoryInterface

    public var postsPublisher: AnyPublisher<[Post], Never> {
        repository.postsPublisher
            .map { postViewModels in
                postViewModels.map { $0.post }
            }
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
        let predicate = NSPredicate(format: "authorId == %@", uid)
        let posts = try await repository.getPosts(predicate: predicate)
        guard let postViewModel = posts.first else { return nil }

        return User(uid: postViewModel.post.authorId,
                    lastName: postViewModel.authorName,
                    avatarData: postViewModel.authorAvatarData,
                    status: postViewModel.authorStatus)
    }

    public func getImageData(byId uid: String) async throws -> Data? {
        let predicate = NSPredicate(format: "uid == %@", uid)
        let posts = try await repository.getPosts(predicate: predicate)
        guard let postViewModel = posts.first else { return nil }

        return postViewModel.imageData
    }

    public func startFetchingStories(filteredBy filter: Filter?) async throws {
        fatalError("Not implemented")
    }
}
