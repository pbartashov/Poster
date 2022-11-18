//
//  PostsCoordinatorProtocol.swift
//  PosterKit
//
//  Created by Павел Барташов on 14.11.2022.
//

public protocol PostsCoordinatorProtocol: AnyObject {
    func showSearchPrompt(title: String,
                          message: String?,
                          text: String?,
                          searchCompletion: ((String) -> Void)?,
                          cancelComlpetion: (() -> Void)?)
}


extension PostsCoordinatorProtocol {
    func showSearchPrompt(title: String,
                          message: String? = nil,
                          text: String? = nil,
                          searchCompletion: ((String) -> Void)? = nil,
                          cancelComlpetion: (() -> Void)? = nil) {
        showSearchPrompt(title: title,
                         message: message,
                         text: text,
                         searchCompletion: searchCompletion,
                         cancelComlpetion: cancelComlpetion)
    }
}
