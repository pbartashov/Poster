//
//  CloudPost.swift
//  PosterKit
//
//  Created by Павел Барташов on 23.11.2022.
//
import FirebaseFirestore

struct CloudPost {
//    let documentID
    let authorId: String
    let description: String
    let imageURL: String?
    let likes: Int
    let views: Int
//    let timestamp: FieldValue

    init(authorId: String,
                description: String,
         imageURL: String?,
                likes: Int = 0,
                views: Int = 0
//                timestamp: FieldValue
    ) {
        self.authorId = authorId
        self.description = description
        self.imageURL = imageURL
        self.likes = likes
        self.views = views
//        self.timestamp = timestamp
    }

    init(from post: Post,
         //, timestamp: FieldValue
         imageURL: String?
    ) {
        self.init(authorId: post.author.id,
                  description: post.description,
                  imageURL: imageURL,
                  likes: post.likes,
                  views: post.views)
//                  timestamp: timestamp.da)
    }
}

extension CloudPost: Codable {
    enum CodingKeys: String, CodingKey {
        case authorId = "author_id"
        case description
        case imageURL = "image_url"
        case likes
        case views
//        case timestamp
    }
}
