//
//  FeedFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 17.11.2022.
//

import UIKit
import PosterKit

struct FeedFactory {

    //MARK: - Properties

    //    static var create = ProfileFactory()

    //MARK: - Metods

    func viewModelWith(feedCoordinator: FeedCoordinatorProtocol?,
                       postsCoordinator: PostsCoordinatorProtocol?,
                       userName: String
    ) -> FeedViewModel<PostsViewModel> {


        let user = User(name: "",
                        avatarData: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))?.pngData(),
                        status: "Hardly coding")


        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let postService = FeedPostService(repository: postRepository)

        let postsViewModel = PostsViewModel(coordinator: postsCoordinator,
                                            postService: postService,
                                            errorPresenter: ErrorPresenter.shared)
        
        return FeedViewModel(//postService: postService,
                             coordinator: feedCoordinator,
                             //                                userService: userService,
                             //                                userName: userName,
//                             postRepository: postRepository,
                             postsViewModel: postsViewModel,
                             errorPresenter: ErrorPresenter.shared)
    }
    
    func viewControllerWith<T>(viewModel: FeedViewModel<T>) -> UIViewController where T: PostsViewModelProtocol {
        FeedViewController<FeedViewModel<T>>(viewModel: viewModel)
    }

//    func viewControllerWith<T>(viewModel: ProfileViewModel<T>) -> UIViewController where T: PostsViewModelProtocol {
//        ProfileViewController<ProfileViewModel<T>, T>(viewModel: viewModel)
//    }

//    func viewControllerWith(viewModel: FeedViewModel) -> UIViewController {
//        FeedViewController(viewModel: viewModel)
//    }
}

