//
//  StorageProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 26.11.2022.
//

import Combine

//public protocol StorageServiceProtocol {
//    var postsPublisher: AnyPublisher<[Post], Never> { get }
//    //    func getPosts(filteredBy: Filter, comlpetion: @escaping (Result<[Post], PostServiceError>) -> Void)
//    func startFetchingPosts(filteredBy filter: Filter) throws
////    func store(post: Post) async throws
//    func createPost(authorId: String, content: String, imageData: Data?) async throws -> Post
//    func remove(post: Post) async throws
//}

public protocol StorageReaderProtocol {
    var postsPublisher: AnyPublisher<[Post], Never> { get }
    func startFetchingPosts(filteredBy filter: Filter) async throws

    func getUser(byId uid: String) async throws -> User?
    func getImageData(byId uid: String) async throws -> Data?
}








public protocol StorageWriterProtocol {
    func createPost(authorId: String, content: String, imageData: Data?) async throws
    func store(post: Post, imageData: Data?) async throws
//    func store(photo: Data?) async throws
    func remove(post: Post) async throws
}

