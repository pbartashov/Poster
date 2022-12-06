//
//  DetailedPostViewModel.swift
//  PosterKit
//
//  Created by Павел Барташов on 01.12.2022.
//

import Combine

public enum DetailedPostAction {
    case savePost((content: String?, imageData: Data?))
    case dissmiss
}

public enum DetailedPostState {
    case initial
    case saving
}

public protocol DetailedPostViewModelProtocol: ViewModelProtocol
where State == DetailedPostState,
      Action == DetailedPostAction {

    var isNewPost: Bool { get }
    var isEditAllowed: Bool { get }
    var postViewModel: PostViewModel? { get }
    var postViewModelPublisher: Published<PostViewModel?>.Publisher { get }
}

public final class DetailedPostViewModel: ViewModel<DetailedPostState, DetailedPostAction>,
                                          DetailedPostViewModelProtocol {
    // MARK: - Properties

    private let storageWriter: StorageWriterProtocol
    private weak var coordinator: DetailedPostCoordinatorProtocol?
    private let userService: UserServiceProtocol

    @Published public var postViewModel: PostViewModel?
    public var postViewModelPublisher: Published<PostViewModel?>.Publisher {
        $postViewModel
    }

    public var isNewPost: Bool {
        postViewModel == nil
    }

    public var isEditAllowed: Bool

    // MARK: - LifeCicle

    public init(postViewModel: PostViewModel?,
                userService: UserServiceProtocol,
                storageWriter: StorageWriterProtocol,
                coordinator: DetailedPostCoordinatorProtocol?,
                isEditAllowed: Bool,
                errorPresenter: ErrorPresenterProtocol
    ) {
        self.postViewModel = postViewModel
        self.userService = userService
        self.storageWriter = storageWriter
        self.coordinator = coordinator
        self.isEditAllowed = isEditAllowed
        super.init(state: .initial, errorPresenter: errorPresenter)
    }

    // MARK: - Metods

    public override func perfomAction(_ action: DetailedPostAction) {
        switch action {
            case let .savePost((content, imageData)):
                guard let content = content, !content.isEmpty else {
                    errorPresenter.show(error: DatabaseError.error(desription: "missingContent".localized))
                    return
                }
                handleSave(content: content, imageData: imageData)

            case .dissmiss:
                coordinator?.dismissDetailedPost()
        }
    }

    private func handleSave(content: String, imageData: Data?) {
        self.state = .saving
        Task {
            do {
                if let post = postViewModel?.post {
                    let newPost = Post(uid: post.uid,
                                       authorId: post.authorId,
                                       content: content,
                                       likes: post.likes,
                                       views: post.views)
                    try await storageWriter.store(post: newPost,
                                                  imageData: imageData,
                                                  author: userService.currentUser)
                } else if let user = userService.currentUser {
                    try await storageWriter.createPost(author: user,
                                                       content: content,
                                                       imageData: imageData)
                } else {
                    throw LoginError.userNotFound
                }

                coordinator?.dismissDetailedPost()
            } catch {
                self.state = .initial
                errorPresenter.show(error: error)
            }
        }
    }
}
