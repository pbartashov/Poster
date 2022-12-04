//
//  ProfileViewModel.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

public enum ProfileAction {
    case showPhotos
    case showUserProfile
    case showAddPost
    case showAddStory
    case showAddPhoto
//    case selected(post: PostViewModel)
    case insert((post: PostViewModel, index: Int))
    case posts(action: PostsAction)
    case requstPhotos
}

public enum ProfileState {
    case initial
}

public protocol ProfileViewModelProtocol: ViewModelProtocol
where State == ProfileState,
      Action == ProfileAction {

    associatedtype PostsViewModelType: PostsViewModelProtocol

    var postsViewModel: PostsViewModelType { get }
    var posts: [PostViewModel] { get }
    var postsPublisher: Published<[PostViewModel]>.Publisher { get }

    var photos: [Data] { get }
    var photosPublisher: Published<[Data]>.Publisher { get }

    var user: UserViewModel? { get }
}

public final class ProfileViewModel<T, U>: ViewModel<ProfileState, ProfileAction>,
                                        ProfileViewModelProtocol where T: PostsViewModelProtocol,
                                                                       U: PhotosViewModelProtocol {

    public typealias PostsViewModelType = T
    public typealias PhotosViewModelType = U

    // MARK: - Properties

    private weak var coordinator: ProfileCoordinatorProtocol?

//    private let favoritesPostRepository: PostRepositoryInterface
//    private let storageService: PostServiceProtocol
    private let photosViewModel: PhotosViewModelType

    public let postsViewModel: PostsViewModelType

    private weak var userService: UserServiceProtocol?
//    private let userName: String
    public var user: UserViewModel? {
        UserViewModel(from: userService?.currentUser)
    }

    public var posts: [PostViewModel] {
        postsViewModel.posts
    }

    public var postsPublisher: Published<[PostViewModel]>.Publisher {
        postsViewModel.postsPublisher
    }

    public var photos: [Data] {
        photosViewModel.photos
    }

    public var photosPublisher: Published<[Data]>.Publisher {
        photosViewModel.photosPublisher
    }

    // MARK: - LifeCicle

    public init(
//        postService: PostServiceProtocol,
         coordinator: ProfileCoordinatorProtocol?,
         userService: UserServiceProtocol,
//         userName: String,
//         postRepository: PostRepositoryInterface,
         postsViewModel: PostsViewModelType,
         photosViewModel: PhotosViewModelType,
         errorPresenter: ErrorPresenterProtocol
    ) {
        
//        self.storageService = storageService
        self.coordinator = coordinator
        self.userService = userService
//        self.userName = userName
//        self.favoritesPostRepository = postRepository
        self.postsViewModel = postsViewModel
        self.photosViewModel = photosViewModel

        super.init(state: .initial, errorPresenter: errorPresenter)

//        setupViewModel()
    }

    // MARK: - Metods

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

            case .showUserProfile:
                coordinator?.showUserProfile()

            case .showAddPost:
                postsViewModel.perfomAction(.createPost)

            case .showAddStory:
                errorPresenter.show(error: DatabaseError.error(desription: "NotImplemented".localized))

            case .showAddPhoto:
                coordinator?.showAddPhoto()

                //            case .selected(let post):
                //                let
                //                postsViewModel.perfomAction(.store(post: post))

            case let .insert((post, index)):
                postsViewModel.perfomAction(.insert((post, index)))

            case .posts(let action):
                postsViewModel.perfomAction(action)

            case .requstPhotos:
                photosViewModel.perfomAction(.requestPhotos(limit: 4))

        }
    }
}
