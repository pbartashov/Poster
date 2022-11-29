//
//  PostCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 23.11.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol PostCloudStorageProtocol {
    func store(post: Post) async throws
    func getPosts() async throws -> [Post]
}

public final class PostCloudStorage: PostCloudStorageProtocol {

    // MARK: - Properties

    private let database = Firestore.firestore()
    private lazy var collectionRef = database.collection(Constants.Cloud.postsCollection)

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    public func store(post: Post) async throws {
        let cloudPost = CloudPost(from: post, imageURL: "")

//      postImageView.image = await Task.detached {
//            await withCheckedContinuation { continuation in
//                ImageProcessor()
//                    .processImage(sourceImage: image, filter: filter) { processed in
//                        continuation.resume(returning: processed)
//                    }
//            }
//        }
//        .value



        let documentRef = try collectionRef.addDocument(from: cloudPost)

        try await documentRef.updateData([
            Constants.Cloud.timestamp: FieldValue.serverTimestamp(),
            ])
    }

    public func getPosts() async throws -> [Post] {
[]

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

}


