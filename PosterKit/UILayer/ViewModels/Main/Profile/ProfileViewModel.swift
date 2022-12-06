//
//  ProfileViewModel.swift
//  PosterUIKit
//
//  Created by Павел Барташов on 25.06.2022.
//

import Combine

public enum ProfileAction {
    case showPhotos
    case showUserProfile
    case showAddPost
    case showAddStory
    case showAddPhoto
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

    var userPublisher: Published<UserViewModel?>.Publisher { get }
}

public final class ProfileViewModel<T, U>: ViewModel<ProfileState, ProfileAction>,
                                           ProfileViewModelProtocol where T: PostsViewModelProtocol,
                                                                          U: PhotosViewModelProtocol {
    public typealias PostsViewModelType = T
    public typealias PhotosViewModelType = U

    // MARK: - Properties

    private weak var coordinator: ProfileCoordinatorProtocol?

    private let photosViewModel: PhotosViewModelType

    public let postsViewModel: PostsViewModelType

    private weak var userService: UserServiceProtocol?

    @Published public var userViewModel: UserViewModel?
    public var userPublisher: Published<UserViewModel?>.Publisher {
        $userViewModel
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

    public init(coordinator: ProfileCoordinatorProtocol?,
                userService: UserServiceProtocol,
                postsViewModel: PostsViewModelType,
                photosViewModel: PhotosViewModelType,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.coordinator = coordinator
        self.userService = userService
        self.postsViewModel = postsViewModel
        self.photosViewModel = photosViewModel
        super.init(state: .initial, errorPresenter: errorPresenter)

        setupViewModel()
    }

    // MARK: - Metods

    private func setupViewModel() {
        userService?.currentUserPublisher
            .map { UserViewModel(from: $0) }
            .assign(to: &$userViewModel)
    }

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

            case let .insert((post, index)):
                postsViewModel.perfomAction(.insert((post, index)))

            case .posts(let action):
                postsViewModel.perfomAction(action)

            case .requstPhotos:
                photosViewModel.perfomAction(.requestPhotos(limit: 4))
        }
    }
}
