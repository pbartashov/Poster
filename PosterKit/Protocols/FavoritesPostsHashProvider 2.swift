//
//  FavoritesPostsHashProvider.swift
//  PosterKit
//
//  Created by Павел Барташов on 06.12.2022.
//

import Combine

public protocol FavoritesPostsHashProvider {
    var hashPublisher: AnyPublisher<[Int], Never> { get }
}
