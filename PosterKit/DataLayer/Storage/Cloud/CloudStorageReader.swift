//
//  CloudStorageReader.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

import Combine

final public class CloudStorageReader: StorageReaderProtocol {

    // MARK: - Properties

    private let userCloudStorage: UserStorageProtocol
    private let postCloudStorage: PostCloudStorageProtocol
    private let imageCloudStorage: ImageCloudStorageProtocol
    private let storyCloudStorage: StoryCloudStorageProtocol?

    private let postsSubject = CurrentValueSubject<[Post], Never>([])

    public var postsPublisher: AnyPublisher<[Post], Never> {
        postsSubject.eraseToAnyPublisher()
    }

    private let storiesSubject = CurrentValueSubject<[Story], Never>([])

    public var storiesPublisher: AnyPublisher<[Story], Never>? {
        storiesSubject.eraseToAnyPublisher()
    }

    // MARK: - LifeCicle

    public init(userCloudStorage: UserStorageProtocol,
                postCloudStorage: PostCloudStorageProtocol,
                imageCloudStorage: ImageCloudStorageProtocol,
                storyCloudStorage: StoryCloudStorageProtocol? = nil
    ) {
        self.userCloudStorage = userCloudStorage
        self.postCloudStorage = postCloudStorage
        self.imageCloudStorage = imageCloudStorage
        self.storyCloudStorage = storyCloudStorage
    }

    // MARK: - Metods
    public func startFetchingPosts(filteredBy filter: Filter) async throws {
        var postFilter = filter
        if let authorName = filter.authorName {
            let userFilter = Filter(authorName: authorName)
            let userIds = try await userCloudStorage.getUsers(filteredBy: userFilter)
            postFilter.authorIds = userIds.map { $0.uid }
            postFilter.authorName = nil
        }

        let posts = try await postCloudStorage.getPosts(filteredBy: postFilter)
        postsSubject.send(posts)
    }

    public func getUser(byId uid: String) async throws -> User? {
        try await userCloudStorage.getUser(byId: uid)
    }

    public func getImageData(byId uid: String) async throws -> Data? {
        try await imageCloudStorage.getImageData(withFileName: uid)
    }

    public func startFetchingStories(filteredBy filter: Filter?) async throws {
        if let stories = try await storyCloudStorage?.getStories(filteredBy: filter) {
            storiesSubject.send(stories)
        }
    }
}
