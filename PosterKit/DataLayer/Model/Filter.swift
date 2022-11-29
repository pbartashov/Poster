//
//  Filter.swift
//  PosterKit
//
//  Created by Павел Барташов on 18.11.2022.
//

public struct Filter {
    public var authorName: String?
    public var authorId: String?
    public var content: String?
    public var authorIds: [String]?

    public init(authorName: String? = nil,
                authorId: String? = nil,
                content: String? = nil,
                authorIds: [String]? = nil
    ) {
        self.authorName = authorName
        self.authorId = authorId
        self.content = content
        self.authorIds = authorIds
    }
}
