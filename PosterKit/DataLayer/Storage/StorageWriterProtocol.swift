//
//  StorageWriterProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 06.12.2022.
//

import Combine

public protocol StorageWriterProtocol {
    func createPost(author: User, content: String, imageData: Data?) async throws
    func store(post: Post, imageData: Data?, author: User?) async throws
    func remove(post: Post) async throws
}
