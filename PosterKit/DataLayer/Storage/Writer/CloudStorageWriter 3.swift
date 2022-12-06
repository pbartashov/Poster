//
//  CloudStorageWriter.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

final public class CloudStorageWriter: StorageWriterProtocol {

    // MARK: - Properties

    private let postCloudStorage: PostCloudStorageProtocol
    private let imageCloudStorage: ImageCloudStorageProtocol

    // MARK: - LifeCicle

    public init(postCloudStorage: PostCloudStorageProtocol,
                imageCloudStorage: ImageCloudStorageProtocol
    ) {
        self.postCloudStorage = postCloudStorage
        self.imageCloudStorage = imageCloudStorage
    }

    // MARK: - Metods

    public func createPost(authorId: String, content: String, imageData: Data?) async throws {
        let newPost = try await postCloudStorage.createPost(authorId: authorId, content: content)
        if let imageData = imageData {
            try await imageCloudStorage.store(imageData: imageData, forId: newPost.uid)
        }
    }

    public func store(post: Post) async throws {
#warning("TODO")
    }


    public func remove(post: Post) async throws {
#warning("TODO")
    }
}

