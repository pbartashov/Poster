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
                           authorId: authorId,
                           content: content)
        let addition = [Constants.Cloud.timestamp: FieldValue.serverTimestamp()]
        try await store(post: newPost, at: newPostRef, with: addition)

        return newPost
    }

    public func save(post: Post) async throws {
        let postRef = postsCollectionRef.document(post.uid)
        let document = try await postRef.getDocument().data()
        let timestamp = document?[Constants.Cloud.timestamp] ?? FieldValue.serverTimestamp()

        let addition: [String: Any] = [Constants.Cloud.timestamp: timestamp]
        try await store(post: post, at: postRef, with: addition)
    }

    private func store(post: Post,
                       at postRef: DocumentReference,
                       with addition: [String: Any]
    ) async throws {
        try postRef.setData(from: post)
        try await postRef.updateData(addition)
    }

    public func getPosts(filteredBy filter: Filter) async throws -> [Post] {
        let query = getQuery(filteredBy: filter)
        let result = try await query.getDocuments()

        return try result.documents.map {
            try $0.data(as: Post.self)
        }
    }

    private func getQuery(filteredBy filter: Filter) -> Query {
        var query = postsCollectionRef.order(by: Constants.Cloud.timestamp, descending: true)
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
