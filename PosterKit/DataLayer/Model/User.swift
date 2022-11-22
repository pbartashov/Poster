//
//  User.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit


public struct User {
    public var id: String
    public var name: String
    public var avatarData: Data?
    public var status: String

    public init(id: String,
                name: String = "",
                //         avatar: UIImage? = UIImage(systemName: "person"),
                avatarData: Data? = nil,
                status: String = ""
    ) {
        self.id = id
        self.name = name
        self.avatarData = avatarData
        self.status = status
    }
}

extension User: Hashable { }

extension User: Codable {
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarData = "avatar_data"
        case status
    }
}
