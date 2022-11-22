//
//  MainDependancyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 16.11.2022.
//

import UIKit
import PosterKit

protocol MainDependancyContainerProtocol {
    func makeMainViewController(user: User) -> UIViewController
}

public final class MainDependancyContainer: MainDependancyContainerProtocol {

    // MARK: - Properties

    private var feedCoordinator: FeedCoordinatorProtocol?
    private var feedPostsCoordinator: PostsCoordinatorProtocol?
    private var profileCoordinator: ProfileCoordinatorProtocol?
    private var profilePostsCoordinator: PostsCoordinatorProtocol?
    private var favoritesCoordinator: PostsCoordinatorProtocol?

    private unowned var userService: UserServiceProtocol

    // MARK: - Views

    // MARK: - LifeCicle

    init(feedCoordinator: FeedCoordinatorProtocol? = nil,
         feedPostsCoordinator: PostsCoordinatorProtocol? = nil,
         profileCoordinator: ProfileCoordinatorProtocol? = nil,
         profilePostsCoordinator: PostsCoordinatorProtocol? = nil,
         favoritesCoordinator: PostsCoordinatorProtocol? = nil,
         userService: UserServiceProtocol
    ) {
        self.feedCoordinator = feedCoordinator
        self.feedPostsCoordinator = feedPostsCoordinator
        self.profileCoordinator = profileCoordinator
        self.profilePostsCoordinator = profilePostsCoordinator
        self.favoritesCoordinator = favoritesCoordinator
        self.userService = userService
    }

    // MARK: - Metods

    func makeMainViewController(user: User) -> UIViewController {
        let feedNavigationController = UINavigationController()
        feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        feedPostsCoordinator = PostsCoordinator(navigationController: feedNavigationController)

        let feedViewController = makeFeedViewController(user: user,
                                                        feedCoordinator: feedCoordinator,
                                                        feedPostsCoordinator: feedPostsCoordinator,
                                                        tag: Tab.feed.index)
        feedNavigationController.setViewControllers([feedViewController], animated: false)

        let profileNavigationController = UINavigationController()
        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profilePostsCoordinator = PostsCoordinator(navigationController: profileNavigationController)

        let profileViewController = makeProfileViewController(user: user,
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

    func makeFeedViewController(user: User,
                                feedCoordinator: FeedCoordinatorProtocol?,
                                feedPostsCoordinator: PostsCoordinatorProtocol?,
                                tag: Int
    ) -> UIViewController {
        let feedFactory = FeedFactory()
        let feedViewModel = feedFactory.viewModelWith(feedCoordinator: feedCoordinator,
                                                      postsCoordinator: feedPostsCoordinator,
                                                      user: user)

        let feedViewController = feedFactory.viewControllerWith(viewModel: feedViewModel)

        feedViewController.tabBarItem = UITabBarItem(title: "feedMainDependancyContainer".localized,
                                                     image: UIImage(systemName: "house"),
                                                     tag: tag)
        return feedViewController
    }

    func makeProfileViewController(user: User,
                                   profileCoordinator: ProfileCoordinatorProtocol?,
                                   profilePostsCoordinator: PostsCoordinatorProtocol?,
                                   tag: Int
    ) -> UIViewController {
        let profileFactory = ProfileFactory()
        let profileViewModel = profileFactory.viewModelWith(profileCoordinator: profileCoordinator,
                                                            postsCoordinator: profilePostsCoordinator,
                                                            userService: userService)
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
