//
//  MainDependancyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit
import PosterKit

protocol MainDependancyContainerProtocol {
    func makeMainViewController(userName: String) -> UIViewController
}

public final class MainDependancyContainer: MainDependancyContainerProtocol {

    // MARK: - Properties

    private var feedCoordinator: FeedCoordinatorProtocol?
    private var feedPostsCoordinator: PostsCoordinatorProtocol?
    private var profileCoordinator: ProfileCoordinatorProtocol?
    private var profilePostsCoordinator: PostsCoordinatorProtocol?
    private var favoritesCoordinator: PostsCoordinatorProtocol?

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods




    func makeMainViewController(userName: String) -> UIViewController {
        let feedNavigationController = UINavigationController()
        feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        feedPostsCoordinator = PostsCoordinator(navigationController: feedNavigationController)

        let feedViewController = makeFeedViewController(userName: userName,
                                                        feedCoordinator: feedCoordinator,
                                                        feedPostsCoordinator: feedPostsCoordinator,
                                                        tag: Tab.feed.index)
        feedNavigationController.setViewControllers([feedViewController], animated: false)

        let profileNavigationController = UINavigationController()
        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profilePostsCoordinator = PostsCoordinator(navigationController: profileNavigationController)

        let profileViewController = makeProfileViewController(userName: userName,
                                                              profileCoordinator: profileCoordinator,
                                                              profilePostsCoordinator: profilePostsCoordinator,
                                                              tag: Tab.profile.index)
        profileNavigationController.setViewControllers([profileViewController], animated: false)

        let favoritesNavigationController = UINavigationController()
        favoritesCoordinator = PostsCoordinator(navigationController: favoritesNavigationController)
        let favoritesViewController = makeFavoritesViewController(coordinator: favoritesCoordinator,
                                                                  tag: Tab.favorites.index)
        favoritesNavigationController.setViewControllers([favoritesViewController], animated: false)

       let tabBarController = makeTabBarController(with: [
            feedNavigationController,
            profileNavigationController,
            favoritesNavigationController
        ])

        ErrorPresenter.shared.initialize(with: tabBarController)

//        mainTabController = tabBarController

        return tabBarController
    }

    func makeFeedViewController(userName: String,
                                feedCoordinator: FeedCoordinatorProtocol?,
                                feedPostsCoordinator: PostsCoordinatorProtocol?,
                                tag: Int
    ) -> UIViewController {
        let feedFactory = FeedFactory()
        let feedViewModel = feedFactory.viewModelWith(feedCoordinator: feedCoordinator,
                                                      postsCoordinator: feedPostsCoordinator,
                                                      userName: userName)

        let feedViewController = feedFactory.viewControllerWith(viewModel: feedViewModel)

        feedViewController.tabBarItem = UITabBarItem(title: "feedMainDependancyContainer".localized,
                                                     image: UIImage(systemName: "house"),
                                                     tag: tag)
        return feedViewController
    }

    func makeProfileViewController(userName: String,
                                   profileCoordinator: ProfileCoordinatorProtocol?,
                                   profilePostsCoordinator: PostsCoordinatorProtocol?,
                                   tag: Int
    ) -> UIViewController {
        let profileFactory = ProfileFactory()
        let profileViewModel = profileFactory.viewModelWith(profileCoordinator: profileCoordinator,
                                                                   postsCoordinator: profilePostsCoordinator,
                                                                   userName: userName)
        let profileViewController = profileFactory.viewControllerWith(viewModel: profileViewModel)

        profileViewController.tabBarItem = UITabBarItem(title: "profileMainDependancyContainer".localized,
                                                        image: UIImage(systemName: "person.circle"),
                                                        tag: tag)
        return profileViewController
    }

    func makeFavoritesViewController(coordinator: PostsCoordinatorProtocol?, tag: Int) -> UIViewController {
        let favoritesFactory = FavoritesFactory()
        let favoritesViewModel = favoritesFactory.viewModelWith(coordinator: coordinator)
        let favoritesViewController = favoritesFactory.viewControllerWith(viewModel: favoritesViewModel)

        favoritesViewController.tabBarItem = UITabBarItem(title: "favoritesMainDependancyContainer".localized,
                                                          image: UIImage(systemName: "heart"),
                                                          tag: tag)
        return favoritesViewController
    }

    func makeTabBarController(with viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .backgroundColor
        tabBarController.tabBar.tintColor = .brandYellowColor
        
        tabBarController.setViewControllers(viewControllers, animated: true)

//        tabBarController.selectedIndex = 1

        return tabBarController
    }
}
