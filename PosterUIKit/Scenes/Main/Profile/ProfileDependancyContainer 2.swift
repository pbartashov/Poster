//
//  ProfileDependancyContainer.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import PosterKit

protocol ProfileDependancyContainerProtocol {
    func makeProfileViewModel() -> ProfileViewModel<PostsViewModel>

    func makeProfileViewController<T>(viewModel: ProfileViewModel<T>) -> UIViewController where T: PostsViewModelProtocol

    func makePhotosViewController() -> PhotosViewController

    func makeUserProfileViewModel() -> UserProfileViewModel

    func makeUserProfileViewController() -> UserProfileViewController
}


struct ProfileDependancyContainer: ProfileDependancyContainerProtocol {

    // MARK: - Properties

    private weak var profileCoordinator: ProfileCoordinatorProtocol?
    private weak var postsCoordinator: PostsCoordinatorProtocol?
    private unowned var userService: UserServiceProtocol


    // MARK: - LifeCicle
    init(profileCoordinator: ProfileCoordinatorProtocol?,
         postsCoordinator: PostsCoordinatorProtocol?,
         userService: UserServiceProtocol
    ) {
        self.profileCoordinator = profileCoordinator
        self.postsCoordinator = postsCoordinator
        self.userService = userService
    }


    // MARK: - Metods


    func makeProfileViewModel() -> ProfileViewModel<PostsViewModel> {


//        let user = User(id: "5", name: userName,
//                        avatarData: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))?.pngData(),
//                        status: "Hardly coding")


        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let storageWriter = LocalStorageWriter(repository: postRepository)

        let storageReader = CloudStorageReader(userCloudStorage: UserCloudStorage(),
                                               postCloudStorage: PostCloudStorage(),
                                               imageCloudStorage: ImageCloudStorage())

        let requestFilter = Filter(authorId: userService.currentUser?.uid)

        let postsViewModel = PostsViewModel(coordinator: postsCoordinator,
                                            storageReader: storageReader,
                                            storageWriter: storageWriter,
                                            requestFilter: requestFilter,
                                            errorPresenter: ErrorPresenter.shared)
        
        return ProfileViewModel(//storageService: storageService,
                                coordinator: profileCoordinator,
                                userService: userService,
//                                user: user,
                                //postRepository: postRepository,
                                postsViewModel: postsViewModel,
                                errorPresenter: ErrorPresenter.shared)
    }
//
//    func viewControllerWith<T>(viewModel: ProfileViewModel<T>,
//                               postViewModelProvider: PostViewModelProvider
//    ) -> UIViewController where T: PostsViewModelProtocol {
//        ProfileViewController<ProfileViewModel<T>, T>(viewModel: viewModel, postViewModelProvider: postViewModelProvider)
//    }

    func makeProfileViewController<T>(viewModel: ProfileViewModel<T>) -> UIViewController where T: PostsViewModelProtocol {
        ProfileViewController<ProfileViewModel<T>, T>(viewModel: viewModel)
    }

    func makeUserProfileViewModel() -> UserProfileViewModel {
        UserProfileViewModel(userService: userService,
                             coordinator: profileCoordinator,
                             errorPresenter: ErrorPresenter.shared)
    }

    func makeUserProfileViewController() -> UserProfileViewController {
        let viewModel = makeUserProfileViewModel()
        return UserProfileViewController(viewModel: viewModel)
    }

    func makePhotosViewController() -> PhotosViewController {
        PhotosViewController()
    }
}
