//
//  Post.swift
//  PosterKit
//
//  Created by Павел Барташов on 06.03.2022.
//

//import UIKit
#warning("remove UIKIT")

public struct Post {
    public let url: String
    public let author: User
    public let description: String
    public let imageData: Data?
    public let likes: Int
    public let views: Int

    public init(url: String,
                author: User,
                description: String = "",
                imageData: Data? = nil,
                likes: Int = 0,
                views: Int = 0
    ) {
        self.url = url
        self.author = author
        self.description = description
        self.imageData = imageData
        self.likes = likes
        self.views = views
    }
}

extension Post: Hashable { }
