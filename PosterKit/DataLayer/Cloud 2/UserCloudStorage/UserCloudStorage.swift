//
//  UserCloudStorage.swift
//  PosterKit
//
//  Created by Павел Барташов on 22.11.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol UserStorageProtocol {
    func createUser(id: String, phoneNumber: String) throws -> User
    func getUser(byId: String) async throws -> User?
}

public struct UserCloudStorage: UserStorageProtocol {

    // MARK: - Properties

    private let database = Firestore.firestore()

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    public func createUser(id: String, phoneNumber: String) throws -> User {
        let user = User(id: id, name: phoneNumber)
        let collectionRef = database.collection(Constants.Cloud.usersCollection)
        let docRef = collectionRef.document(id)
        try docRef.setData(from: user)

        return user
    }

    public func getUser(byId id: String) async throws -> User? {
        let collectionRef = database.collection(Constants.Cloud.usersCollection)
        let docRef = collectionRef.document(id)

        do {
            return try await docRef.getDocument(as: User.self)
        } catch DecodingError.valueNotFound {
            return nil
        } catch {
            throw DatabaseError.notFound
        }
    }
}
