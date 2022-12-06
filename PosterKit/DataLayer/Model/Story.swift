//
//  Story.swift
//  PosterKit
//
//  Created by Павел Барташов on 17.11.2022.
//

public struct Story {
    public let uid: String
    public let authorId: String
    public let storyData: Data?
    public let description: String?

    public init(uid: String,
                authorId: String,
                storyData: Data? = nil,
                description: String? = nil
    ) {
        self.uid = uid
        self.authorId = authorId
        self.storyData = storyData
        self.description = description
    }
}

extension Story: Hashable { }

extension Story: Codable {
    enum CodingKeys: String, CodingKey {
        case uid
        case authorId = "author_id"
        case storyData
        case description
    }
}
