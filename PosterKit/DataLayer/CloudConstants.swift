//
//  CloudConstants.swift
//  PosterKit
//
//  Created by Павел Барташов on 20.11.2022.
//

public enum Constants {
    public enum Cloud {
        public static let usersCollection = "users"
        public static let postsCollection = "posts"
        public static let storiesCollection = "stories"

        public static let timestamp = "timestamp"
        public static let isRecommended = "is_recommended"

        public static let postImagesStorage = "post_images"
        public static let photosStorage = "user_photos"

        public static let imageFileExtension = "jpg"
        public static let maxSizeToDownload: Int64 = 10 * 1024 * 1024
    }
}
