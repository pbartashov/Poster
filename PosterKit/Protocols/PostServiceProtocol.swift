//
//  PostServiceProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//
import Combine

public protocol PostServiceProtocol {
    var postsPublisher: AnyPublisher<[Post], Never> { get }
//    func getPosts(filteredBy: Filter, comlpetion: @escaping (Result<[Post], PostServiceError>) -> Void)
    func getPosts(filteredBy filter: Filter) async throws
    func store(post: Post) async throws
    func remove(post: Post) async throws
}
