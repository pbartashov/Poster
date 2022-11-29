//
//  UserService.swift
//  PosterKit
//
//  Created by Павел Барташов on 20.11.2022.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol UserServiceProtocol: AnyObject {
    var currentUser: User? { get }

    func setCurrentUser(byId: String, phoneNumber: String) async throws
    func save(_ user: User) throws
    func reloadCurrentUser() async throws
}

public final class UserService: UserServiceProtocol {

    // MARK: - Properties
    
    private let userStorage: UserStorageProtocol

    public var currentUser: User?

    // MARK: - LifeCicle

    public init(userStorage: UserStorageProtocol) {
        self.userStorage = userStorage
    }

    // MARK: - Metods

    public func setCurrentUser(byId id: String, phoneNumber: String) async throws {
        do {
            if let user = try await userStorage.getUser(byId: id) {
                currentUser = user
            } else {
                currentUser = try userStorage.createUser(uid: id, phoneNumber: phoneNumber)
            }
        } catch {
            throw LoginError.userNotFound
        }
    }

    public func save(_ user: User) throws  {
        try userStorage.save(user: user)
    }

    public func reloadCurrentUser() async throws {
        if let currentUser = currentUser,
           let user = try? await userStorage.getUser(byId: currentUser.uid) {
            self.currentUser = user
        } else {
            throw LoginError.userNotFound
        }
    }
}
