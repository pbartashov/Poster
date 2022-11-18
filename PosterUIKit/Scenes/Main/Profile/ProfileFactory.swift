//
//  ProfileFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

struct ProfileFactory {

    //MARK: - Properties

//    static var create = ProfileFactory()

    //MARK: - Metods

    func viewModelWith(profileCoordinator: ProfileCoordinatorProtocol?,
                       postsCoordinator: PostsCoordinatorProtocol?,
                       userName: String
    ) -> ProfileViewModel<PostsViewModel> {


        let user = User(name: userName,
                        avatarData: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))?.pngData(),
                        status: "Hardly coding")


        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let postService = UserPostService(repository: postRepository)

        let postsViewModel = PostsViewModel(coordinator: postsCoordinator,
                                            postService: postService,
                                            errorPresenter: ErrorPresenter.shared)
        
        return ProfileViewModel(//postService: postService,
                                coordinator: profileCoordinator,
//                                userService: userService,
                                userName: userName,
                                //postRepository: postRepository,
                                postsViewModel: postsViewModel,
                                errorPresenter: ErrorPresenter.shared)
    }
    
    func viewControllerWith<T>(viewModel: ProfileViewModel<T>) -> UIViewController where T: PostsViewModelProtocol {
        ProfileViewController<ProfileViewModel<T>, T>(viewModel: viewModel)
    }
}
