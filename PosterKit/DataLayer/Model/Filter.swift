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
    public var isRecommended: Bool?

    public init(authorName: String? = nil,
                authorId: String? = nil,
                content: String? = nil,
                authorIds: [String]? = nil,
                isRecommended: Bool? = nil
    ) {
        self.authorName = authorName
        self.authorId = authorId
        self.content = content
        self.authorIds = authorIds
        self.isRecommended = isRecommended
    }
}

extension Filter {
    func concatenated(to outher: Filter) -> Filter {
        Filter(authorName: outher.authorName ?? self.authorName,
               authorId: outher.authorId ?? self.authorId,
               content: outher.content ?? self.content,
               authorIds: outher.authorIds ?? self.authorIds,
               isRecommended: outher.isRecommended ?? self.isRecommended)
    }
}
