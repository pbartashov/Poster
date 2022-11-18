//
//  PostsViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 04.09.2022.
//

import Combine

public enum PostsAction {
    case requstPosts
//    case selected(post: Post)
    case insert((post: Post, index: Int))
    case store(post: Post)
    case deletePost(at: IndexPath)
    case showSearchPromt
    case cancelSearch
//    case showError(Error)
}

public enum PostsState {
    case initial
    case loaded([Post])
    case isFiltered(with: String?)
}

public protocol PostsViewModelProtocol: ViewModelProtocol
where State == PostsState,
      Action == PostsAction {

    var posts: [Post] { get }
    var postsPublisher: Published<[Post]>.Publisher { get }
//    var onPostSelected: ((Post) -> Void)? { get set }
//    var requestPosts: (() -> Void)? { get set }
//    var deletePost: ((IndexPath) -> Void)? { get set }
    var searchText: String? { get }
}

public class PostsViewModel: ViewModel<PostsState, PostsAction>,
                             PostsViewModelProtocol {
    //MARK: - Properties

    private weak var coordinator: PostsCoordinatorProtocol?
//    private let errorPresenter: ErrorPresenterProtocol
    let postService: PostServiceProtocol

    private var subscriptions: Set<AnyCancellable> = []

    @Published public var posts: [Post] = []
    public var postsPublisher: Published<[Post]>.Publisher { $posts }

    public private(set) var searchText: String?

//    public var onPostSelected: ((Post) -> Void)?
//    public var requestPosts: (() -> Void)?
//    public var deletePost: ((IndexPath) -> Void)?

    //MARK: - LifeCicle

    public init(coordinator: PostsCoordinatorProtocol?,
                postService: PostServiceProtocol,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.coordinator = coordinator
        self.postService = postService
        super.init(state: .initial, errorPresenter: errorPresenter)

        setupBindings()
    }

    //MARK: - Metods

    private func setupBindings() {
        $posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                guard let self = self else { return }
                self.state = .loaded(posts)
                if self.searchText != nil, posts.isEmpty {
                    self.showRetrySearch()
                }
            }
            .store(in: &subscriptions)

        postService.postsPublisher
            .assign(to: &$posts)

    }

    public override func perfomAction(_ action: PostsAction) {
        switch action {
            case .requstPosts:
                requestPosts()

            case .showSearchPromt:
                coordinator?.showSearchPrompt(title: "searchPromptTitlePostsViewModel".localized,
                                              searchCompletion: { [weak self] text in
                    self?.handleSearch(with: text)
                })

            case .cancelSearch:
                searchText = nil
                state = .isFiltered(with: nil)
                requestPosts()

//            case .selected(let post):
//                selected(post: post)

            case let .insert((post, index)):
                posts.insert(post, at: index)

            case .store(let post):
                store(post: post)

            case .deletePost(let indexPath):
                deletePost(at: indexPath)

//            case .showError(let error):
//                errorPresenter.show(error: error)
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
                                      cancelComlpetion: { [weak self] in
            self?.perfomAction(.cancelSearch)
        })
    }

    private func requestPosts() {
        Task {
            do {
                let filter = Filter(authorName: searchText?.lowercased())
//                posts = try await postService.getPosts(filteredBy: filter)
                try await postService.getPosts(filteredBy: filter)
            } catch {
                errorPresenter.show(error: error)
            }
        }
    }

    private func store(post: Post) {
        Task { [weak self] in
            do {
                try await self?.postService.store(post: post)
            } catch {
                self?.errorPresenter.show(error: error)
            }
        }
    }

    private func deletePost(at indexPath: IndexPath) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let post = self.posts[indexPath.row]
                try await self.postService.remove(post: post)
            } catch {
                self.errorPresenter.show(error: error)
            }
        }
    }

//    private func selected(post: Post) {
//
//    }
}
