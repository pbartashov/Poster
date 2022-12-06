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
//
//        documentRef.getDocument { snapshot, errror in
//            if let data = snapshot?.data() {
//                let avatar_data = data["avatar_data"]
//                let avatat = avatar_data as? Data
//                print(avatat)
//            }
//
//        }




        do {
            return try await documentRef.getDocument(as: User.self)
        } catch DecodingError.valueNotFound {
            return nil
        } catch {
            #warning("REMOVE")
            print(error)
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
//        var fields: [AnyHashable : Any] = [:]
//        add(to: &fields, field: .firstName, with: user.firstName)
//        add(to: &fields, field: .lastName, with: user.lastName)
//        add(to: &fields, field: .phoneNumber, with: user.phoneNumber)
////        add(to: &fields, field: .avatarData, with: user.avatarData)
//        add(to: &fields, field: .status, with: user.status)
//        add(to: &fields, field: .nativeTown, with: user.nativeTown)
//        add(to: &fields, field: .gender, with: user.gender)
//        add(to: &fields, field: .birthDate, with: user.birthDate)
//
        let documentRef = usersCollectionRef.document(user.uid)
//
//        if let avatarData = user.avatarData {
//            try await documentRef.updateData([
//                User.CodingKeys.avatarData.rawValue: Array<UInt8>(avatarData)
//            ])
//        }

        try documentRef.setData(from: user)

//        if !fields.isEmpty {
//            try await docRef.updateData(fields)
//        }
    }

//    private func add(to fields: inout [AnyHashable : Any], field: User.CodingKeys, with value: Any?) {
//        if let value = value {
//            fields[field.rawValue] = value
//        }
//    }

    private func apply(filter: Filter) -> Query? {
        var query: Query? = nil

        if let authorName = filter.authorName {
            query = usersCollectionRef
                .whereField(User.CodingKeys.lastName.rawValue, isEqualTo: authorName)
        }
        return query
    }
}
