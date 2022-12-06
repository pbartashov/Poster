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

    public func createPost(authorId: String, content: String, imageData: Data?) async throws {
        #warning("TODO")
    }

    public func store(post: Post) async throws {
        try await repository.save(post: post)
        try await repository.saveChanges()
    }

    public func remove(post: Post) async throws {
        try await repository.delete(post: post)
        try await repository.saveChanges()
    }
}
