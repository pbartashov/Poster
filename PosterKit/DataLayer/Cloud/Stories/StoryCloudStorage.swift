//
//  StoryCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 05.12.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol StoryCloudStorageProtocol {
    func createStory(authorId: String, storyData: Data?, description: String?) async throws -> Story
    func save(story: Story) async throws
    func getStories(filteredBy filter: Filter?) async throws -> [Story]
}

extension StoryCloudStorageProtocol {
    func getStories(filteredBy filter: Filter? = nil) async throws -> [Story] {
        try await getStories(filteredBy: filter)
    }
}

public final class StoryCloudStorage: StoryCloudStorageProtocol {

    // MARK: - Properties

    private let database = Firestore.firestore()
    private var storiesCollectionRef: CollectionReference {
        database.collection(Constants.Cloud.storiesCollection)
    }

    // MARK: - LifeCicle

    public init(
        //        imageStorage: ImageCloudStorageProtocol
    ) {
        //        self.imageStorage = imageStorage
    }

    // MARK: - Metods

    public func createStory(authorId: String,
                            storyData: Data?,
                            description: String?
    ) async throws -> Story {
        let newStoryRef = storiesCollectionRef.document()
        let newStory = Story(uid: newStoryRef.documentID,
                             authorId: authorId,
                             storyData: storyData,
                             description: description)

        let addition = [Constants.Cloud.timestamp: FieldValue.serverTimestamp()]
        try await store(story: newStory, at: newStoryRef, with: addition)

        return newStory
    }

    public func save(story: Story) async throws {
        let storyRef = storiesCollectionRef.document(story.uid)
        let document = try await storyRef.getDocument().data()
        let timestamp = document?[Constants.Cloud.timestamp] ?? FieldValue.serverTimestamp()

        let addition: [String: Any] = [Constants.Cloud.timestamp: timestamp]
        try await store(story: story, at: storyRef, with: addition)
    }

    private func store(story: Story,
                       at postRef: DocumentReference,
                       with addition: [String: Any]
    ) async throws {
        try postRef.setData(from: story)
        try await postRef.updateData(addition)
    }

    public func getStories(filteredBy filter: Filter?) async throws -> [Story] {
        let query = getQuery(filteredBy: filter)
        let result = try await query.getDocuments()

        return try result.documents.map {
            try $0.data(as: Story.self)
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

    private func getQuery(filteredBy filter: Filter?) -> Query {
        var query = storiesCollectionRef.order(by: Constants.Cloud.timestamp, descending: true)
        guard var filter = filter else { return query }
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



