//
//  FeedViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import Combine

public enum FeedAction {
    case requestData
    case requestRecommendedPosts
    case selected(post: PostViewModel)
    case addToFavorites(post: PostViewModel)
}

public enum FeedState {
    case initial
}

public protocol FeedViewModelProtocol: ViewModelProtocol
where State == FeedState,
      Action == FeedAction {

    var storiesPublisher: Published<[StoryViewModel]>.Publisher { get }
    var postsPublisher: Published<[PostViewModel]>.Publisher { get }
}


public final class FeedViewModel<T>: ViewModel<FeedState, FeedAction>,
                                     FeedViewModelProtocol where T: PostsViewModelProtocol {

    public typealias PostsViewModelType = T
    
    // MARK: - Properties

    private let storageReader: StorageReaderProtocol

    private weak var coordinator: FeedCoordinatorProtocol?

    @Published var stories: [StoryViewModel] = []
    public var storiesPublisher: Published<[StoryViewModel]>.Publisher { $stories }

    private let postsViewModel: PostsViewModelType
    public var postsPublisher: Published<[PostViewModel]>.Publisher { postsViewModel.postsPublisher }

    // MARK: - LifeCicle

    public init(storageReader: StorageReaderProtocol,
                coordinator: FeedCoordinatorProtocol?,
                postsViewModel: PostsViewModelType,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.storageReader = storageReader
        self.coordinator = coordinator
        self.postsViewModel = postsViewModel
        super.init(state: .initial, errorPresenter: errorPresenter)

        setupBindings()
    }

    // MARK: - Metods

    private func setupBindings() {
        storageReader.storiesPublisher?
            .map { [storageReader] stories in
                stories.map { StoryViewModel(from: $0, storageReader: storageReader) }
            }
            .assign(to: &$stories)
    }

    public override func perfomAction(_ action: FeedAction) {
        switch action {
            case .requestData:
                postsViewModel.perfomAction(.requstPosts(filteredBy: nil))
                requestStories()

            case .requestRecommendedPosts:
                let filter = Filter(isRecommended: true)
                postsViewModel.perfomAction(.requstPosts(filteredBy: filter))
                
            case .selected(let post):
                postsViewModel.perfomAction(.selected(post: post))

            case .addToFavorites(post: let post):
                postsViewModel.perfomAction(.addToFavorites(post: post))
        }
    }

    private func requestStories() {
        Task {
            do {
                try await storageReader.startFetchingStories()
            } catch {
                errorPresenter.show(error: error)
            }
        }
    }
}
