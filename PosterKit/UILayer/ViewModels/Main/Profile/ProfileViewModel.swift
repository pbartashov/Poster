//
//  ProfileViewModel.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

public enum ProfileAction {
    case showPhotos
    case selected(post: Post)
    case insert((post: Post, index: Int))
    case posts(action: PostsAction)
}

public enum ProfileState {
    case initial
}

public protocol ProfileViewModelProtocol: ViewModelProtocol
where State == ProfileState,
      Action == ProfileAction {

    associatedtype PostsViewModelType: PostsViewModelProtocol

    var postsViewModel: PostsViewModelType { get }
    var posts: [Post] { get }
    var postsPublisher: Published<[Post]>.Publisher { get }

    var user: User? { get }
}

public final class ProfileViewModel<T>: ViewModel<ProfileState, ProfileAction>,
                                        ProfileViewModelProtocol where T: PostsViewModelProtocol {

    public typealias PostsViewModelType = T

    //MARK: - Properties

    private weak var coordinator: ProfileCoordinatorProtocol?

//    private let favoritesPostRepository: PostRepositoryInterface
//    private let postService: PostServiceProtocol
    public let postsViewModel: PostsViewModelType

    private weak var userService: UserServiceProtocol?
//    private let userName: String
    public var user: User? {
        userService?.currentUser
    }

    public var posts: [Post] {
        postsViewModel.posts
    }

    public var postsPublisher: Published<[Post]>.Publisher {
        postsViewModel.postsPublisher
    }

    //MARK: - LifeCicle

    public init(
//        postService: PostServiceProtocol,
         coordinator: ProfileCoordinatorProtocol?,
         userService: UserServiceProtocol,
//         userName: String,
//         postRepository: PostRepositoryInterface,
         postsViewModel: PostsViewModelType,
         errorPresenter: ErrorPresenterProtocol
    ) {
        
//        self.postService = postService
        self.coordinator = coordinator
        self.userService = userService
//        self.userName = userName
//        self.favoritesPostRepository = postRepository
        self.postsViewModel = postsViewModel

        super.init(state: .initial, errorPresenter: errorPresenter)

//        setupViewModel()
    }

    //MARK: - Metods

//    private func setupViewModel() {
//        postsViewModel.onPostSelected = { [weak self] post in
////            Task { [weak self] in
////                do {
//            self?.postsViewModel.perfomAction(.store(post: post))
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

    public override func perfomAction(_ action: ProfileAction) {
        switch action {
            case .showPhotos:
                coordinator?.showPhotos()

            case .selected(let post):
                postsViewModel.perfomAction(.store(post: post))

            case let .insert((post, index)):
                postsViewModel.perfomAction(.insert((post, index)))

            case .posts(let action):
                postsViewModel.perfomAction(action)
        }
    }
}
