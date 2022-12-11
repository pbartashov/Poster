//
//  PostCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 23.11.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol PostCloudStorageProtocol {
    func createPost(authorId: String, content: String) async throws -> Post
    func save(post: Post) async throws
    func getPosts(filteredBy filter: Filter) async throws -> [Post]
}

public final class PostCloudStorage: PostCloudStorageProtocol {

    // MARK: - Properties

    private let database = Firestore.firestore()
    private var postsCollectionRef: CollectionReference {
        database.collection(Constants.Cloud.postsCollection)
    }

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    public func createPost(authorId: String,
                           content: String
    ) async throws -> Post {
        let newPostRef = postsCollectionRef.document()
        let newPost = Post(uid: newPostRef.documentID,
                           timestamp: .now,
                           authorId: authorId,
                           content: content)
        try newPostRef.setData(from: newPost)
        try await newPostRef.updateData([
            Post.CodingKeys.timestamp.rawValue: FieldValue.serverTimestamp()
        ])

        return newPost
    }

    public func save(post: Post) async throws {
        let postRef = postsCollectionRef.document(post.uid)
        try postRef.setData(from: post)
    }

    public func getPosts(filteredBy filter: Filter) async throws -> [Post] {
        let query = getQuery(filteredBy: filter)
        let result = try await query.getDocuments()

        return try result.documents.map {
            try $0.data(as: Post.self)
        }
    }

    private func getQuery(filteredBy filter: Filter) -> Query {
        var query = postsCollectionRef.order(by: Post.CodingKeys.timestamp.rawValue, descending: true)
        if let authorId = filter.authorId {
            query = query
                .whereField(Post.CodingKeys.authorId.rawValue, isEqualTo: authorId)
        } else if let authorIds = filter.authorIds {
            query = query
                .whereField(Post.CodingKeys.authorId.rawValue, in: authorIds)
        }

        if let isRecommended = filter.isRecommended {
            query = query
                .whereField(Constants.Cloud.isRecommended, isEqualTo: isRecommended)
        }

        if let _ = filter.content {
            //#warning("TODO")
        }
        return query
    }
}
