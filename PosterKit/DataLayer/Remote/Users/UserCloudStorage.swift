//
//  UserCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 22.11.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol UserStorageProtocol {
    func createUser(uid: String, phoneNumber: String) throws -> User
    func getUser(byId: String) async throws -> User?
    func getUsers(filteredBy filter: Filter) async throws -> [User]
    func save(user: User) throws
}

public struct UserCloudStorage: UserStorageProtocol {

    // MARK: - Properties

    private let database = Firestore.firestore()

    private var usersCollectionRef: CollectionReference {
        database.collection(Constants.Cloud.usersCollection)
    }

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    public func createUser(uid: String, phoneNumber: String) throws -> User {
        let user = User(uid: uid, phoneNumber: phoneNumber)
        try save(user: user)

        return user
    }

    public func getUser(byId id: String) async throws -> User? {
        let documentRef = usersCollectionRef.document(id)

        do {
            return try await documentRef.getDocument(as: User.self)
        } catch DecodingError.valueNotFound {
            return nil
        } catch {
            throw DatabaseError.notFound
        }
    }

    public func getUsers(filteredBy filter: Filter) async throws -> [User] {
        let result: QuerySnapshot
        if let query = apply(filter: filter) {
            result = try await query.getDocuments()
        } else {
            result = try await usersCollectionRef.getDocuments()
        }

        return try result.documents.map {
            try $0.data(as: User.self)
        }
    }

    public func save(user: User) throws {
        let documentRef = usersCollectionRef.document(user.uid)
        try documentRef.setData(from: user)
    }

    private func apply(filter: Filter) -> Query? {
        var query: Query? = nil

        if let authorName = filter.authorName {
            query = usersCollectionRef
                .whereField(User.CodingKeys.lastName.rawValue, isEqualTo: authorName)
        }
        return query
    }
}
