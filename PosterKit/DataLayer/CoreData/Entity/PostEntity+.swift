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
        Post(url: url ?? "",
             author: User(id: "kdfjgodfjsadfo"),
             description: postDescription ?? "",
             imageData: imageData,
             likes: Int(likes),
             views: Int(views))
    }

    func copyDomainModel(model: Post) {
        url = model.url
        author = model.author.id
        postDescription = model.description
        imageData = model.imageData
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
