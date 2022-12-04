//
//  UserViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 30.11.2022.
//

public final class UserViewModel {

    // MARK: - Properties

    private let formatter = KMBFormatter()

    public let user: User

    public var avatarData: Data? { user.avatarData }
    public var displayedName: String? { user.displayedName }
    public var status: String? { user.status }

    public var publishedPostsCountText: String {
        format(localizedKey: "publishedCount", number: user.publishedPostsCount)
    }

    public var subsribesCountText: String {
        format(localizedKey: "subsribesCount", number: user.subsribesCount)
    }

    public var followersCountText: String {
        format(localizedKey: "followersCount", number: user.followersCount)
    }

    // MARK: - LifeCicle

    public init?(from user: User?
//                storageReader: StorageReaderProtocol
    ) {
        if let user = user {
            self.user = user
        } else {
          return nil
        }
//        self.storageReader = storageReader
    }

    // MARK: - Metods
    private func format(localizedKey: String, number: Int?) -> String {
        let number = number ?? 0
        let description = String.localizedStringWithFormat(localizedKey.localized, number)
        return "\(formatter.string(fromNumber: number))\n\(description)"
    }
}



