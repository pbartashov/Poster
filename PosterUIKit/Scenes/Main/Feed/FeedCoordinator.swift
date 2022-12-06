//
//  FeedCoordinator.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

final class FeedCoordinator: NavigationCoordinator, FeedCoordinatorProtocol {

    // MARK: - LifeCicle

    override init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)
    }

    // MARK: - Metods

    func showStory() {
        fatalError("NotImplemented")
    }
}

extension FeedCoordinator: DetailedPostCoordinatorProtocol {
    func dismissDetailedPost() {
        pop(animated: true)
    }
}
