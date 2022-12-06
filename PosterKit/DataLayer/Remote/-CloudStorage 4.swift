////
////  CloudStorage.swift
////  PosterKit
////
////  Created by Павел Барташов on 05.12.2022.
////
//
//
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//public protocol CloudStorageProtocol {
//    associatedtype T: Codable
//    func createItem(authorId: String, imageData: Data?, textData: String?) async throws -> T
//    func save(item: T) async throws
//    func getItems(filteredBy filter: Filter) async throws -> [T]
//}
//
//public class CloudStorage<T>: CloudStorageProtocol {
//
//    // MARK: - Properties
//    private let collectionName: String
//
//    private let database = Firestore.firestore()
//    private var itemsCollectionRef: CollectionReference {
//        database.collection(collectionName)
//    }
//
//    // MARK: - LifeCicle
//
//    public init(
//        collectionName: String
//    ) {
//        self.collectionName = collectionName
//    }
//
//    // MARK: - Metods
//
//    public func createItem(authorId: String,
//                           imageData: Data?,
//                           textData: String?
//    ) async throws -> T {
//        let newStoryRef = itemsCollectionRef.document()
//        let newStory = Story(uid: newStoryRef.documentID,
//                             authorId: authorId,
//                             storyData: storyData,
//                             description: description)
//
//        let addition = [Constants.Cloud.timestamp: FieldValue.serverTimestamp()]
//        try await store(story: newStory, at: newStoryRef, with: addition)
//
//        return newStory
//    }
//
//    public func save(story: Story) async throws {
//        let storyRef = itemsCollectionRef.document(story.uid)
//        let document = try await storyRef.getDocument().data()
//        let timestamp = document?[Constants.Cloud.timestamp] ?? FieldValue.serverTimestamp()
//
//        let addition: [String: Any] = [Constants.Cloud.timestamp: timestamp]
//        try await store(story: story, at: storyRef, with: addition)
//    }
//
//    private func store(story: Story,
//                       at postRef: DocumentReference,
//                       with addition: [String: Any]
//    ) async throws {
//        try postRef.setData(from: story)
//        try await postRef.updateData(addition)
//    }
//
//    public func getStories(filteredBy filter: Filter) async throws -> [Story] {
//        let query = getQuery(filteredBy: filter)
//        let result = try await query.getDocuments()
//
//        return try result.documents.map {
//            try $0.data(as: Story.self)
//        }
//
//        //
//        //            .getDocuments() { (querySnapshot, err) in
//        //                if let err = err {
//        //                    print("Error getting documents: \(err)")
//        //                } else {
//        //                    for document in querySnapshot!.documents {
//        //                        print("\(document.documentID) => \(document.data())")
//        //                    }
//        //                }
//        //            }
//
//        //        let collectionRef = database.collection(CloudConstants.usersCollection)
//        //        let docRef = collectionRef.document(id)
//        //
//        //        do {
//        //            return try await docRef.getDocument(as: User.self)
//        //        } catch DecodingError.valueNotFound {
//        //            return nil
//        //        } catch {
//        //            throw DatabaseError.notFound
//        //        }
//    }
//
//    private func getQuery(filteredBy filter: Filter) -> Query {
//        var query = itemsCollectionRef.order(by: Constants.Cloud.timestamp, descending: true)
//        if let authorId = filter.authorId {
//            query = query
//                .whereField(Post.CodingKeys.authorId.rawValue, isEqualTo: authorId)
//        } else if let authorIds = filter.authorIds {
//            query = query
//                .whereField(Post.CodingKeys.authorId.rawValue, in: authorIds)
//        }
//
//        if let content = filter.content {
//#warning("TODO")
//        }
//        return query
//    }
//}
//
//
//
