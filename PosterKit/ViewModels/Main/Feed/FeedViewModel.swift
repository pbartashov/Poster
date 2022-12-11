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

    var storiesPublisher: AnyPublisher<[StoryViewModel], Never> { get }
    var postsPublisher: AnyPublisher<[DailyPosts], Never> { get }
}


public final class FeedViewModel<T>: ViewModel<FeedState, FeedAction>,
                                     FeedViewModelProtocol where T: PostsViewModelProtocol {

    public typealias PostsViewModelType = T
    
    // MARK: - Properties

    private let storageReader: StorageReaderProtocol

    private weak var coordinator: FeedCoordinatorProtocol?

    @Published var stories: [StoryViewModel] = []
    public var storiesPublisher: AnyPublisher<[StoryViewModel], Never> { $stories.eraseToAnyPublisher() }

    private let postsViewModel: PostsViewModelType
    public var postsPublisher: AnyPublisher<[DailyPosts], Never> {
        postsViewModel.postsPublisher
            .compactMap { [weak self] posts in
                self?.groupDaily(posts)
            }
            .eraseToAnyPublisher()
    }

    let dateFormatter: DMYDateFormatterProtocol

    // MARK: - LifeCicle

    public init(storageReader: StorageReaderProtocol,
                coordinator: FeedCoordinatorProtocol?,
                postsViewModel: PostsViewModelType,
                dateFormatter: DMYDateFormatterProtocol,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.storageReader = storageReader
        self.coordinator = coordinator
        self.postsViewModel = postsViewModel
        self.dateFormatter = dateFormatter
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

    private func groupDaily(_ posts: [PostViewModel]) -> [DailyPosts] {
        let calendar = Calendar.current
        return posts.reduce(into: [DailyPosts]()) { dailyPosts, current in
            let startOfCurrentPostDay = calendar.startOfDay(for: current.timestamp)
            if startOfCurrentPostDay == dailyPosts.last?.timestamp {
                dailyPosts[dailyPosts.count - 1].posts.append(current)
            } else {
                let newDailyPost = DailyPosts(timestamp: startOfCurrentPostDay,
                                              title: dateFormatter.format(date: startOfCurrentPostDay),
                                              posts: [current])
                dailyPosts.append(newDailyPost)
            }
        }
    }
}
