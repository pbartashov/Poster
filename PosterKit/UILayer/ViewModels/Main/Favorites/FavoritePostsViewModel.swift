//
//  FavoritePostsViewModel.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 02.09.2022.
//

public protocol FavoritesViewModelProtocol: PostsViewModelProtocol {

}

public final class FavoritesViewModel: PostsViewModel, FavoritesViewModelProtocol {

    //MARK: - Properties

//    private let favoritesPostRepository: PostRepositoryInterface

    //MARK: - LifeCicle

    public init(//postService: PostServiceProtocol,
        storageReader: StorageReaderProtocol,
        storageWriter: StorageWriterProtocol,
        requestFilter: Filter,
         coordinator: PostsCoordinatorProtocol?,
         errorPresenter: ErrorPresenterProtocol
    ) {
//        self.favoritesPostRepository = postRepository
        super.init(coordinator: coordinator,
//                   postService: postService,
                   storageReader: storageReader,
                   storageWriter: storageWriter,
                   requestFilter: requestFilter,
                   errorPresenter: errorPresenter)

//        setupHandlers()
    }

    //MARK: - Metods

//    private func setupHandlers() {
//        requestPosts = { [weak self] in
//            Task { [weak self] in
//                guard let self = self else { return }
//                do {
//                    var predicate: NSPredicate? = nil
//                    if let text = self.searchText {
//                        predicate = NSPredicate(format: "author CONTAINS[c] %@", text)
//                    }
//                    try self.favoritesPostRepository.startFetchingWith(predicate: predicate,
//                                                                       sortDescriptors: nil)
//
//                    self.posts = self.favoritesPostRepository.fetchResults
//                } catch {
//                    self.errorPresenter.show(error: error)
//                }
//            }
//        }

//        deletePost = { indexPath in
//            Task { [weak self] in
//                guard let self = self else { return }
//                do {
//                    let post = self.posts[indexPath.row]
//                    try await self.favoritesPostRepository.delete(post: post)
//                    try await self.favoritesPostRepository.saveChanges()
//                } catch {
//                    self.errorPresenter.show(error: error)
//                }
//            }
//        }

      
//    }
}
