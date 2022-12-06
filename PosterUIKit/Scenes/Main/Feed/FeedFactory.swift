//
//  FeedFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 17.11.2022.
//

import UIKit
import PosterKit

struct FeedFactory {

    // MARK: - Metods

    func viewModelWith(feedCoordinator: FeedCoordinatorProtocol?,
                       postsCoordinator: PostsCoordinatorProtocol?,
                       user: User
    ) -> FeedViewModel<PostsViewModel> {
        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let storageWriter = LocalStorageWriter(repository: postRepository)

        let userCloudStorage = UserCloudStorage()
        let postCloudStorage = PostCloudStorage()
        let imageCloudStorage = ImageCloudStorage(root: PosterKit.Constants.Cloud.postImagesStorage,
                                                  fileExtension: PosterKit.Constants.Cloud.imageFileExtension)
        let storyCloudStorage = StoryCloudStorage()

        let storageReader = CloudStorageReader(userCloudStorage: userCloudStorage,
                                               postCloudStorage: postCloudStorage,
                                               imageCloudStorage: imageCloudStorage,
                                               storyCloudStorage: storyCloudStorage)
        let favoritesPostsHashProvider = PostRepository(context: contextProvider.backgroundContext)
        try? favoritesPostsHashProvider.startFetchingWith(predicate: nil, sortDescriptors: nil)
        let requestFilter = Filter()

        let postsViewModel = PostsViewModel(coordinator: postsCoordinator,
                                            storageReader: storageReader,
                                            storageWriter: storageWriter,
                                            favoritesPostsHashProvider: favoritesPostsHashProvider,
                                            requestFilter: requestFilter,
                                            errorPresenter: ErrorPresenter.shared)
        
        return FeedViewModel(storageReader: storageReader,
                             coordinator: feedCoordinator,
                             postsViewModel: postsViewModel,
                             errorPresenter: ErrorPresenter.shared)
    }
    
    func viewControllerWith<T>(viewModel: FeedViewModel<T>) -> UIViewController where T: PostsViewModelProtocol {
        FeedViewController<FeedViewModel<T>>(viewModel: viewModel)
    }
}
