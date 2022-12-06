//
//  FavoritePostsViewModel.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 02.09.2022.
//

public protocol FavoritesViewModelProtocol: PostsViewModelProtocol {

}

public final class FavoritesViewModel: PostsViewModel, FavoritesViewModelProtocol {

    // MARK: - LifeCicle

    public init(storageReader: StorageReaderProtocol,
                storageWriter: StorageWriterProtocol,
                requestFilter: Filter,
                coordinator: PostsCoordinatorProtocol?,
                errorPresenter: ErrorPresenterProtocol
    ) {
        super.init(coordinator: coordinator,
                   storageReader: storageReader,
                   storageWriter: storageWriter,
                   favoritesPostsHashProvider: nil,
                   requestFilter: requestFilter,
                   errorPresenter: errorPresenter)
    }
}
