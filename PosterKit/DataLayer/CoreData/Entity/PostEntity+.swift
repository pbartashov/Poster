//
//  PostEntity+.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import UIKit
import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
extension PostEntity: DomainModel {
    typealias DomainModelType = PostViewModel

    func toDomainModel() -> PostViewModel {
        let post = Post(uid: uid ?? "",
                        authorId: authorId ?? "",
                        content: content ?? "",
                        likes: Int(likes),
                        views: Int(views))

        let postViewModel = PostViewModel(from: post)
        postViewModel.authorName = authorName
        postViewModel.authorStatus = authorStatus
        postViewModel.authorAvatarData = authorAvatarData
        postViewModel.imageData = imageData

        return postViewModel
    }

    func copyDomainModel(model: PostViewModel) {
        uid = model.post.uid
        authorId = "\(model.post.uid)\(model.post.authorId)"
        authorName = model.authorName
        authorStatus = model.authorStatus
        content = model.content
        authorAvatarData = model.authorAvatarData
        imageData = model.imageData
        likes = Int32(model.likes)
        views = Int32(model.views)
    }
}
