//
//  PostRepository.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData
import Combine

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
/// Protocol that describes a Post repository.
public protocol PostRepositoryInterface {

    var postsPublisher: AnyPublisher<[PostViewModel], Never> { get }

    /// Get a post using a predicate
    func getPosts(predicate: NSPredicate?) async throws -> [PostViewModel]
    /// Creates a Post on the persistance layer.
    func create(post: PostViewModel) async throws
    /// Creates or Updates existing Post on the persistance layer.
    func save(post: PostViewModel) async throws
    /// Deletes a Post from the persistance layer.
    func delete(post: PostViewModel) async throws
    /// Saves changes to Repository.
    func saveChanges() async throws

    //    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?)
    //
    func startFetchingWith(predicate: NSPredicate?,
                           sortDescriptors: [NSSortDescriptor]?) throws
}

/// Post Repository class.
public final class PostRepository {
    /// The Core Data Post repository.
    private let repository: CoreDataRepository<PostEntity>
    
    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    public init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<PostEntity>(managedObjectContext: context)
    }
}

extension PostRepository: PostRepositoryInterface {
    
    public var postsPublisher: AnyPublisher<[PostViewModel], Never> {
        repository.fetchedResultsPublisher
            .map { postEntities in
                postEntities.map { $0.toDomainModel() }
            }
            .eraseToAnyPublisher()
    }
    
    //    private func mapToPosts(postEntities: [PostEntity]) -> [Post] {
    //        postEntities.map { $0.toDomainModel() }
    //    }
    //
    /// Get Posts using a predicate
    public func getPosts(predicate: NSPredicate?) async throws -> [PostViewModel] {
        let postEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        // Transform the NSManagedObject objects to domain objects
        return postEntities.map { $0.toDomainModel() }
    }
    
    /// Creates a Post on the persistance layer.
    public func create(post: PostViewModel) async throws {
        let postEntity = try await repository.create()
        postEntity.copyDomainModel(model: post)
    }
    
    /// Deletes a Post from the persistance layer.
    public func delete(post: PostViewModel) async throws {
        let postEntity = try await getPostEntity(for: post)
        await repository.delete(entity: postEntity)
    }
    
    /// Creates or Updates existing Post on the persistance layer.
    public func save(post: PostViewModel) async throws {
        try await create(post: post)
    }
    
    private func getPostEntity(for post: PostViewModel) async throws -> PostEntity {
        let predicate = NSPredicate(format: "uid == %@", post.post.uid)
        let postEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        guard let postEntity = postEntities.first else {
            throw DatabaseError.notFound
        }
        return postEntity
    }
    
    /// Save the NSManagedObjectContext.
    public func saveChanges() async throws {
        try await repository.saveChanges()
    }
    
    /// Starts fetching with given NSPredicate and array of NSSortDescriptors.
    public func startFetchingWith(predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?) throws {
        var sorting = sortDescriptors
        if sorting == nil {
            sorting = [NSSortDescriptor(keyPath: \PostEntity.uid, ascending: true)]
        }
        
        try repository.startFetchingWith(predicate: predicate, sortDescriptors: sorting)
    }
}
