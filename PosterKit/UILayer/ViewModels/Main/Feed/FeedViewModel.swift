//
//  FeedViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 15.11.2022.
//

import Combine

public enum FeedAction {
    case requestData
    case selected(post: Post)
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

    var storiesPublisher: Published<[Story]>.Publisher { get }
    var postsPublisher: Published<[Post]>.Publisher { get }
}


public final class FeedViewModel<T>: ViewModel<FeedState, FeedAction>,
                                  FeedViewModelProtocol where T: PostsViewModelProtocol {

    public typealias PostsViewModelType = T
    
    // MARK: - Properties

//    private var favoritesPostRepository: PostRepositoryInterface
//    private var postService: PostServiceProtocol

    private weak var coordinator: FeedCoordinatorProtocol?

    @Published var stories: [Story] = []
    public var storiesPublisher: Published<[Story]>.Publisher { $stories }

    public var postsPublisher: Published<[Post]>.Publisher { postsViewModel.postsPublisher }

    private var postsViewModel: PostsViewModelType




    // MARK: - LifeCicle

    public init(
        //storiesService: StoriesServiceProtocol,
//                postService: PostServiceProtocol,
                coordinator: FeedCoordinatorProtocol?,
//                userName: String,
//                postRepository: PostRepositoryInterface,
                postsViewModel: PostsViewModelType,
                errorPresenter: ErrorPresenterProtocol
    ) {
//        self.postService = postService
        self.coordinator = coordinator
        //        self.userService = userService
//        self.userName = userName
//        self.favoritesPostRepository = postRepository
        self.postsViewModel = postsViewModel

        super.init(state: .initial, errorPresenter: errorPresenter)

//        setupViewModel()



        
        stories = Story.mock
      }



    //MARK: - Metods

//    private func setupViewModel() {
//        postsViewModel.onPostSelected = { [weak self] post in
//            self?.postsViewModel.perfomAction(.store(post: post))
////            Task { [weak self] in
////                do {
////                    try await self?.postsViewModel.perfomAction(.store(post: post))
////                } catch {
////                    self?.errorPresenter.show(error: error)
////                }
////            }
//        }
//
////        postsViewModel.requestPosts = { [weak self] in
////            self?.postService.getPosts { [weak self] result in
////                switch result {
////                    case .success(var posts):
////                        if var text = self?.postsViewModel.searchText {
////                            text = text.lowercased()
////                            posts = posts.filter { $0.author.lowercased().contains(text)}
////                        }
////                        self?.postsViewModel.posts = posts
////
////                    case .failure(let error):
////                        self?.errorPresenter.show(error: error)
////                }
////            }
////        }
//    }

    public override func perfomAction(_ action: FeedAction) {
        switch action {
            case .requestData:
                postsViewModel.perfomAction(.requstPosts)

            case .selected(let post):
                postsViewModel.perfomAction(.store(post: post))
        }
    }

}
