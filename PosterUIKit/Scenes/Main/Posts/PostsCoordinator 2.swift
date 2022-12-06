//
//  PosterUIKit.swift
//  Navigation
//
//  Created by Павел Барташов on 07.09.2022.
//

import UIKit
import PosterKit

final class PostsCoordinator: NavigationCoordinator, PostsCoordinatorProtocol {

    // MARK: - Properties

    private let makeDetailedPostViewController: (PostViewModel?) -> DetailedPostViewController<DetailedPostViewModel>?

     // MARK: - LifeCicle
    init(navigationController: UINavigationController,
         detailedPostViewControllerFactory: @escaping (PostViewModel?) -> DetailedPostViewController<DetailedPostViewModel>?
    ) {
        self.makeDetailedPostViewController = detailedPostViewControllerFactory
        super.init(navigationController: navigationController)
    }

    // MARK: - Metods

    // MARK: - Metods

    func showSearchPrompt(title: String,
                          message: String? = nil,
                          text: String? = nil,
                          searchCompletion: ((String) -> Void)? = nil,
                          cancelCompletion: (() -> Void)? = nil) {

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

        if cancelCompletion != nil {
            let cancel = UIAlertAction(title: "cancelActionTitlePostsCoordinator".localized, style: .default) { _ in
                cancelCompletion?()
            }
            alert.addAction(cancel)
        }

        presentViewController(alert)
    }

    func showDetailedPost(_ post: PostViewModel?) {
        let detailedViewController = makeDetailedPostViewController(post)
        pushViewController(detailedViewController)
    }
}

extension PostsCoordinator: DetailedPostCoordinatorProtocol {
    func dismissDetailedPost() {
        pop(animated: true)
    }
}
