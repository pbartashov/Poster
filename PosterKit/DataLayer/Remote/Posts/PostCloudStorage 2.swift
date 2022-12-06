//
//  PostCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 23.11.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol PostCloudStorageProtocol {
//    func store(post: Post) async throws
    func createPost(authorId: String, content: String) async throws -> Post

    func getPosts(filteredBy filter: Filter) async throws -> [Post]
}

public final class PostCloudStorage: PostCloudStorageProtocol {

    // MARK: - Properties
    
//    private let imageStorage: ImageCloudStorageProtocol

    private let database = Firestore.firestore()
    private var postsCollectionRef: CollectionReference {
        database.collection(Constants.Cloud.postsCollection)
    }

    // MARK: - LifeCicle

    public init(
//        imageStorage: ImageCloudStorageProtocol
    ) {
//        self.imageStorage = imageStorage
    }

    // MARK: - Metods

    public func createPost(authorId: String,
                           content: String
    ) async throws -> Post {
        let newPostRef = postsCollectionRef.document()
        let newPost = Post(uid: newPostRef.documentID,
                        authorId: authorId,
                        content: content)
//                        imageUrl: imageRef.fullPath)

        try newPostRef.setData(from: newPost)
        try await newPostRef.updateData([
            Constants.Cloud.timestamp: FieldValue.serverTimestamp()
        ])

        return newPost
    }

//    public func store(post: Post) async throws {
//        let cloudPost = Post(from: post, imageURL: "")
//
////      postImageView.image = await Task.detached {
////            await withCheckedContinuation { continuation in
////                ImageProcessor()
////                    .processImage(sourceImage: image, filter: filter) { processed in
////                        continuation.resume(returning: processed)
////                    }
////            }
////        }
////        .value
//
//
//
//        let documentRef = try collectionRef.addDocument(from: cloudPost)
//
//        try await documentRef.updateData([
//            Constants.Cloud.timestamp: FieldValue.serverTimestamp(),
//            ])
//    }

    public func getPosts(filteredBy filter: Filter) async throws -> [Post] {
        let query = getQuery(filteredBy: filter)
        let result = try await query.getDocuments()

        return try result.documents.map {
            try $0.data(as: Post.self)
        }

//
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                }
//            }

//        let collectionRef = database.collection(CloudConstants.usersCollection)
//        let docRef = collectionRef.document(id)
//
//        do {
//            return try await docRef.getDocument(as: User.self)
//        } catch DecodingError.valueNotFound {
//            return nil
//        } catch {
//            throw DatabaseError.notFound
//        }
    }

    private func getQuery(filteredBy filter: Filter) -> Query {
        var query = postsCollectionRef.order(by: Constants.Cloud.timestamp)
        if let authorId = filter.authorId {
            query = query
                .whereField(Post.CodingKeys.authorId.rawValue, isEqualTo: authorId)
        } else if let authorIds = filter.authorIds {
            query = query
                .whereField(Post.CodingKeys.authorId.rawValue, in: authorIds)
        }

        if let content = filter.content {
            #warning("TODO")
        }
        return query
    }
}


