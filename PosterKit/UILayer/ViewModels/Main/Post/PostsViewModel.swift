//
//  PostsViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 04.09.2022.
//

import Combine

public enum PostsAction {
    case requstPosts(filteredBy: Filter?)
    case createPost
    case insert((post: PostViewModel, index: Int))
    case store(post: PostViewModel)
    case deletePost(at: IndexPath)
    case selected(post: PostViewModel)
    case showSearchPromt
    case cancelSearch
    case addToFavorites(post: PostViewModel)
}

public enum PostsState {
    case initial
    case postsLoaded
    case isFiltered(with: String?)
}

public protocol PostsViewModelProtocol: ViewModelProtocol
where State == PostsState,
      Action == PostsAction {

    var posts: [PostViewModel] { get }
    var postsPublisher: Published<[PostViewModel]>.Publisher { get }
    var searchText: String? { get }
}

public class PostsViewModel: ViewModel<PostsState, PostsAction>,
                             PostsViewModelProtocol {
    // MARK: - Properties

    private weak var coordinator: PostsCoordinatorProtocol?
    let storageReader: StorageReaderProtocol
    let storageWriter: StorageWriterProtocol
    let favoritesPostsHashProvider: FavoritesPostsHashProvider?

    private var subscriptions: Set<AnyCancellable> = []

    @Published public var posts: [PostViewModel] = []
    public var postsPublisher: Published<[PostViewModel]>.Publisher { $posts }

    public private(set) var searchText: String?
    private var defaultRequestFilter: Filter

    // MARK: - LifeCicle

    public init(coordinator: PostsCoordinatorProtocol?,
                storageReader: StorageReaderProtocol,
                storageWriter: StorageWriterProtocol,
                favoritesPostsHashProvider: FavoritesPostsHashProvider?,
                requestFilter: Filter,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.coordinator = coordinator
        self.storageReader = storageReader
        self.storageWriter = storageWriter
        self.favoritesPostsHashProvider = favoritesPostsHashProvider
        self.defaultRequestFilter = requestFilter
        super.init(state: .initial, errorPresenter: errorPresenter)

        setupBindings()
    }

    // MARK: - Metods

    private func setupBindings() {
        $posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                guard let self = self else { return }
                self.state = .postsLoaded
                if self.searchText != nil, posts.isEmpty {
                    self.showRetrySearch()
                }
            }
            .store(in: &subscriptions)

        storageReader.postsPublisher
            .map { [storageReader, favoritesPostsHashProvider] posts in
                posts.map { PostViewModel(from: $0,
                                          storageReader: storageReader,
                                          favoritesPostsHashProvider: favoritesPostsHashProvider) }
            }
            .assign(to: &$posts)
    }

    public override func perfomAction(_ action: PostsAction) {
        switch action {
            case let .requstPosts(filter):
                requestPosts(filteredBy: filter)

            case .createPost:
                coordinator?.showDetailedPost(nil)

            case let .insert((post, index)):
                posts.insert(post, at: index)

            case let .store(post):
                store(post: post)

            case let .deletePost(indexPath):
                deletePost(at: indexPath)

            case let .selected(post):
                coordinator?.showDetailedPost(post)

            case .showSearchPromt:
                coordinator?.showSearchPrompt(title: "searchPromptTitlePostsViewModel".localized,
                                              searchCompletion: { [weak self] text in
                    self?.handleSearch(with: text)
                })

            case .cancelSearch:
                searchText = nil
                state = .isFiltered(with: nil)
                requestPosts()

            case .addToFavorites(let post):
                handleAddToFavorites(post: post)
        }
    }

    private func handleSearch(with text: String) {
        searchText = text
        state = .isFiltered(with: text)
        requestPosts()
    }

    private func showRetrySearch() {
        coordinator?.showSearchPrompt(title: "retryPromptTitlePostsViewModel".localized,
                                      message: "retryPromptMessagePostsViewModel".localized,
                                      text: searchText,
                                      searchCompletion: { [weak self] text in
            self?.handleSearch(with: text)
        },
                                      cancelCompletion: { [weak self] in
            self?.perfomAction(.cancelSearch)
        })
    }

    private func requestPosts(filteredBy filter: Filter? = nil) {
        Task {
            do {
                var resultFilter: Filter
                if let filter = filter {
                    resultFilter = defaultRequestFilter.concatenated(to: filter)
                } else {
                    resultFilter = defaultRequestFilter
                }
                resultFilter.content = searchText?.lowercased()

                try await storageReader.startFetchingPosts(filteredBy: resultFilter)
            } catch {
                errorPresenter.show(error: error)
            }
        }
    }

    private func store(post: PostViewModel) {
        Task { [weak self] in
            do {
                try await self?.storageWriter.store(post: post.post,
                                                    imageData: post.imageData,
                                                    author: post.author)
            } catch {
                self?.errorPresenter.show(error: error)
            }
        }
    }

    private func deletePost(at indexPath: IndexPath) {
        delete(post: posts[indexPath.row])
    }

    private func delete(post: PostViewModel) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.storageWriter.remove(post: post.post)
            } catch {
                self.errorPresenter.show(error: error)
            }
        }
    }

    private func handleAddToFavorites(post: PostViewModel) {
        guard let isFavorite = post.isFavorite else { return }
        if isFavorite {
            delete(post: post)
        } else {
            store(post: post)
        }
    }
}
