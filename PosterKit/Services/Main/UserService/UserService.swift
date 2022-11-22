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
        if let user = try await userStorage.getUser(byId: id) {
            currentUser = user
        } else {
            currentUser = try userStorage.createUser(id: id, phoneNumber: phoneNumber)
        }
    }
}
