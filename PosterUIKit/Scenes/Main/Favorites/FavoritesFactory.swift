//
//  FavoritesFactory.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 02.09.2022.
//

import UIKit
import PosterKit

struct FavoritesFactory {

    //MARK: - Properties

//    static var create = FavoritesFactory()

    //MARK: - Metods

    func viewModelWith(coordinator: PostsCoordinatorProtocol?) -> FavoritesViewModel {
        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.backgroundContext)
        let postService = FavoritesPostService(repository: postRepository)

        return FavoritesViewModel(postService: postService,
                                  coordinator: coordinator,
                                  errorPresenter: ErrorPresenter.shared)
    }

    func viewControllerWith(viewModel: FavoritesViewModel) -> UIViewController {
        FavoritesViewController(viewModel: viewModel)
    }
}
