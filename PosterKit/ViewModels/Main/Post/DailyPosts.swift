//
//  DailyPosts.swift
//  PosterKit
//
//  Created by Павел Барташов on 10.12.2022.
//

public struct DailyPosts {
    public let timestamp: Date
    public let title: String
    public var posts: [PostViewModel]
}

extension DailyPosts: Hashable { }
