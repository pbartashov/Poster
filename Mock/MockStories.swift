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
        Story(uid: "Text1", authorId: "ZC9eQyVTCPQBD68YOn4mEj7Sx3H3"),
        Story(uid: "Text1", authorId: "gmv6nGLfSUNhjtxiVae4D6UFSbe2"),
        Story(uid: "Text1", authorId: "rs7MzJLnbYXpLf0onnzUAjXmfv42"),
        Story(uid: "Text1", authorId: "tkavg7wj7CT1NBTeflpQ2mK3gqf1"),
        Story(uid: "Text1", authorId: "tkavg7wj7CT1NBTeflpQ2mK3gqf1")
        //        Story(url: "1", author: User(uid: "1", phoneNumber: "u1", avatarData: UIImage(systemName: "camera.macro")?.pngData())),
        //        Story(url: "2", author: User(uid: "2", phoneNumber: "u2", avatarData: UIImage(systemName: "key.viewfinder")?.pngData())),
        //        Story(url: "3", author: User(uid: "3", phoneNumber: "u3", avatarData: UIImage(systemName: "person.badge.key")?.pngData()))
    ]

    public static func storeMock() {
        let storyCloudStorage = StoryCloudStorage()

        Task {
            do {
                for story in mock {
                    _ = try await storyCloudStorage.createStory(authorId: story.authorId, storyData: nil, description: nil)
                }
            } catch {
                print(error)
            }
        }
    }
}
