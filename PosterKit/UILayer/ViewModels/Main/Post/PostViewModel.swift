//
//  PostViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

import Combine

public final class PostViewModel {

    // MARK: - Properties
    private let storageReader: StorageReaderProtocol?
    private let favoritesPostsHashProvider: FavoritesPostsHashProvider?

    @Published public var authorAvatarData: Data?
    @Published public var imageData: Data?
    @Published public var author: User?
    @Published public var authorName: String?
    @Published public var authorStatus: String?
    @Published public var isFavorite: Bool?
//    public let postUid: String
//    public let authorId: String
    public let post: Post
    public var content: String { post.content }
    public var likes: Int { post.likes }
    public var views: Int { post.views }

    // MARK: - LifeCicle

    public init(from post: Post,
                storageReader: StorageReaderProtocol? = nil,
                favoritesPostsHashProvider: FavoritesPostsHashProvider? = nil
    ) {
        self.post = post
        self.storageReader = storageReader
        self.favoritesPostsHashProvider = favoritesPostsHashProvider

        initialize()
    }

    // MARK: - Metods

    private func initialize() {
        let hash = post.uid.hashValue
        favoritesPostsHashProvider?.hashPublisher
            .map { $0.contains(hash) }
            .assign(to: &$isFavorite)
    }

    public func fetchData() {
        Task {
            try await withThrowingTaskGroup(of: (User?, Data?).self) { [self] group in
                guard let storageReader = storageReader else { return }
                group.addTask { [self] in
                    let user = try? await storageReader.getUser(byId: post.authorId)
                    return (user, nil)
                }

                group.addTask { [self] in
                    let postImageData = try? await storageReader.getImageData(byId: post.uid)
                    return (nil, postImageData)
                }

                for try await (user, postImageData) in group {
                    if let user = user {
                        author = user
                        authorName = user.displayedName
                        authorStatus = user.status
                        authorAvatarData = user.avatarData
                    } else if let postImageData = postImageData {
                        imageData = postImageData
                    }
                }
            }

            //            if let user = try? await storageReader.getUser(byId: post.authorId) {
            //                postViewModel.authorName = user.name
            //                postViewModel.authorAvatar = user.avatarData
            //            }
            //
            //            if let postImageData = try? await storageReader.getImageData(byId: post.uid) {
            //                postViewModel.imageData = postImageData
            //            }
        }
    }
}

extension PostViewModel: Hashable {
    public static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        lhs.post == rhs.post
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(post)
    }
}
