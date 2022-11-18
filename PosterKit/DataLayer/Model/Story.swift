//
//  Story.swift
//  PosterKit
//
//  Created by Павел Барташов on 17.11.2022.
//

public struct Story {
    public let url: String
    public let author: User
    public let description: String

    public init(url: String,
                author: User,
                description: String = ""
    ) {
        self.url = url
        self.author = author
        self.description = description
    }
}

extension Story: Hashable { }
