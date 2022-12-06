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

    public func createPost(author: User, content: String, imageData: Data?) async throws {
        let newPost = try await postCloudStorage.createPost(authorId: author.uid, content: content)
        if let imageData = imageData {
            try await imageCloudStorage.store(imageData: imageData, withFileName: newPost.uid)
        }
    }

    public func store(post: Post, imageData: Data?, author: User?) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { [postCloudStorage] in
                try await postCloudStorage.save(post: post)
            }

            if let imageData = imageData {
                group.addTask { [imageCloudStorage] in
                    try await imageCloudStorage.store(imageData: imageData, withFileName: post.uid)
                }
            }

            try await group.waitForAll()
        }
    }

    public func remove(post: Post) async throws {
        fatalError("NotImplemented")
    }
}
