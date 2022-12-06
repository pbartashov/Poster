//
//  User.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit

public struct User {
    public var uid: String
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var avatarData: Data?
    public var status: String?
    public var nativeTown: String?
    public var gender: Gender?
    public var birthDate: Date?
    public var publishedPostsCount: Int?
    public var subsribesCount: Int?
    public var followersCount: Int?

    public var displayedName: String {
        var displayedName = ""

        if let firstName = firstName {
            displayedName = firstName
        }

        if let lastName = lastName {
            displayedName += " \(lastName)"
        }

        if displayedName.isEmpty {
            displayedName = phoneNumber ?? ""
        }

        return displayedName
    }

    public init(uid: String,
                firstName: String? = nil,
                lastName: String? = nil,
                phoneNumber: String? = nil,
                avatarData: Data? = nil,
                status: String? = nil,
                nativeTown: String? = nil,
                gender: Gender? = nil,
                birthDate: Date? = nil,
                publishedPostsCount: Int? = nil,
                subsribesCount: Int? = nil,
                followersCount: Int? = nil
    ) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.avatarData = avatarData
        self.status = status
        self.nativeTown = nativeTown
        self.gender = gender
        self.birthDate = birthDate
        self.publishedPostsCount = publishedPostsCount
        self.subsribesCount = subsribesCount
        self.followersCount = followersCount
    }
}

extension User: Hashable { }

extension User: Codable {
    public enum CodingKeys: String, CodingKey {
        case uid
        case firstName
        case lastName
        case phoneNumber
        case avatarData = "avatar_data"
        case status
        case nativeTown
        case gender
        case birthDate
        case publishedPostsCount
        case subsribesCount
        case followersCount
    }
}
