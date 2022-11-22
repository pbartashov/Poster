//
//  MockStories.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 17.11.2022.
//

import UIKit
import PosterKit

extension Story {
    static let mock: [Story] = [
        Story(url: "1", author: User(id: "1", name: "u1", avatarData: UIImage(systemName: "camera.macro")?.pngData())),
        Story(url: "2", author: User(id: "2", name: "u2", avatarData: UIImage(systemName: "key.viewfinder")?.pngData())),
        Story(url: "3", author: User(id: "3", name: "u3", avatarData: UIImage(systemName: "person.badge.key")?.pngData()))
    ]
}
