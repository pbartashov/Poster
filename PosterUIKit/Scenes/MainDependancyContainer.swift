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

    private var feedCoordinator: (FeedCoordinatorProtocol&DetailedPostCoordinatorProtocol)?
    private var feedPostsCoordinator: PostsCoordinatorProtocol?
    private var profileCoordinator: (ProfileCoordinatorProtocol&DetailedPostCoordinatorProtocol&UserProfileCoordinatorProtocol)?
    private var profilePostsCoordinator: PostsCoordinatorProtocol?
    private var favoritesCoordinator: (PostsCoordinatorProtocol&DetailedPostCoordinatorProtocol)?

    private unowned var userService: UserServiceProtocol

    // MARK: - LifeCicle

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    // MARK: - Metods

    func makeMainViewController(user: User) -> UIViewController {
        let feedNavigationController = makeFeedViewController(user: user,
                                                              tag: Tab.feed.index)
        let profileNavigationController = makeProfileViewController(tag: Tab.profile.index)

        let favoritesNavigationController = makeFavoritesViewController(coordinator: favoritesCoordinator,
                                                                        tag: Tab.favorites.index)
        let tabBarController = makeTabBarController(with: [
            feedNavigationController,
            profileNavigationController,
            favoritesNavigationController
        ])

        ErrorPresenter.shared.initialize(with: tabBarController)

        return tabBarController
    }

    func makeFeedViewController(user: User, tag: Int) -> UIViewController {
        let feedNavigationController = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        let detailedPostViewControllerFactory: ((PostViewModel?) -> DetailedPostViewController<DetailedPostViewModel>?) = { [weak self] post in
            guard let self = self else { return nil }
            return self.makeDetailedPostViewController(for: post,
                                                       coordinator: self.feedCoordinator,
                                                       isEditAllowed: self.resolveIsPostEditAllowed(for: post))
        }

        let feedPostsCoordinator = PostsCoordinator(navigationController: feedNavigationController,
                                                    detailedPostViewControllerFactory: detailedPostViewControllerFactory)
        let feedFactory = FeedFactory()
        let feedViewModel = feedFactory.viewModelWith(feedCoordinator: feedCoordinator,
                                                      postsCoordinator: feedPostsCoordinator,
                                                      user: user)

        let feedViewController = feedFactory.viewControllerWith(viewModel: feedViewModel)

        feedViewController.tabBarItem = UITabBarItem(title: "feedMainDependancyContainer".localized,
                                                     image: UIImage(systemName: "house"),
                                                     tag: tag)

        feedNavigationController.setViewControllers([feedViewController], animated: false)

        self.feedCoordinator = feedCoordinator
        self.feedPostsCoordinator = feedPostsCoordinator

        return feedNavigationController
    }

    func makeProfileViewController(tag: Int) -> UIViewController {
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        let detailedPostViewControllerFactory: (PostViewModel?) -> DetailedPostViewController<DetailedPostViewModel>? = { [weak self] post in
            guard let self = self else { return nil }
            return self.makeDetailedPostViewController(for: post,
                                                       coordinator: self.profileCoordinator,
                                                       isEditAllowed: self.resolveIsPostEditAllowed(for: post))
        }

        let profilePostsCoordinator = PostsCoordinator(navigationController: profileNavigationController,
                                                       detailedPostViewControllerFactory: detailedPostViewControllerFactory)

        let profileDependancyContainer = ProfileDependancyContainer(profileCoordinator: profileCoordinator,
                                                                    postsCoordinator: profilePostsCoordinator,
                                                                    userService: userService)
        profileCoordinator.dependancyContainer = profileDependancyContainer

        let profileViewModel = profileDependancyContainer.makeProfileViewModel()
        let profileViewController = profileDependancyContainer.makeProfileViewController(viewModel: profileViewModel)

        profileViewController.tabBarItem = UITabBarItem(title: "profileMainDependancyContainer".localized,
                                                        image: UIImage(systemName: "person.circle"),
                                                        tag: tag)

        profileNavigationController.setViewControllers([profileViewController], animated: false)

        self.profileCoordinator = profileCoordinator
        self.profilePostsCoordinator = profilePostsCoordinator

        return profileNavigationController
    }

    func makeFavoritesViewController(coordinator: PostsCoordinatorProtocol?, tag: Int) -> UIViewController {
        let detailedPostViewControllerFactory: (PostViewModel?) -> DetailedPostViewController<DetailedPostViewModel>? = { [weak self] post in
            guard let self = self else { return nil }
            return self.makeDetailedPostViewController(for: post,
                                                       coordinator: self.favoritesCoordinator,
                                                       isEditAllowed: false)
        }

        let favoritesNavigationController = UINavigationController()
        let favoritesCoordinator = PostsCoordinator(navigationController: favoritesNavigationController,
                                                    detailedPostViewControllerFactory: detailedPostViewControllerFactory)
        let favoritesFactory = FavoritesFactory()
        let favoritesViewModel = favoritesFactory.viewModelWith(coordinator: coordinator)
        let favoritesViewController = favoritesFactory.viewControllerWith(viewModel: favoritesViewModel)

        favoritesViewController.tabBarItem = UITabBarItem(title: "favoritesMainDependancyContainer".localized,
                                                          image: UIImage(systemName: "heart"),
                                                          tag: tag)

        favoritesNavigationController.setViewControllers([favoritesViewController], animated: false)

        self.favoritesCoordinator = favoritesCoordinator

        return favoritesNavigationController
    }

    func makeTabBarController(with viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .brandBackgroundColor
        tabBarController.tabBar.tintColor = .brandYellowColor
        
        tabBarController.setViewControllers(viewControllers, animated: true)

        //                tabBarController.selectedIndex = 1

        return tabBarController
    }

    private func resolveIsPostEditAllowed(for postViewModel: PostViewModel?) -> Bool {
        guard let currentUserUid = userService.currentUser?.uid else {
            return false
        }

        guard let postAuthorId = postViewModel?.post.authorId else {
            return true
        }

        return postAuthorId == currentUserUid
    }

    func makeDetailedPostViewController(for postViewModel: PostViewModel?,
                                        coordinator: DetailedPostCoordinatorProtocol?,
                                        isEditAllowed: Bool
    ) -> DetailedPostViewController<DetailedPostViewModel>? {
        let factory = DetailedPostFactory()
        let viewModel = factory.makeDetailedPostViewModel(postViewModel: postViewModel,
                                                          userService: userService,
                                                          coordinator: coordinator,
                                                          isEditAllowed: isEditAllowed)
        return factory.makeDetailedPostViewController(viewModel: viewModel)
    }
}
