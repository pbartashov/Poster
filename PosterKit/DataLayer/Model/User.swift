//
//  User.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import UIKit
#warning("remove UIKIT")
#warning("class -> struct")
public struct User {
    public var name: String
    public var avatarData: Data?
    public var status: String

    public init(name: String = "",
                //         avatar: UIImage? = UIImage(systemName: "person"),
                avatarData: Data? = nil,
                status: String = ""
    ) {
        self.name = name
        self.avatarData = avatarData
        self.status = status
    }
}

extension User: Hashable { }
