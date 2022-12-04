//  FavoritesFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 28.11.2022.

import UIKit
import PosterKit

struct FavoritesFactory {

    // MARK: - Properties

    //    static var create = FavoritesFactory()

    // MARK: - Metods

    func viewModelWith(coordinator: PostsCoordinatorProtocol?) -> FavoritesViewModel {
        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let storageReader = LocalStorageReader(repository: postRepository)
        let storageWriter = LocalStorageWriter(repository: postRepository)

        let requestFilter = Filter()

        return FavoritesViewModel(storageReader: storageReader,
                                  storageWriter: storageWriter,
                                  requestFilter: requestFilter,
                                  coordinator: coordinator,
                                  errorPresenter: ErrorPresenter.shared)
    }

    func viewControllerWith(viewModel: FavoritesViewModel) -> UIViewController {
        FavoritesViewController(viewModel: viewModel)
    }
}

