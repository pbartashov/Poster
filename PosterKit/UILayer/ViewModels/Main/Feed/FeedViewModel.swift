//
//  FeedViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import Combine

public enum FeedAction {
    case requestData
    case selected(post: PostViewModel)
    case addToFavorites(post: PostViewModel)
//    case showSignUp
//    case showSignIn
//    case authWith(phoneNumber: String)
//    case signUpWith(phoneNumber: String)
//    case comfirmPhoneNumberWith(code: String)
}

public enum FeedState {
    case initial
//    case missingPhoneNumber
//    case missingCode
//    //    case wrongPhoneNumber
//    case authFailed
//    case processing(LoginAction)
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

//    private var favoritesPostRepository: PostRepositoryInterface
    private let storageReader: StorageReaderProtocol

    private weak var coordinator: FeedCoordinatorProtocol?

    @Published var stories: [StoryViewModel] = []
    public var storiesPublisher: Published<[StoryViewModel]>.Publisher { $stories }

    public var postsPublisher: Published<[PostViewModel]>.Publisher { postsViewModel.postsPublisher }

    private let postsViewModel: PostsViewModelType
//    private let postViewModelProvider: PostViewModelProvider




    // MARK: - LifeCicle

    public init(
        storageReader: StorageReaderProtocol,
//                postService: PostServiceProtocol,
                coordinator: FeedCoordinatorProtocol?,
//                userName: String,
//                postRepository: PostRepositoryInterface,
                postsViewModel: PostsViewModelType,
//                postViewModelProvider: PostViewModelProvider,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.storageReader = storageReader
        self.coordinator = coordinator
        //        self.userService = userService
//        self.userName = userName
//        self.favoritesPostRepository = postRepository
        self.postsViewModel = postsViewModel
//        self.postViewModelProvider = postViewModelProvider

        super.init(state: .initial, errorPresenter: errorPresenter)

        setupBindings()



        
//        stories = Story.mock
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
                postsViewModel.perfomAction(.requstPosts)
                requestStories()

            case .selected(let post):
                postsViewModel.perfomAction(.selected(post: post))

            case .addToFavorites(post: let post):
                postsViewModel.perfomAction(.store(post: post))
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
//
//extension FeedViewModel: PostViewModelProvider {
//    public func makeViewModel(for post: Post) -> PostViewModel {
//        postViewModelProvider.makeViewModel(for: post)
//    }
//}
