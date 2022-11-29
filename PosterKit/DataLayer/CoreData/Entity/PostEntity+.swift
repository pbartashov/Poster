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
    typealias DomainModelType = Post

    #warning("TODO")
    func toDomainModel() -> Post {
        Post(uid: url ?? "",
             authorId: User(uid: "kdfjgodfjsadfo").uid,
             content: content ?? "",
//             imageData: imageData,
             likes: Int(likes),
             views: Int(views))
    }

    func copyDomainModel(model: Post) {
        url = model.uid
        author = model.authorId
        content = model.content
//        imageData = model.imageUrl
        likes = Int32(model.likes)
        views = Int32(model.views)
    }
}

//extension UIImage {
//    convenience init?(data: Data?) {
//        guard let data = data else {
//            return nil
//        }
//        self.init(data: data)
//    }
//}
