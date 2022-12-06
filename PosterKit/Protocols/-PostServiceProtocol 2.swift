//
//  PostServiceProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//
//import Combine
//
//public protocol PostServiceProtocol {
//    var postsPublisher: AnyPublisher<[Post], Never> { get }
////    func getPosts(filteredBy: Filter, comlpetion: @escaping (Result<[Post], PostServiceError>) -> Void)
//    func startFetchingPosts(filteredBy filter: Filter) async throws
//    func store(post: Post) async throws
//    func remove(post: Post) async throws
//}

//
//public protocol PostReaderProtocol {
//    var postsPublisher: AnyPublisher<[Post], Never> { get }
//    func requestPosts(filteredBy filter: Filter) async throws
//}
//
//public protocol PostWriterProtocol {
//    func store(post: Post) async throws
//    func remove(post: Post) async throws
//}
//
//public class CloudPostServiceWithLocalStorage: PostReaderProtocol&PostWriterProtocol {
//
//    // MARK: - Properties
//    let postSubject = CurrentValueSubject<[Post], Never>([])
//    public var postsPublisher: AnyPublisher<[Post], Never> {
//        postSubject.eraseToAnyPublisher()
//    }
//
//    let reader: PostRepositoryInterface
//    let writer: PostRepositoryInterface
//
//    // MARK: - Views
//
//    // MARK: - LifeCicle
//    public init(reader: PostRepositoryInterface,
//                writer: PostRepositoryInterface
//) {
//        self.reader = reader
//        self.writer = writer
//    }
//    // MARK: - Metods
//
//
//    public func store(post: Post) async throws {
//        try await writer.save(post: post)
//        try await writer.saveChanges()
//    }
//
//    public func remove(post: Post) async throws {
//        try await writer.delete(post: post)
//        try await writer.saveChanges()
//    }
//
//    public func requestPosts(filteredBy: Filter) async throws {
//        let posts = try await reader.getPosts(predicate: nil)
//        postSubject.send(posts)
//
//        reader.setupResultsControllerStateChangedHandler(stateChanged: <#T##((FetchResultServiceState) -> Void)?##((FetchResultServiceState) -> Void)?##(FetchResultServiceState) -> Void#>)
//    }
//}
//
//
//extension PostRepositoryInterface {
//
//    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?) { }
//
//    func startFetchingWith(predicate: NSPredicate?,
//                           sortDescriptors: [NSSortDescriptor]?) throws { }
//}
//
//
//struct nee: PostRepositoryInterface {
//    var fetchResults: [Post]
//
//    func getPosts(predicate: NSPredicate?) async throws -> [Post] {
//
//    }
//
//    func create(post: Post) async throws {
//        ()
//    }
//
//    func save(post: Post) async throws {
//        ()
//    }
//
//    func delete(post: Post) async throws {
//        ()
//    }
//
//    func saveChanges() async throws {
//        ()
//    }
//
//
//}
