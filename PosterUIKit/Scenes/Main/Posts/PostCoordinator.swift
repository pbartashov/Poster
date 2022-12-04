//
//  PostCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 15.11.2022.
//

//import UIKit
//import PosterKit
//
//protocol PostCoordinatorProtocol {
//    func showInfo()
//    func showDetailedPost(_ post: PostViewModel)
//}
//
//final class PostCoordinator: NavigationCoordinator, PostCoordinatorProtocol {
//
//    // MARK: - Properties
//
//    private let makeDetailedPostViewController: (PostViewModel) -> DetailedPostViewController
//
//    // MARK: - Views
//
//    // MARK: - LifeCicle
//    init(detailedPostViewControllerFactory: @escaping (PostViewModel) -> DetailedPostViewController) {
//        self.makeDetailedPostViewController = detailedPostViewControllerFactory
//    }
//
//    // MARK: - Metods
//
//    func showInfo() {
////        let infoViewController = InfoViewController()
////        presentViewController(infoViewController)
//    }
//
//    func showDetailedPost(_ post: PostViewModel) {
//        let detailedViewController = makeDetailedPostViewController(post)
//        pushViewController(detailedViewController)
//    }
//}
