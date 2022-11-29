//
//  FeedCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

final class FeedCoordinator: NavigationCoordinator, FeedCoordinatorProtocol {


    //MARK: - Properties

    private let postCoordinator: PostCoordinatorProtocol

    //MARK: - LifeCicle

    override init(navigationController: UINavigationController?) {
        self.postCoordinator = PostCoordinator(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }

    //MARK: - Metods

    func showPost(_ post: Post) {
//        postCoordinator.navigationController = navigationController

//        let postViewController = PostViewController()
//        postViewController.coordinator = postCoordinator
//        postViewController.setup(with: post)
//
//        navigationController?.pushViewController(postViewController, animated: true)
    }

    func showStory() {
        #warning("!!!")
//        pushViewController(_ viewController: UIViewController?)
    }

}
