//
//  LocalStorageWriter.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

final public class LocalStorageWriter: StorageWriterProtocol {

    // MARK: - Properties

    private let repository: PostRepositoryInterface

    // MARK: - LifeCicle

    public init(repository: PostRepositoryInterface) {
        self.repository = repository
    }

    // MARK: - Metods

    public func createPost(author: User, content: String, imageData: Data?) async throws {
        fatalError("NotImplemented")
    }

    public func store(post: Post, imageData: Data?, author: User?) async throws {
        let postViewModel = PostViewModel(from: post)
        postViewModel.authorName = author?.displayedName
        postViewModel.authorStatus = author?.status
        postViewModel.authorAvatarData = author?.avatarData
        postViewModel.imageData = imageData
        
        try await repository.save(post: postViewModel)
        try await repository.saveChanges()
    }

    public func remove(post: Post) async throws {
        let postViewModel = PostViewModel(from: post)
        try await repository.delete(post: postViewModel)
        try await repository.saveChanges()
    }
}
