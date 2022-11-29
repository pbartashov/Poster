//
//  User.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit

//import FirebaseFirestore
//import FirebaseFirestoreSwift


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
                birthDate: Date? = nil
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
    }

//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        uid = try container.decode(String.self, forKey: .uid)
//        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
//        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
//        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
//        status = try container.decodeIfPresent(String.self, forKey: .status)
//        nativeTown = try container.decodeIfPresent(String.self, forKey: .nativeTown)
//
////        if let key = CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey"),
////           let docRef = decoder.userInfo[key] as,
////           let avatarData = docRef[CodingKeys.avatarData.rawValue] as? Data {
////            self.avatarData = avatarData
////        }
//
//        container.codingPath.forEach { print($0)
//        }
//
//        let V = container.codingPath
//
//        let a = try decoder.singleValueContainer()
////        let b = try a.decode([String: Any].self)
////        let c = try a.decode([String: AnyObject].self)
//        let avatarData = try container.decode([UInt8].self, forKey: .avatarData)
//        self.avatarData = Data(avatarData)
//        gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
//        birthDate = try container.decodeIfPresent(Date.self, forKey: .birthDate)
//
//
//
//    }
//
//
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(uid, forKey: .uid)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
//        try container.encode(phoneNumber, forKey: .phoneNumber)
//        try container.encode(status, forKey: .status)
//        try container.encode(nativeTown, forKey: .nativeTown)
//        try container.encode(gender, forKey: .gender)
//        try container.encode(birthDate, forKey: .birthDate)
//
//        // Workaround for "Expected to decode String but found _NSInlineData instead"
//        if let avatarData = avatarData {
//            let dataWrapper = DataWrapper(data: avatarData)
//
////            let bytes = String(bytes: avatarData, encoding: .utf8)
//            try container.encode(dataWrapper, forKey: .avatarData)
//        }
//    }
}

public struct DataWrapper: Codable {
    let data: Data
}
