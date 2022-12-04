//
//  FeedFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 17.11.2022.
//

import UIKit
import PosterKit

struct FeedFactory {

    // MARK: - Properties

    //    static var create = FeedFactory()

    // MARK: - Metods

    func viewModelWith(feedCoordinator: FeedCoordinatorProtocol?,
                       postsCoordinator: PostsCoordinatorProtocol?,
                       user: User
    ) -> FeedViewModel<PostsViewModel> {


//        let user = User(id: "6", name: "",
//                        avatarData: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))?.pngData(),
//                        status: "Hardly coding")


        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let storageWriter = LocalStorageWriter(repository: postRepository)

        let userCloudStorage = UserCloudStorage()
        let postCloudStorage = PostCloudStorage()
        let imageCloudStorage = ImageCloudStorage(root: PosterKit.Constants.Cloud.postImagesStorage,
                                                  fileExtension: PosterKit.Constants.Cloud.imageFileExtension)

        let storageReader = CloudStorageReader(userCloudStorage: userCloudStorage,
                                               postCloudStorage: postCloudStorage,
                                               imageCloudStorage: imageCloudStorage)
        let requestFilter = Filter()

        let postsViewModel = PostsViewModel(coordinator: postsCoordinator,
                                            storageReader: storageReader,
                                            storageWriter: storageWriter,
                                            requestFilter: requestFilter,
                                            errorPresenter: ErrorPresenter.shared)
        
        return FeedViewModel(//postService: postService,
                             coordinator: feedCoordinator,
                             //                                userService: userService,
                             //                                userName: userName,
//                             postRepository: postRepository,
                             postsViewModel: postsViewModel,
//                             postViewModelProvider: postsViewModel,
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

