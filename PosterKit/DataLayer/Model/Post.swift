//
//  Post.swift
//  PosterKit
//
//  Created by Павел Барташов on 06.03.2022.
//

public struct Post {
    public let uid: String
    public let authorId: String
    public let content: String
    public let likes: Int
    public let views: Int

    public init(uid: String,
                authorId: String,
                content: String = "",
                likes: Int = 0,
                views: Int = 0
    ) {
        self.uid = uid
        self.authorId = authorId
        self.content = content
        self.likes = likes
        self.views = views
    }
}

extension Post: Hashable { }

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case uid
        case authorId = "author_id"
        case content
        case likes
        case views
    }
}
