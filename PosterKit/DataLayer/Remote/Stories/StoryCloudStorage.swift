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

    public init() { }

    // MARK: - Metods

    public func createStory(authorId: String,
                            storyData: Data?,
                            description: String?
    ) async throws -> Story {
        let newStoryRef = storiesCollectionRef.document()
        let newStory = Story(uid: newStoryRef.documentID,
                             timestamp: .now,
                             authorId: authorId,
                             storyData: storyData,
                             description: description)
        try newStoryRef.setData(from: newStory)
        try await newStoryRef.updateData([
            Story.CodingKeys.timestamp.rawValue: FieldValue.serverTimestamp()
        ])

        return newStory
    }

    public func save(story: Story) async throws {
        let storyRef = storiesCollectionRef.document(story.uid)
        try storyRef.setData(from: story)
    }

    public func getStories(filteredBy filter: Filter?) async throws -> [Story] {
        let query = getQuery(filteredBy: filter)
        let result = try await query.getDocuments()

        return try result.documents.map {
            try $0.data(as: Story.self)
        }
    }

    private func getQuery(filteredBy filter: Filter?) -> Query {
        var query = storiesCollectionRef.order(by: Story.CodingKeys.timestamp.rawValue, descending: true)
        guard let filter = filter else { return query }
        if let authorId = filter.authorId {
            query = query
                .whereField(Story.CodingKeys.authorId.rawValue, isEqualTo: authorId)
        } else if let authorIds = filter.authorIds {
            query = query
                .whereField(Story.CodingKeys.authorId.rawValue, in: authorIds)
        }

        if let _ = filter.content {
            //#warning("TODO")
        }
        return query
    }
}
