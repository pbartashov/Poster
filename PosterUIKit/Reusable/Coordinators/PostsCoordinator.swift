//
//  PosterUIKit.swift
//  Navigation
//
//  Created by Павел Барташов on 07.09.2022.
//

import UIKit
import PosterKit

final class PostsCoordinator: NavigationCoordinator, PostsCoordinatorProtocol {

    //MARK: - Metods

    func showSearchPrompt(title: String,
                          message: String? = nil,
                          text: String? = nil,
                          searchCompletion: ((String) -> Void)? = nil,
                          cancelComlpetion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        var searchTextField: UITextField?
        alert.addTextField { textField in
            if let text = text {
                textField.text = text
            } else {
                textField.placeholder = "searchTextFieldPlaceholderPostsCoordinator".localized
            }
            
            searchTextField = textField
        }

        let search = UIAlertAction(title: "searchActionTitlePostsCoordinator".localized, style: .default) { _ in
            if let searchText = searchTextField?.text,
               !searchText.isEmpty {
                searchCompletion?(searchText)
            }
        }
        alert.addAction(search)

        if cancelComlpetion != nil {
            let cancel = UIAlertAction(title: "cancelActionTitlePostsCoordinator".localized, style: .default) { _ in
                cancelComlpetion?()
            }
            alert.addAction(cancel)
        }

        navigationController?.present(alert, animated: true)
    }
}
