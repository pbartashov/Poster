//
//  PostRepository+.swift
//  PosterKit
//
//  Created by Павел Барташов on 06.12.2022.
//

import Combine

extension PostRepository: FavoritesPostsHashProvider {
    public var hashPublisher: AnyPublisher<[Int], Never> {
        postsPublisher.map { posts in
            posts.map {
                $0.post.uid.hashValue
            }
        }
        .eraseToAnyPublisher()
    }
}
